//
//  CTFENParser.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 13.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

class CTFENParser {
  fileprivate var _fen: String = ""
  
  var posData = Array(repeating: (CTPiece).invalid, count: 144)
  var castlingRights = CTCastlingRights(whiteCanCastleShort: false, whiteCanCastleLong: false, blackCanCastleShort: false, blackCanCastleLong: false)
  var sideToMove : CTSide = .white
  var enPassantSquare : CTSquare?
  var halfMoveClock : Int = 0
  var fullMoveNumber : Int = 1
  var valid : Bool = true
  var validationMessage : String = CTConstants.kFENDefaultValidationMessage
  
  var fen: String {
    get {
      positionToFen()
      return _fen
    }
    set {
      _fen = newValue
      fenToPosition()
    }
  }
  
  init() {
    
  }
  
  init(fen: String) {
    self.fen = fen
  }
  
  fileprivate func positionToFen() {
    let rows = CTSquare.rows
    
    _fen = ""
    for i in stride(from: 7, to: -1, by: -1) {
      let row = rows[i]
      let rowString = fenFromRow(row)
      _fen += rowString
      if i > 0 {
        _fen += "/"
      }
    }
    
    _fen += " "
    
    _fen += sideToMove == .white ? "w " : "b "
    
    _fen += castlingRights.whiteCanCastleShort ? "K" : ""
    _fen += castlingRights.whiteCanCastleLong ? "Q" : ""
    _fen += castlingRights.blackCanCastleShort ? "k" : ""
    _fen += castlingRights.blackCanCastleLong ? "q" : ""
    
    _fen += " "
    
    _fen += enPassantSquare != nil ? enPassantSquare!.toString() : "-"
    
    _fen += " "
    
    _fen += "\(halfMoveClock) \(fullMoveNumber)"
  }
  
  fileprivate func fenToPosition() {
    let components = _fen.components(separatedBy: " ")
    
    if components.count != 6 {
      setError("Invalid element count: \(components.count)")
    } else {
      analyzePosition(components[0])
      analyzeSideToMove(components[1])
      analyzeCastlingRights(components[2])
      analyzeEnPassantSquare(components[3])
      analyzeHalfMoveClock(components[4])
      analyzeFullMoveNumber(components[5])
    }
  }
  
  fileprivate func fenFromRow(_ squaresInRow: [CTSquare]) -> String {
    var result = ""
    var empty = 0
    for square in squaresInRow {
      let piece = posData[square.rawValue]
      if piece == .empty {
        empty += 1
      } else {
        if empty > 0 {
          result += "\(empty)"
          empty = 0
        }
        result.append(piece.toFEN()!)
      }
    }
    if empty > 0 {
      result += "\(empty)"
    }
    
    return result
  }
  
  fileprivate func analyzePosition(_ position: String) {
    let rows = position.components(separatedBy: "/")
    if rows.count != 8 {
      setError("Invalid number of rows")
      return
    }
    
    var startSquare = CTSquare.a8.rawValue
    for row in rows {
      parsePositionRow(row, startSquare: startSquare)
      startSquare -= 12
    }
  }
  
  fileprivate func parsePositionRow(_ row: String, startSquare: Int) {
    var square = startSquare
    for char in row {
      if let piece = CTPiece.fromFEN(char) {
        posData[square] = piece
        square += 1
      } else {
        if char >= CTConstants.kFENMinRow && char <= CTConstants.kFENMaxRow {
          let emptyColumns = Int(String(char))!
          for _ in 1...emptyColumns {
            posData[square] = .empty
            square += 1
          }
        } else {
          setError("Invalid character found: \(char)")
          return
        }
      }
    }
    
    if square - startSquare != 8 {
      setError("Mismatch in column count: \(square - startSquare)")
      return
    }
  }
  
  fileprivate func analyzeSideToMove(_ side: String) {
    switch side {
    case CTConstants.kFENSideWhite:
      sideToMove = .white
    case CTConstants.kFENSideBlack:
      sideToMove = .black
    default:
      setError("Invalid side to move: \(side)")
    }
  }
  
  fileprivate func analyzeCastlingRights(_ rights: String) {
    for char in rights {
      switch (char) {
      case CTConstants.kFENWhiteKingChar:
        castlingRights._whiteCanCastleShort = true
      case CTConstants.kFENWhiteQueenChar:
        castlingRights._whiteCanCastleLong = true
      case CTConstants.kFENBlackKingChar:
        castlingRights._blackCanCastleShort = true
      case CTConstants.kFENBlackQueenChar:
        castlingRights._blackCanCastleLong = true
      case CTConstants.kFENNotSpecifiedChar:
        castlingRights._whiteCanCastleLong = false
        castlingRights._whiteCanCastleShort = false
        castlingRights._blackCanCastleLong = false
        castlingRights._blackCanCastleShort = false
      default:
        setError("Invalid castling flag: \(char)")
      }
    }
  }
  
  fileprivate func analyzeEnPassantSquare(_ square: String) {
    let length = square.count
    if (length < 1 || length > 2) {
      setError("Invalid length of en passant square: \(square.count)")
      return
    }
    
    if square == "-" {
      enPassantSquare = nil
    } else {
      if let sq = CTSquare.fromString(square) {
        enPassantSquare = sq
      } else {
        setError("Invalid combination for en passant square: \(square)")
      }
    }
  }
  
  fileprivate func analyzeHalfMoveClock(_ clock: String) {
    if let value = Int(clock) {
      halfMoveClock = value
    } else {
      setError("Invalid half move clock: \(clock)")
    }
  }
  
  fileprivate func analyzeFullMoveNumber(_ number: String) {
    if let value = Int(number) {
      fullMoveNumber = value
    } else {
      setError("Invalid full move number: \(number)")
    }
  }
  
  fileprivate func setError(_ msg: String) {
    valid = false
    validationMessage = msg
  }
}
