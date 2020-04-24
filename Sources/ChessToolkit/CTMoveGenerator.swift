//
//  CTMoveGenerator.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 16.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

public final class CTMoveGenerator {
  
  var position: CTPosition
  
  // MARK: Initialization
  
  public required init(position: CTPosition) {
    self.position = position
  }
  
  // MARK: Move generation
  
  func generateWhitePawnMoves(captureOnly: Bool = false) -> [CTMove] {
    var moves = [CTMove]()
    
    position.filterPiece(.whitePawn) { [weak self] square in
      if !captureOnly {
        if let target = square.up() {
          if self!.position.pieceAt(target) == .empty {
            moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
            if square.rawValue >= 38 && square.rawValue <= 45 {
              if let target2 = target.up() {
                if self!.position.pieceAt(target2) == .empty {
                  moves.append(CTMoveBuilder.build(self!.position, from: square, to: target2))
                }
              }
            }
          }
        }
      }
      if let target = square.upLeft() {
        if self!.position.pieceAt(target).side() == .black || self!.position.enPassantSquare == target {
          moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
        }
      }
      if let target = square.upRight() {
        if self!.position.pieceAt(target).side() == .black || self!.position.enPassantSquare == target {
          moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
        }
      }
    }
    
    return moves
  }
  
  func generateBlackPawnMoves(captureOnly: Bool = false) -> [CTMove] {
    var moves = [CTMove]()
    
    position.filterPiece(.blackPawn) { [weak self] square in
      if !captureOnly {
        if let target = square.down() {
          if self!.position.pieceAt(target) == .empty {
            moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
            if square.rawValue >= 98 && square.rawValue <= 105 {
              if let target2 = target.down() {
                if self!.position.pieceAt(target2) == .empty {
                  moves.append(CTMoveBuilder.build(self!.position, from: square, to: target2))
                }
              }
            }
          }
        }
      }
      if let target = square.downLeft() {
        if self!.position.pieceAt(target).side() == .white || self!.position.enPassantSquare == target {
          moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
        }
      }
      if let target = square.downRight() {
        if self!.position.pieceAt(target).side() == .white || self!.position.enPassantSquare == target {
          moves.append(CTMoveBuilder.build(self!.position, from: square, to: target))
        }
      }
    }
    
    return moves
  }
  
  func generateKnightMoves(_ side: CTSide, captureOnly: Bool = false) -> [CTMove] {
    let piece: CTPiece = side == .white ? .whiteKnight : .blackKnight
    
    var moves = [CTMove]()
    
    position.filterPiece(piece) { [weak self] square in
      let targets: [CTSquare?] = [
        square.down()?.downLeft(),
        square.down()?.downRight(),
        square.right()?.downRight(),
        square.right()?.upRight(),
        square.up()?.upRight(),
        square.up()?.upLeft(),
        square.left()?.upLeft(),
        square.left()?.downLeft()
      ]
      
      for target in targets {
        if let target = target, let gen = self {
          if gen.position.pieceAt(target).side() != side {
            let move = CTMoveBuilder.build(gen.position, from: square, to: target)
            if !captureOnly || move.captured != .empty {
              moves.append(move)
            }
          }
        }
      }
    }
    
    return moves
  }
  
  func generateBishopMoves(_ side: CTSide, captureOnly: Bool = false) -> [CTMove] {
    let piece: CTPiece = side == .white ? .whiteBishop : .blackBishop
    
    var moves = [CTMove]()
    
    position.filterPiece(piece) { [weak self] square in
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.upLeft() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.upRight() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.downLeft() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.downRight() })
    }
    
    return moves
  }
  
  func generateRookMoves(_ side: CTSide, captureOnly: Bool = false) -> [CTMove] {
    let piece: CTPiece = side == .white ? .whiteRook : .blackRook
    
    var moves = [CTMove]()
    
    position.filterPiece(piece) { [weak self] square in
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.up() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.down() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.left() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.right() })
    }
    
    return moves
  }
  
  func generateQueenMoves(_ side: CTSide, captureOnly: Bool = false) -> [CTMove] {
    let piece: CTPiece = side == .white ? .whiteQueen : .blackQueen
    
    var moves = [CTMove]()
    
    position.filterPiece(piece) { [weak self] square in
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.upLeft() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.upRight() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.downLeft() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.downRight() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.up() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.down() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.left() })
      moves.append(contentsOf: self!.movesInLine(side: side, piece: piece, square: square, captureOnly: captureOnly) {
        target in return target.right() })
    }
    
    return moves
  }
  
  func generateKingMoves(_ side: CTSide, captureOnly: Bool = false) -> [CTMove] {
    let piece: CTPiece = side == .white ? .whiteKing : .blackKing
    
    var moves = [CTMove]()
    
    position.filterPiece(piece) { [weak self] square in
      let targets = [
        square.upLeft(),
        square.up(),
        square.upRight(),
        square.right(),
        square.downRight(),
        square.down(),
        square.downLeft(),
        square.left()
      ]
      
      for target in targets {
        if target != nil {
          if self!.position.pieceAt(target!).side() != side {
            let move = CTMoveBuilder.build(self!.position, from: square, to: target!)
            if !captureOnly || move.captured != .empty {
              moves.append(move)
            }
          }
        }
      }
      
      // Castling
      if !captureOnly {
        if side == .white {
          if self!.position.castlingRights.whiteCanCastleShort {
            if self!.position.pieceAt(.f1) == .empty && self!.position.pieceAt(.g1) == .empty {
              moves.append(CTMoveBuilder.build(self!.position, from: .e1, to: .g1))
            }
          }
          if self!.position.castlingRights.whiteCanCastleLong {
            if self!.position.pieceAt(.d1) == .empty && self!.position.pieceAt(.c1) == .empty {
              moves.append(CTMoveBuilder.build(self!.position, from: .e1, to: .c1))
            }
          }
        } else {
          if self!.position.castlingRights.blackCanCastleShort {
            if self!.position.pieceAt(.f8) == .empty && self!.position.pieceAt(.g8) == .empty {
              moves.append(CTMoveBuilder.build(self!.position, from: .e8, to: .g8))
            }
          }
          if self!.position.castlingRights.blackCanCastleLong {
            if self!.position.pieceAt(.d8) == .empty && self!.position.pieceAt(.c8) == .empty {
              moves.append(CTMoveBuilder.build(self!.position, from: .e8, to: .c8))
            }
          }
        }
      }
    }
    
    return moves
  }
  
  public func generateAllMovesForSide(_ side: CTSide, legalOnly: Bool = true) -> [CTMove] {
    var moves = [CTMove]()
    
    if side == .white {
      moves.append(contentsOf: generateWhitePawnMoves())
    } else {
      moves.append(contentsOf: generateBlackPawnMoves())
    }
    
    moves.append(contentsOf: generateBishopMoves(side))
    moves.append(contentsOf: generateKnightMoves(side))
    moves.append(contentsOf: generateRookMoves(side))
    moves.append(contentsOf: generateQueenMoves(side))
    moves.append(contentsOf: generateKingMoves(side))
    
    if (legalOnly) {
      return filterLegalMoves(moves)
    }
    return moves
  }
  
  public func generateCapturingMovesForSide(_ side: CTSide, legalOnly: Bool = true) -> [CTMove] {
    var moves = [CTMove]()
    
    if side == .white {
      moves.append(contentsOf: generateWhitePawnMoves(captureOnly: true))
    } else {
      moves.append(contentsOf: generateBlackPawnMoves(captureOnly: true))
    }
    
    moves.append(contentsOf: generateBishopMoves(side, captureOnly: true))
    moves.append(contentsOf: generateKnightMoves(side, captureOnly: true))
    moves.append(contentsOf: generateRookMoves(side, captureOnly: true))
    moves.append(contentsOf: generateQueenMoves(side, captureOnly: true))
    moves.append(contentsOf: generateKingMoves(side, captureOnly: true))
    
    if (legalOnly) {
      return filterLegalMoves(moves)
    }
    return moves
  }
  
  func attackingMovesForSquare(_ square: CTSquare, attackSide: CTSide) -> [CTMove] {
    let moves = generateAllMovesForSide(attackSide, legalOnly: false)
    
    let filteredMoves = moves.filter { move in
      return move.to == square
    }
    return filteredMoves
  }
  
  func filterLegalMoves(_ moves: [CTMove]) -> [CTMove] {
    let kingToCheck: CTPiece = position.sideToMove == .white ? .whiteKing : .blackKing
    let legalMoves = moves.filter { [weak self] move in
      var legal:Bool = true
      if move.castling {
        legal = self!.checkCastlingMoveIfLegal(move)
        if !legal {
          return legal
        }
      }
      
      let _ = self!.position.makeMove(from: move.from, to: move.to, validate: false, notifications: false)
      
      self!.position.filterPiece(kingToCheck, action: { (square) -> () in
        let attackingMoves = self!.attackingMovesForSquare(square, attackSide: self!.position.sideToMove)
        if attackingMoves.count > 0 {
          legal = false
        }
      })
      let _ = self!.position.takeBackMove()
      
      return legal
    }
    return legalMoves
  }
  
  fileprivate func checkCastlingMoveIfLegal(_ move: CTMove) -> Bool {
    if move.to == .g1 {
      if self.attackingMovesForSquare(.e1, attackSide: .black).count > 0 ||
        self.attackingMovesForSquare(.f1, attackSide: .black).count > 0 {
          return false
      }
    } else if move.to == .c1 {
      if self.attackingMovesForSquare(.e1, attackSide: .black).count > 0 ||
        self.attackingMovesForSquare(.d1, attackSide: .black).count > 0 ||
        self.attackingMovesForSquare(.b1, attackSide: .black).count > 0 {
          return false
      }
    } else if move.to == .g8 {
      if self.attackingMovesForSquare(.e8, attackSide: .white).count > 0 ||
        self.attackingMovesForSquare(.f8, attackSide: .white).count > 0 {
          return false
      }
    } else if move.to == .c8 {
      if self.attackingMovesForSquare(.e8, attackSide: .white).count > 0 ||
        self.attackingMovesForSquare(.d8, attackSide: .white).count > 0 ||
        self.attackingMovesForSquare(.b8, attackSide: .white).count > 0 {
          return false
      }
    }
    return true
  }
  
  fileprivate func movesInLine(side: CTSide, piece: CTPiece, square: CTSquare, captureOnly: Bool = false,
                               update: (CTSquare) -> (CTSquare?)) -> [CTMove] {
    let opposite: CTSide = side == .white ? .black : .white
    
    var moves = [CTMove]()
    
    var target: CTSquare? = square
    target = update(target!)
    
    while target != nil && position.pieceAt(target!).side() != side {
      let move = CTMoveBuilder.build(position, from: square, to: target!)
      if !captureOnly || move.captured != .empty {
        moves.append(move)
      }
      if position.pieceAt(target!).side() == opposite {
        break
      } else {
        target = update(target!)
      }
    }
    
    return moves
  }
}
