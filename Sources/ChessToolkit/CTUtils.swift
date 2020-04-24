//
//  CTUtils.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 10.08.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

class CTObjectWrapper<T> {
  var wrappedValue: T
  
  init(wrappedValue: T) {
    self.wrappedValue = wrappedValue
  }
}

/// Extension for building random numbers for hashing
extension UInt64 {
  static func random() -> UInt64 {
    return (UInt64(arc4random()) << 32) | UInt64(arc4random())
  }
}

/// HashUtils for hashing of positions
class HashUtils {
  
  static let shared = HashUtils()
  
  fileprivate let _squares = CTSquare.allSquares
  fileprivate let _pieces = CTPiece.allPieces
  fileprivate let _epSquares: [CTSquare] = [
    .a3, .b3, .c3, .d3, .e3, .f3, .g3, .h3,
    .a6, .b6, .c6, .d6, .e6, .f6, .g6, .h6
  ]
  
  fileprivate var _pieceHashKeys: [[UInt64]] = []
  fileprivate let _epHashKeys: [UInt64] = [
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random()
  ]
  fileprivate let _castlingRightsKeys: [UInt64] = [
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random(),
    UInt64.random(), UInt64.random(), UInt64.random(), UInt64.random()
  ]

  let sideHashKey: UInt64 = UInt64.random()

  private init() {
    for _ in _squares {
      let pieces = getRandomNumbersForPieces()
      _pieceHashKeys.append(pieces)
    }
  }
  
  func hash(for piece: CTPiece, on square: CTSquare) -> UInt64 {
    let sqIdx = _squares.firstIndex(of: square)
    let pcIdx = _pieces.firstIndex(of: piece)
    assert(sqIdx != nil && pcIdx != nil, "Invalid index encountered.")
    return _pieceHashKeys[sqIdx!][pcIdx!]
  }
  
  func hash(for epSquare: CTSquare) -> UInt64 {
    let index = _epSquares.firstIndex(of: epSquare)
    assert(index != nil, "An invalid en passant square has been specified.")
    return _epHashKeys[index!]
  }
  
  func hash(for castlingRights: CTCastlingRights) -> UInt64 {
    return _castlingRightsKeys[castlingRights.bitMask]
  }
  
  private func getRandomNumbersForPieces() -> [UInt64] {
    var result: [UInt64] = []
    for _ in _pieces {
      result.append(UInt64.random())
    }
    return result
  }
  
}

