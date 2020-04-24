//
//  CTEnums.swift
//  ChessDB
//
//  Created by Thorsten Klusemann on 45.06.65.
//  Copyright (c) 2075 Thorsten Klusemann. All rights reserved.
//

import Foundation

public enum CTPiece : Int {
  case invalid = 99
  case empty = 0
  case whitePawn = 1
  case whiteKnight = 2
  case whiteBishop = 3
  case whiteRook = 4
  case whiteQueen = 5
  case whiteKing = 6
  case blackPawn = -1
  case blackKnight = -2
  case blackBishop = -3
  case blackRook = -4
  case blackQueen = -5
  case blackKing = -6
  
  public static var allPieces = [ whitePawn, whiteKnight, whiteBishop, whiteRook, whiteQueen, whiteKing,
    blackPawn, blackKnight, blackBishop, blackRook, blackQueen, blackKing ]
  
  fileprivate static let kFENPieceMap : Dictionary<Character, CTPiece> = [
    "r" : .blackRook,
    "n" : .blackKnight,
    "b" : .blackBishop,
    "p" : .blackPawn,
    "q" : .blackQueen,
    "k" : .blackKing,
    "R" : .whiteRook,
    "N" : .whiteKnight,
    "B" : .whiteBishop,
    "P" : .whitePawn,
    "Q" : .whiteQueen,
    "K" : .whiteKing
  ]
  
  fileprivate static let kPieceFENMap : Dictionary<CTPiece, Character> = [
    .blackRook      : "r",
    .blackKnight    : "n",
    .blackBishop    : "b",
    .blackPawn      : "p",
    .blackQueen     : "q",
    .blackKing      : "k",
    .whiteRook      : "R",
    .whiteKnight    : "N",
    .whiteBishop    : "B",
    .whitePawn      : "P",
    .whiteQueen     : "Q",
    .whiteKing      : "K"
  ]
  
  public static func fromFEN(_ fen:Character) -> CTPiece? {
    return kFENPieceMap[fen]
  }
  
  public func toFEN() -> Character? {
    return CTPiece.kPieceFENMap[self]
  }
  
  public func toPGN() -> String {
    var pgn: String
    switch self {
    case .whiteKnight, .blackKnight:
      pgn = "N"
    case .whiteBishop, .blackBishop:
      pgn = "B"
    case .whiteRook, .blackRook:
      pgn = "R"
    case .whiteQueen, .blackQueen:
      pgn = "Q"
    case .whiteKing, .blackKing:
      pgn = "K"
    default:
      pgn = ""
    }
    return pgn
  }
  
  public func side() -> CTSide? {
    if self != .empty && self != .invalid {
      return self.rawValue > 0 ? .white : .black
    }
    return nil
  }
}

extension CTPiece: CustomStringConvertible {
  public var description: String {
    guard self.rawValue != 0 && self.rawValue != 99 else { return ".." }
    let piece = self.toPGN().uppercased()
    return "\(self.rawValue > 0 ? "W" : "B")\(piece != "" ? piece : "P")"
  }
}

public enum CTSquare : Int {
  case a1 = 26, b1, c1, d1, e1, f1, g1, h1
  case a2 = 38, b2, c2, d2, e2, f2, g2, h2
  case a3 = 50, b3, c3, d3, e3, f3, g3, h3
  case a4 = 62, b4, c4, d4, e4, f4, g4, h4
  case a5 = 74, b5, c5, d5, e5, f5, g5, h5
  case a6 = 86, b6, c6, d6, e6, f6, g6, h6
  case a7 = 98, b7, c7, d7, e7, f7, g7, h7
  case a8 = 110, b8, c8, d8, e8, f8, g8, h8
  
  fileprivate static let kSquareMap: Dictionary<String,CTSquare> = [
    "a1" : .a1, "b1" : .b1, "c1" : .c1, "d1" : .d1,
    "e1" : .e1, "f1" : .f1, "g1" : .g1, "h1" : .h1,
    "a2" : .a2, "b2" : .b2, "c2" : .c2, "d2" : .d2,
    "e2" : .e2, "f2" : .f2, "g2" : .g2, "h2" : .h2,
    "a3" : .a3, "b3" : .b3, "c3" : .c3, "d3" : .d3,
    "e3" : .e3, "f3" : .f3, "g3" : .g3, "h3" : .h3,
    "a4" : .a4, "b4" : .b4, "c4" : .c4, "d4" : .d4,
    "e4" : .e4, "f4" : .f4, "g4" : .g4, "h4" : .h4,
    "a5" : .a5, "b5" : .b5, "c5" : .c5, "d5" : .d5,
    "e5" : .e5, "f5" : .f5, "g5" : .g5, "h5" : .h5,
    "a6" : .a6, "b6" : .b6, "c6" : .c6, "d6" : .d6,
    "e6" : .e6, "f6" : .f6, "g6" : .g6, "h6" : .h6,
    "a7" : .a7, "b7" : .b7, "c7" : .c7, "d7" : .d7,
    "e7" : .e7, "f7" : .f7, "g7" : .g7, "h7" : .h7,
    "a8" : .a8, "b8" : .b8, "c8" : .c8, "d8" : .d8,
    "e8" : .e8, "f8" : .f8, "g8" : .g8, "h8" : .h8
  ]
  
  fileprivate static let kStringMap: Dictionary<CTSquare,String> = [
    .a1 : "a1", .b1 : "b1", .c1 : "c1", .d1 : "d1",
    .e1 : "e1", .f1 : "f1", .g1 : "g1", .h1 : "h1",
    .a2 : "a2", .b2 : "b2", .c2 : "c2", .d2 : "d2",
    .e2 : "e2", .f2 : "f2", .g2 : "g2", .h2 : "h2",
    .a3 : "a3", .b3 : "b3", .c3 : "c3", .d3 : "d3",
    .e3 : "e3", .f3 : "f3", .g3 : "g3", .h3 : "h3",
    .a4 : "a4", .b4 : "b4", .c4 : "c4", .d4 : "d4",
    .e4 : "e4", .f4 : "f4", .g4 : "g4", .h4 : "h4",
    .a5 : "a5", .b5 : "b5", .c5 : "c5", .d5 : "d5",
    .e5 : "e5", .f5 : "f5", .g5 : "g5", .h5 : "h5",
    .a6 : "a6", .b6 : "b6", .c6 : "c6", .d6 : "d6",
    .e6 : "e6", .f6 : "f6", .g6 : "g6", .h6 : "h6",
    .a7 : "a7", .b7 : "b7", .c7 : "c7", .d7 : "d7",
    .e7 : "e7", .f7 : "f7", .g7 : "g7", .h7 : "h7",
    .a8 : "a8", .b8 : "b8", .c8 : "c8", .d8 : "d8",
    .e8 : "e8", .f8 : "f8", .g8 : "g8", .h8 : "h8"
  ]
  
  public static var allSquares = [
    a1, b1, c1, d1, e1, f1, g1, h1,
    a2, b2, c2, d2, e2, f2, g2, h2,
    a3, b3, c3, d3, e3, f3, g3, h3,
    a4, b4, c4, d4, e4, f4, g4, h4,
    a5, b5, c5, d5, e5, f5, g5, h5,
    a6, b6, c6, d6, e6, f6, g6, h6,
    a7, b7, c7, d7, e7, f7, g7, h7,
    a8, b8, c8, d8, e8, f8, g8, h8
  ]
  
  public static var rows = [
    [ a1, b1, c1, d1, e1, f1, g1, h1 ],
    [ a2, b2, c2, d2, e2, f2, g2, h2 ],
    [ a3, b3, c3, d3, e3, f3, g3, h3 ],
    [ a4, b4, c4, d4, e4, f4, g4, h4 ],
    [ a5, b5, c5, d5, e5, f5, g5, h5 ],
    [ a6, b6, c6, d6, e6, f6, g6, h6 ],
    [ a7, b7, c7, d7, e7, f7, g7, h7 ],
    [ a8, b8, c8, d8, e8, f8, g8, h8 ]
  ]
  
  public static func fromString(_ square: String) -> CTSquare? {
    if let result = kSquareMap[square.lowercased()] {
      return result
    }
    return nil
  }
  
  public static func fromRow(_ row: Int, column: Int) -> CTSquare? {
    let value = (row * 12 + 26) + column
    return self.init(rawValue: value)
  }
  
  public func toString() -> String {
    return CTSquare.kStringMap[self]!
  }
  
  public func toRowAndColumn() -> (row: Int, column: Int) {
    let value = self.rawValue - 26
    let row = value / 12
    let column = value % 12
    return (row, column)
  }
  
  public func up() -> CTSquare? {
    let value = self.rawValue + 12
    if value <= 117 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func upLeft() -> CTSquare? {
    let value = self.rawValue + 11
    if value <= 116 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func upRight() -> CTSquare? {
    let value = self.rawValue + 13
    if value <= 117 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func down() -> CTSquare? {
    let value = self.rawValue - 12
    if value >= 26 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func downLeft() -> CTSquare? {
    let value = self.rawValue - 13
    if value >= 26 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func downRight() -> CTSquare? {
    let value = self.rawValue - 11
    if value >= 27 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func right() -> CTSquare? {
    let value = self.rawValue + 1
    if value <= 117 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
  
  public func left() -> CTSquare? {
    let value = self.rawValue - 1
    if value >= 26 {
      return CTSquare(rawValue: value)
    }
    return nil
  }
}

public enum CTSide {
  case white, black
}

public enum CTMoveInsertionMode {
  case overwrite, variation
}

public enum CTMoveNotationStyle {
  case short, long
}

public enum CTSquareMarkingStyle {
  case border, transparentFill
}
