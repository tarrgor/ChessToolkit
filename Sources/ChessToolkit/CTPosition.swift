//
//  CTPosition.swift
//  ChessDB
//
//  Created by Thorsten Klusemann on 11.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

/// Custom protocol variation of Hashable to return an UInt64 instead
/// of an Int
public protocol CTHashable: Equatable {
  var hashKey: UInt64 { get }
}

public final class CTPosition {
  fileprivate var _posData = Array(repeating: (CTPiece).invalid, count: 144)
  fileprivate var _castlingRights = CTCastlingRights()
  fileprivate var _sideToMove : CTSide = .white
  fileprivate var _enPassantSquare : CTSquare?
  fileprivate var _halfMoveClock : Int = 0
  fileprivate var _fullMoveNumber : Int = 1
  fileprivate var _promotionPieceWhite: CTPiece = .whiteQueen
  fileprivate var _promotionPieceBlack: CTPiece = .blackQueen
  
  fileprivate var _moveGenerator: CTMoveGenerator!
  
  fileprivate var _moveHistory = [CTMove]()
  
  fileprivate var _hashKey: UInt64 = 0
  
  // MARK: - Public properties
  
  public var enPassantSquare: CTSquare? {
    return _enPassantSquare
  }
  
  public var halfMoveClock: Int {
    return _halfMoveClock
  }
  
  public var promotionPieceWhite: CTPiece {
    get {
      return _promotionPieceWhite
    }
    set {
      if newValue == .whiteQueen || newValue == .whiteRook || newValue == .whiteBishop || newValue == .whiteKnight {
        _promotionPieceWhite = newValue
      }
    }
  }
  
  public var promotionPieceBlack: CTPiece {
    get {
      return _promotionPieceBlack
    }
    set {
      if newValue == .blackQueen || newValue == .blackRook || newValue == .blackBishop || newValue == .blackKnight {
        _promotionPieceBlack = newValue
      }
    }
  }
  
  public var castlingRights: CTCastlingRights {
    return _castlingRights
  }
  
  public var sideToMove: CTSide {
    return _sideToMove
  }
  
  public var moveNumber: Int {
    return _fullMoveNumber
  }
  
  public var lastMove: CTMove? {
    return _moveHistory.last
  }
  
  public var moveGenerator: CTMoveGenerator {
    return self._moveGenerator
  }
  
  public var check: Bool {
    var result = false
    let opposite: CTSide = sideToMove == .white ? .black : .white
    let king: CTPiece = sideToMove == .white ? .whiteKing : .blackKing
    
    filterPiece(king) { [weak self] square in
      let attacks = self!._moveGenerator.attackingMovesForSquare(square, attackSide: opposite)
      if attacks.count > 0 {
        result = true
      }
    }
    
    return result
  }
  
  // MARK: - Initialization
  
  public init() {
    setupInitialPosition()
    _moveGenerator = CTMoveGenerator(position: self)
  }
  
  public init(fen: String) {
    setToFEN(fen)
    _moveGenerator = CTMoveGenerator(position: self)
  }
  
  public func setupInitialPosition() {
    _posData = CTConstants.kInitialPosition
    _castlingRights = CTCastlingRights()
    _sideToMove = .white
    _enPassantSquare = nil
    _halfMoveClock = 0
    _fullMoveNumber = 1
    self._hashKey = calculateHashKey()
  }
  
  public func pieceAt(_ square: CTSquare) -> CTPiece {
    return _posData[square.rawValue]
  }
  
  public func setPiece(_ piece: CTPiece, square: CTSquare, hash: Bool = false) {
    if hash {
      let existingPiece = pieceAt(square)
      if existingPiece != .empty && existingPiece != .invalid {
        removeHash(for: existingPiece, from: square)
      }
    }
    _posData[square.rawValue] = piece
    if hash { addHash(for: piece, on: square) }
  }
  
  public func removePieceAt(_ square: CTSquare, hash: Bool = false) {
    if hash { removeHash(for: pieceAt(square), from: square) }
    _posData[square.rawValue] = .empty
  }
  
  func setToFEN(_ fen: String) {
    let parser = CTFENParser(fen: fen)
    
    _posData = parser.posData
    _enPassantSquare = parser.enPassantSquare
    _castlingRights = parser.castlingRights
    _sideToMove = parser.sideToMove
    _halfMoveClock = parser.halfMoveClock
    _fullMoveNumber = parser.fullMoveNumber
    self._hashKey = calculateHashKey()
  }
  
  @discardableResult
  public func makeMove(from: CTSquare, to: CTSquare, validate: Bool = true, notifications: Bool = true) -> Bool {
    // Validation
    guard var move = validateMove(from, to: to, validate: validate) else { return false }
    
    // Execute move in the position
    let piece = pieceAt(move.from)
    removePieceAt(move.from, hash: true)
    setPiece(piece, square: move.to, hash: true)
    
    if move.castling {
      handleCastling(move)
    }
    
    if move.enPassant {
      handleEnPassant(move)
    }
    
    if move.promotion {
      handlePromotion(move)
    }
    
    // Adjust castling flags
    hashCastlingRights()
    if move.piece == .whiteKing {
      _castlingRights.whiteCanCastleLong = false
      _castlingRights.whiteCanCastleShort = false
    } else if move.piece == .blackKing {
      _castlingRights.blackCanCastleLong = false
      _castlingRights.blackCanCastleShort = false
    } else if move.piece == .whiteRook && move.from == .a1 {
      _castlingRights.whiteCanCastleLong = false
    } else if move.piece == .whiteRook && move.from == .h1 {
      _castlingRights.whiteCanCastleShort = false
    } else if move.piece == .blackRook && move.from == .a8 {
      _castlingRights.blackCanCastleLong = false
    } else if move.piece == .blackRook && move.from == .h8 {
      _castlingRights.blackCanCastleShort = false
    }
    hashCastlingRights()
    
    // Set en passant square if needed
    hashEpSquare()
    _enPassantSquare = enPassantSquareAfterMove(move)
    hashEpSquare()
    
    // Switch side to move
    switchSideToMove()
    
    // Set check flag if necessary
    move.setCheck(check)
    
    // Increase full move number after Black move
    if (_sideToMove == .white) {
      _fullMoveNumber += 1
    }
    
    // Save the played move into the history for takeback option
    _moveHistory.append(move)
    
    // Send notification DidMakeMove
    if notifications {
      let notificationCenter = NotificationCenter.default
      notificationCenter.post(name: Notification.Name(rawValue: CTConstants.kNotificationPositionDidMakeMove),
                              object: self, userInfo: [ CTConstants.kUserInfoAttributeMove : CTObjectWrapper<CTMove>(wrappedValue: move) ])
    }

    //assert(_hashKey == calculateHashKey())

    return true
  }
  
  @discardableResult
  public func takeBackMove() -> Bool {
    // Get the last move out of history
    guard let move = _moveHistory.last else { return false }
    
    // Takeback move in the position
    let piece = move.piece
    removePieceAt(move.to, hash: true)
    setPiece(piece, square: move.from, hash: true)
    
    // Castling? Re-Position the rook.
    if move.castling {
      handleTakeBackCastling(move)
    }
    
    // Restore enPassant square
    hashEpSquare()
    _enPassantSquare = move.enPassantSquareBeforeMove
    hashEpSquare()
    
    // Bring back captured piece if exists
    if move.captured != .empty && move.captured != .invalid {
      var captureSquare = move.to
      if move.enPassant {
        captureSquare = move.piece.side() == .white ? move.to.down()! : move.to.up()!
      }
      setPiece(move.captured, square: captureSquare, hash: true)
    }
    
    // Re-Set castling rights
    hashCastlingRights()
    _castlingRights = move.castlingRightsBeforeMove
    hashCastlingRights()
    
    // Switch side to move
    switchSideToMove()
    
    // Decrease full move number when White's move was taken back
    if _sideToMove == .black {
      _fullMoveNumber -= 1
    }
    
    // Remove last move from history
    _moveHistory.removeLast()
    
    //assert(_hashKey == calculateHashKey())

    return true
  }
  
  public func filterPiece(_ piece: CTPiece, action: (CTSquare) -> ()) {
    for square in CTSquare.allSquares {
      if _posData[square.rawValue] == piece {
        action(square)
      }
    }
  }
  
  // MARK: Conversion methods
  
  public func toFEN() -> String {
    let parser = CTFENParser()
    parser.posData = _posData
    parser.castlingRights = _castlingRights
    parser.enPassantSquare = _enPassantSquare
    parser.fullMoveNumber = _fullMoveNumber
    parser.halfMoveClock = _halfMoveClock
    parser.sideToMove = _sideToMove
    
    return parser.fen
  }
  
  // MARK: Private methods
  
  fileprivate func hashCastlingRights() {
    _hashKey ^= HashUtils.shared.hash(for: castlingRights)
  }
  
  fileprivate func hashEpSquare() {
    if _enPassantSquare != nil {
      _hashKey ^= HashUtils.shared.hash(for: _enPassantSquare!)
    }
  }
  
  fileprivate func removeHash(for piece: CTPiece, from square: CTSquare) {
    if piece != .empty && piece != .invalid {
      _hashKey ^= HashUtils.shared.hash(for: piece, on: square)
    }
  }
  
  fileprivate func addHash(for piece: CTPiece, on square: CTSquare) {
    if piece != .empty && piece != .invalid {
      _hashKey ^= HashUtils.shared.hash(for: piece, on: square)
    }
  }
  
  fileprivate func switchSideToMove() {
    _sideToMove = _sideToMove == .white ? .black : .white
    _hashKey ^= HashUtils.shared.sideHashKey
  }
  
  fileprivate func validateMove(_ from: CTSquare, to: CTSquare, validate: Bool) -> CTMove? {
    // Validation
    if (!validate) {
      return CTMoveBuilder.build(self, from: from, to: to)
    }
    
    let moves = _moveGenerator.generateAllMovesForSide(sideToMove)
    let validMoves = moves.filter { [weak self] currentMove in
      if currentMove.promotion {
        if currentMove.from == from && currentMove.to == to && currentMove.promotionPiece == (self?.sideToMove == .white ? self?.promotionPieceWhite : self?.promotionPieceBlack) {
          return true
        }
      } else {
        if currentMove.from == from && currentMove.to == to {
          return true
        }
      }
      
      return false
    }
    return validMoves.count == 1 ? validMoves[0] : nil
  }
  
  fileprivate func handleCastling(_ move: CTMove) {
    switch move.to {
    case .c1:
      removePieceAt(.a1, hash: true)
      setPiece(.whiteRook, square: .d1, hash: true)
    case .g1:
      removePieceAt(.h1, hash: true)
      setPiece(.whiteRook, square: .f1, hash: true)
    case .c8:
      removePieceAt(.a8, hash: true)
      setPiece(.blackRook, square: .d8, hash: true)
    case .g8:
      removePieceAt(.h8, hash: true)
      setPiece(.blackRook, square: .f8, hash: true)
    default:
      print("Invalid castling.")
    }
  }
  
  fileprivate func handleEnPassant(_ move: CTMove) {
    let side = move.piece.side()
    if side == .white {
      let target = move.to.down()
      removePieceAt(target!, hash: true)
    }
    if side == .black {
      let target = move.to.up()
      removePieceAt(target!, hash: true)
    }
  }
  
  fileprivate func handlePromotion(_ move: CTMove) {
    setPiece(move.promotionPiece, square: move.to, hash: true)
  }
  
  fileprivate func enPassantSquareAfterMove(_ move: CTMove) -> CTSquare? {
    var epSquare: CTSquare? = nil
    
    if move.piece == .whitePawn {
      if let testSquare = move.to.down()?.down() {
        if testSquare == move.from {
          if let leftTarget = move.to.left() {
            if pieceAt(leftTarget) == .blackPawn {
              epSquare = move.to.down()
            }
          } else if let rightTarget = move.to.right() {
            if pieceAt(rightTarget) == .blackPawn {
              epSquare = move.to.down()
            }
          }
        }
      }
    } else if move.piece == .blackPawn {
      if let testSquare = move.to.up()?.up() {
        if testSquare == move.from {
          if let leftTarget = move.to.left() {
            if pieceAt(leftTarget) == .whitePawn {
              epSquare = move.to.up()
            }
          } else if let rightTarget = move.to.right() {
            if pieceAt(rightTarget) == .whitePawn {
              epSquare = move.to.up()
            }
          }
        }
      }
    }
    return epSquare
  }
  
  fileprivate func handleTakeBackCastling(_ move: CTMove) {
    switch move.to {
    case .g1:
      removePieceAt(.f1, hash: true)
      setPiece(.whiteRook, square: .h1, hash: true)
    case .c1:
      removePieceAt(.d1, hash: true)
      setPiece(.whiteRook, square: .a1, hash: true)
    case .g8:
      removePieceAt(.f8, hash: true)
      setPiece(.blackRook, square: .h8, hash: true)
    case .c8:
      removePieceAt(.d8, hash: true)
      setPiece(.blackRook, square: .a8, hash: true)
    default:
      print("Invalid castling.")
    }
  }
}

extension CTPosition: CustomStringConvertible {
  public var description: String {
    var result = ""
    for row in (0...7).reversed() {
      for col in 0...7 {
        if let square = CTSquare.fromRow(row, column: col) {
          result += "\(pieceAt(square).description) "
        } else {
          result += "?? "
        }
      }
      result += "\n"
    }
    return result
  }
}

extension CTPosition: CTHashable {
  
  public var hashKey: UInt64 {
    return self._hashKey
  }
  
  func calculateHashKey() -> UInt64 {
    var result: UInt64 = 0
    for square in CTSquare.allSquares {
      let piece = pieceAt(square)
      if piece != .empty && piece != .invalid {
        result ^= HashUtils.shared.hash(for: piece, on: square)
      }
    }

    if self.sideToMove == .white {
      result ^= HashUtils.shared.sideHashKey
    }
    if enPassantSquare != nil {
      result ^= HashUtils.shared.hash(for: enPassantSquare!)
    }
    result ^= HashUtils.shared.hash(for: castlingRights)
    return result
  }
  
}

public func ==(lhs: CTPosition, rhs: CTPosition) -> Bool {
  return lhs.hashKey == rhs.hashKey
}




