//
//  CTMoveBuilder.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 25.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

public final class CTMoveBuilder {
  
  fileprivate var piece: CTPiece
  fileprivate var from: CTSquare
  fileprivate var to: CTSquare
  fileprivate var captured: CTPiece = .empty
  fileprivate var enPassant: Bool = false
  fileprivate var promotionPiece: CTPiece = .empty
  fileprivate var castlingRightsBeforeMove: CTCastlingRights!
  fileprivate var enPassantSquareBeforeMove: CTSquare?
  fileprivate var moveNumber: Int = 1
  
  fileprivate var move: CTMove {
    return CTMove(piece: piece, from: from, to: to, captured: captured, enPassant: enPassant, promotionPiece: promotionPiece,
                  castlingRights: castlingRightsBeforeMove, enPassantSquare: enPassantSquareBeforeMove, moveNumber: moveNumber)
  }
  
  fileprivate init(piece: CTPiece, from: CTSquare, to: CTSquare) {
    self.piece = piece
    self.from = from
    self.to = to
  }
  
  // MARK: Static build functions
  
  public static func build(_ position: CTPosition, from: CTSquare, to: CTSquare) -> CTMove {
    let opposite: CTSide = position.pieceAt(from).side() == .white ? .black : .white
    let piece = position.pieceAt(from)
    let builder = CTMoveBuilder(piece: position.pieceAt(from), from: from, to: to)
    
    // Capture case
    if position.pieceAt(to).side() == opposite {
      builder.captured = position.pieceAt(to)
    }
    
    // En passant
    if piece == .whitePawn && to == position.enPassantSquare {
      builder.enPassant = true
      builder.captured = .blackPawn
    }
    if piece == .blackPawn && to == position.enPassantSquare {
      builder.enPassant = true
      builder.captured = .whitePawn
    }
    
    // Promotion
    if piece == .whitePawn && to.rawValue >= 110 && to.rawValue <= 117 {
      builder.promotionPiece = position.promotionPieceWhite
    }
    if piece == .blackPawn && to.rawValue >= 26 && to.rawValue <= 33 {
      builder.promotionPiece = position.promotionPieceBlack
    }
    
    builder.castlingRightsBeforeMove = position.castlingRights
    builder.enPassantSquareBeforeMove = position.enPassantSquare
    
    builder.moveNumber = position.moveNumber
    
    return builder.move
  }
}
