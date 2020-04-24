//
//  CTConstants.swift
//  ChessDB
//
//  Created by Thorsten Klusemann on 13.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

struct CTConstants {
  // MARK: Chess constants
  
  static let kInitialPosition : [CTPiece] = [
    .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid,
    .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid,
    .invalid, .invalid, .whiteRook, .whiteKnight, .whiteBishop, .whiteQueen, .whiteKing, .whiteBishop, .whiteKnight, .whiteRook, .invalid, .invalid,
    .invalid, .invalid, .whitePawn, .whitePawn, .whitePawn, .whitePawn, .whitePawn, .whitePawn, .whitePawn, .whitePawn, .invalid, .invalid,
    .invalid, .invalid, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .invalid, .invalid,
    .invalid, .invalid, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .invalid, .invalid,
    .invalid, .invalid, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .invalid, .invalid,
    .invalid, .invalid, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .empty, .invalid, .invalid,
    .invalid, .invalid, .blackPawn, .blackPawn, .blackPawn, .blackPawn, .blackPawn, .blackPawn, .blackPawn, .blackPawn, .invalid, .invalid,
    .invalid, .invalid, .blackRook, .blackKnight, .blackBishop, .blackQueen, .blackKing, .blackBishop, .blackKnight, .blackRook, .invalid, .invalid,
    .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid,
    .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid, .invalid
  ]
  
  // MARK: FEN Constants
  
  static let kFENNotSpecified = "-"
  static let kFENWhiteKing = "K"
  static let kFENWhiteQueen = "Q"
  static let kFENBlackKing = "k"
  static let kFENBlackQueen = "q"
  
  static let kFENNotSpecifiedChar = "-" as Character
  static let kFENWhiteKingChar = "K" as Character
  static let kFENWhiteQueenChar = "Q" as Character
  static let kFENBlackKingChar = "k" as Character
  static let kFENBlackQueenChar = "q" as Character
  
  static let kFENSideWhite = "w"
  static let kFENSideBlack = "b"
  
  static let kFENDefaultValidationMessage = "OK"
  
  static let kFENMinRow = "1" as Character
  static let kFENMaxRow = "8" as Character
  
  // MARK: Notifications
  
  static let kNotificationPositionDidMakeMove = "Position_DidMakeMove"
  static let kNotificationGameDidInsertMoveNode = "Game_DidInsertMoveNode"
  
  static let kUserInfoAttributeMove = "move"
  static let kUserInfoAttributeNode = "node"
}
