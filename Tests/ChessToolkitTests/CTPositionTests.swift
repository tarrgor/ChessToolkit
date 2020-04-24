//
//  CTPositionTests.swift
//  ChessDB
//
//  Created by Thorsten Klusemann on 11.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import XCTest
@testable import ChessToolkit

class CTPositionTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCreatePosition_HasInitialPosition() {
    let pos = CTPosition()
    
    XCTAssert(pos.pieceAt(.e2) == .whitePawn, "Piece on e2 is not a white pawn.")
    XCTAssert(pos.pieceAt(.d4) == .empty, "Piece on d4 is not empty.")
    XCTAssert(pos.pieceAt(.a7) == .blackPawn, "Piece on a7 is not a black pawn.")
    XCTAssert(pos.pieceAt(.d8) == .blackQueen, "Piece on d8 is not a black queen.")
  }
  
  func testCreatePosition_CastlingRightsAreSet() {
    let pos = CTPosition()
    
    let cr = pos.castlingRights
    
    XCTAssert(cr.whiteCanCastleLong, "White may not castle long.")
    XCTAssert(cr.blackCanCastleShort, "Black may not castle short.")
  }
  
  func testCreatePosition_WhiteToMove() {
    let pos = CTPosition()
    
    let side = pos.sideToMove
    
    XCTAssert(side == .white, "White is not to move.")
  }
  
  func testCreatePosition_MoveNumberIsOne() {
    let pos = CTPosition()
    
    let nr = pos.moveNumber
    
    XCTAssert(nr == 1, "Move number is not one.")
  }
  
  func testCreatePositionWithFEN() {
    let pos = CTPosition(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    XCTAssert(pos.pieceAt(.e2) == .whitePawn, "Piece on e2 is not a white pawn.")
    XCTAssert(pos.pieceAt(.d4) == .empty, "Piece on d4 is not empty.")
    XCTAssert(pos.pieceAt(.a7) == .blackPawn, "Piece on a7 is not a black pawn.")
    XCTAssert(pos.pieceAt(.d8) == .blackQueen, "Piece on d8 is not a black queen.")
  }
  
  func testSetWhiteBishopOnE4() {
    let pos = CTPosition()
    
    pos.setPiece(.whiteBishop, square: .e4)
    
    XCTAssert(pos.pieceAt(.e4) == .whiteBishop, "Piece on e4 is not a white bishop.")
  }
  
  func testRemovePieceAtA1() {
    let pos = CTPosition()
    
    pos.removePieceAt(.a1)
    
    XCTAssert(pos.pieceAt(.a1) == .empty, "Piece on a1 is not empty.")
  }
  
  func testPositionWithEnPassantSquareOnD6() {
    let pos = CTPosition(fen: "rnbqkbnr/p1p1ppp1/1p5p/3pP3/8/P7/1PPP1PPP/RNBQKBNR w KQkq d6 6 4")
    
    XCTAssert(pos.enPassantSquare == .d6, "En passant square is not d6.")
  }
  
  func testMakeMoveFromInitialPosition() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "E2 is not empty.")
    XCTAssertTrue(pos.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    XCTAssertTrue(pos.halfMoveClock == 0, "Half move clock is not 0.")
  }
  
  func testMakeIllegalMoveFromInitialPosition() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e5)
    
    XCTAssertFalse(result, "Result is not false.")
    XCTAssertTrue(pos.pieceAt(.e2) == .whitePawn, "No white pawn on e2.")
    XCTAssertTrue(pos.pieceAt(.e5) == .empty, "E5 is not empty.")
  }
  
  func testMakeIllegalMoveWithoutValidation() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e5, validate: false)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "E2 is not empty.")
    XCTAssertTrue(pos.pieceAt(.e5) == .whitePawn, "No white pawn on e5.")
  }
  
  func testMakeMoveWithCastling() {
    let pos = CTPosition(fen: "r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 6 4")
    
    let result = pos.makeMove(from: .e1, to: .g1)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.e1) == .empty, "e1 is not empty.")
    XCTAssertTrue(pos.pieceAt(.g1) == .whiteKing, "No white king on g1.")
    XCTAssertTrue(pos.pieceAt(.f1) == .whiteRook, "No white rook on f1.")
    XCTAssertTrue(pos.pieceAt(.h1) == .empty, "h1 is not empty.")
  }
  
  func testMakeMoveWithEnPassant() {
    let pos = CTPosition(fen: "rnbqkbnr/pp1p1ppp/8/2pPp3/8/8/PPP1PPPP/RNBQKBNR w KQkq c6 4 3")
    
    let result = pos.makeMove(from: .d5, to: .c6)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.d5) == .empty, "e5 is not empty.")
    XCTAssertTrue(pos.pieceAt(.c6) == .whitePawn, "No white pawn on c6.")
    XCTAssertTrue(pos.pieceAt(.c5) == .empty, "c5 is not empty.")
  }
  
  func testMakeMoveWithDefaultPromotion() {
    let pos = CTPosition(fen: "rnbqkb1r/ppppnpP1/4p2p/8/8/8/PPPPP1PP/RNBQKBNR w KQkq - 8 5")
    
    let result = pos.makeMove(from: .g7, to: .g8)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.g7) == .empty, "g7 is not empty.")
    XCTAssertTrue(pos.pieceAt(.g8) == .whiteQueen, "No white queen on g8.")
  }
  
  func testMakeMoveWithDefaultPromotionAndCapturingOnF8() {
    let pos = CTPosition(fen: "rnbqkb1r/ppppnpP1/4p2p/8/8/8/PPPPP1PP/RNBQKBNR w KQkq - 8 5")
    
    let result = pos.makeMove(from: .g7, to: .f8)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.g7) == .empty, "g7 is not empty.")
    XCTAssertTrue(pos.pieceAt(.f8) == .whiteQueen, "No white queen on f8.")
  }
  
  func testMakeMoveWithDefaultPromotionAndCapturingOnF8AndPromotionToBishop() {
    let pos = CTPosition(fen: "rnbqkb1r/ppppnpP1/4p2p/8/8/8/PPPPP1PP/RNBQKBNR w KQkq - 8 5")
    pos.promotionPieceWhite = .whiteBishop
    
    let result = pos.makeMove(from: .g7, to: .f8)
    
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.g7) == .empty, "g7 is not empty.")
    XCTAssertTrue(pos.pieceAt(.f8) == .whiteBishop, "No white bishop on f8.")
  }
  
  func testMakeMoveWithWrongSideShouldFailWhenValidated() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e7, to: .e5)
    
    XCTAssertFalse(result, "Result is not false.")
  }
  
  func testMakeMoveSwitchesSideToMove() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .e2, to: .e4)
    
    XCTAssertTrue(pos.sideToMove == .black, "Side to move is not switched to black.")
  }
  
  func testTakeBackMoveAfterInitialE2E4() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4)
    XCTAssertTrue(result, "Result is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .whitePawn, "No white pawn on e2.")
    XCTAssertTrue(pos.pieceAt(.e4) == .empty, "e4 not empty.")
  }
  
  func testTakeBackMoveAfterInitialE2E4E7E5() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .e7, to: .e5)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "e2 not empty.")
    XCTAssertTrue(pos.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    XCTAssertTrue(pos.pieceAt(.e7) == .blackPawn, "No black pawn on e7.")
    XCTAssertTrue(pos.pieceAt(.e5) == .empty, "e5 not empty.")
  }
  
  func testTakeBackTwoMovesAfterInitialE2E4E7E5() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .e7, to: .e5)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "e2 not empty.")
    XCTAssertTrue(pos.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    XCTAssertTrue(pos.pieceAt(.e7) == .blackPawn, "No black pawn on e7.")
    XCTAssertTrue(pos.pieceAt(.e5) == .empty, "e5 not empty.")
    
    let takeBackResult2 = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult2, "TakeBackResult2 is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .whitePawn, "No white pawn on e2.")
    XCTAssertTrue(pos.pieceAt(.e4) == .empty, "e4 not empty.")
    XCTAssertTrue(pos.pieceAt(.e7) == .blackPawn, "No black pawn on e7.")
    XCTAssertTrue(pos.pieceAt(.e5) == .empty, "e5 not empty.")
  }
  
  func testTakeBackMoveWithCapture() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .d7, to: .d5)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let result3 = pos.makeMove(from: .e4, to: .d5)
    XCTAssertTrue(result3, "Result3 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "e2 not empty.")
    XCTAssertTrue(pos.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    XCTAssertTrue(pos.pieceAt(.d7) == .empty, "d7 not empty.")
    XCTAssertTrue(pos.pieceAt(.d5) == .blackPawn, "No black pawn on d5.")
  }
  
  func testTakeBackMoveWithCaptureWithoutValidation() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .e2, to: .e4, validate: false)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .d7, to: .d5, validate: false)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let result3 = pos.makeMove(from: .e4, to: .d5, validate: false)
    XCTAssertTrue(result3, "Result3 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e2) == .empty, "e2 not empty.")
    XCTAssertTrue(pos.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    XCTAssertTrue(pos.pieceAt(.d7) == .empty, "d7 not empty.")
    XCTAssertTrue(pos.pieceAt(.d5) == .blackPawn, "No black pawn on d5.")
  }
  
  func testTakeBackMoveWithCastling() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .g1, to: .f3)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .d7, to: .d6)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let result3 = pos.makeMove(from: .g2, to: .g3)
    XCTAssertTrue(result3, "Result3 is not true.")
    
    let result4 = pos.makeMove(from: .c7, to: .c6)
    XCTAssertTrue(result4, "Result4 is not true.")
    
    let result5 = pos.makeMove(from: .f1, to: .g2)
    XCTAssertTrue(result5, "Result3 is not true.")
    
    let result6 = pos.makeMove(from: .g8, to: .f6)
    XCTAssertTrue(result6, "Result6 is not true.")
    
    let result7 = pos.makeMove(from: .e1, to: .g1)
    XCTAssertTrue(result7, "Result7 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult not true.")
    XCTAssertTrue(pos.pieceAt(.e1) == .whiteKing, "No white king on e1.")
    XCTAssertTrue(pos.pieceAt(.f1) == .empty, "f1 not empty.")
    XCTAssertTrue(pos.pieceAt(.g1) == .empty, "g1 not empty.")
    XCTAssertTrue(pos.pieceAt(.h1) == .whiteRook, "No white rook on h1.")
  }
  
  func testTakeBackMoveWithCastlingWithoutValidation() {
    let pos = CTPosition()
    
    let result = pos.makeMove(from: .g1, to: .f3, validate: false)
    XCTAssertTrue(result, "Result is not true.")
    
    let result2 = pos.makeMove(from: .d7, to: .d6, validate: false)
    XCTAssertTrue(result2, "Result2 is not true.")
    
    let result3 = pos.makeMove(from: .g2, to: .g3, validate: false)
    XCTAssertTrue(result3, "Result3 is not true.")
    
    let result4 = pos.makeMove(from: .c7, to: .c6, validate: false)
    XCTAssertTrue(result4, "Result4 is not true.")
    
    let result5 = pos.makeMove(from: .f1, to: .g2, validate: false)
    XCTAssertTrue(result5, "Result3 is not true.")
    
    let result6 = pos.makeMove(from: .g8, to: .f6, validate: false)
    XCTAssertTrue(result6, "Result6 is not true.")
    
    let result7 = pos.makeMove(from: .e1, to: .g1, validate: false)
    XCTAssertTrue(result7, "Result7 is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult not true.")
    XCTAssertTrue(pos.pieceAt(.e1) == .whiteKing, "No white king on e1.")
    XCTAssertTrue(pos.pieceAt(.f1) == .empty, "f1 not empty.")
    XCTAssertTrue(pos.pieceAt(.g1) == .empty, "g1 not empty.")
    XCTAssertTrue(pos.pieceAt(.h1) == .whiteRook, "No white rook on h1.")
  }
  
  func testMakeMoveWhichEnablesEnPassant() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .e2, to: .e4)
    let _ = pos.makeMove(from: .a7, to: .a6)
    let _ = pos.makeMove(from: .e4, to: .e5)
    let _ = pos.makeMove(from: .f7, to: .f5)
    
    XCTAssertTrue(pos.enPassantSquare == .f6, "f6 is not the en passant square.")
  }
  
  func testTakeBackMoveWithEnPassant() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .e2, to: .e4)
    let _ = pos.makeMove(from: .a7, to: .a6)
    let _ = pos.makeMove(from: .e4, to: .e5)
    let _ = pos.makeMove(from: .f7, to: .f5)
    let result = pos.makeMove(from: .e5, to: .f6)
    XCTAssertTrue(result, "Result is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e5) == .whitePawn, "No white pawn on e5.")
    XCTAssertTrue(pos.pieceAt(.f6) == .empty, "f6 is not empty.")
    XCTAssertTrue(pos.pieceAt(.f5) == .blackPawn, "f5 is not a black pawn.")
    XCTAssertTrue(pos.enPassantSquare == .f6, "f6 is not en passant square.")
    XCTAssertTrue(pos.sideToMove == .white, "White is not to move.")
  }
  
  func testTakeBackMoveWithEnPassantWithoutValidation() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .e2, to: .e4, validate: false)
    let _ = pos.makeMove(from: .a7, to: .a6, validate: false)
    let _ = pos.makeMove(from: .e4, to: .e5, validate: false)
    let _ = pos.makeMove(from: .f7, to: .f5, validate: false)
    let result = pos.makeMove(from: .e5, to: .f6, validate: false)
    XCTAssertTrue(result, "Result is not true.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.e5) == .whitePawn, "No white pawn on e5.")
    XCTAssertTrue(pos.pieceAt(.f6) == .empty, "f6 is not empty.")
    XCTAssertTrue(pos.pieceAt(.f5) == .blackPawn, "f5 is not a black pawn.")
    XCTAssertTrue(pos.enPassantSquare == .f6, "f6 is not en passant square.")
    XCTAssertTrue(pos.sideToMove == .white, "White is not to move.")
  }
  
  func testTakeBackMoveAfterPromotion() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .f2, to: .f4)
    let _ = pos.makeMove(from: .g7, to: .g5)
    let _ = pos.makeMove(from: .f4, to: .g5)
    let _ = pos.makeMove(from: .f7, to: .f6)
    let _ = pos.makeMove(from: .g5, to: .f6)
    let _ = pos.makeMove(from: .f8, to: .h6)
    let _ = pos.makeMove(from: .f6, to: .f7)
    let _ = pos.makeMove(from: .e8, to: .f8)
    
    let result = pos.makeMove(from: .f7, to: .g8)
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.g8) == .whiteQueen, "No white queen on g8.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.f7) == .whitePawn, "No white pawn on f7.")
    XCTAssertTrue(pos.pieceAt(.g8) == .blackKnight, "No black knight on g8.")
  }
  
  func testTakeBackMoveAfterPromotionWithoutValidation() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .f2, to: .f4, validate: false)
    let _ = pos.makeMove(from: .g7, to: .g5, validate: false)
    let _ = pos.makeMove(from: .f4, to: .g5, validate: false)
    let _ = pos.makeMove(from: .f7, to: .f6, validate: false)
    let _ = pos.makeMove(from: .g5, to: .f6, validate: false)
    let _ = pos.makeMove(from: .f8, to: .h6, validate: false)
    let _ = pos.makeMove(from: .f6, to: .f7, validate: false)
    let _ = pos.makeMove(from: .e8, to: .f8, validate: false)
    
    let result = pos.makeMove(from: .f7, to: .g8, validate: false)
    XCTAssertTrue(result, "Result is not true.")
    XCTAssertTrue(pos.pieceAt(.g8) == .whiteQueen, "No white queen on g8.")
    
    let takeBackResult = pos.takeBackMove()
    
    XCTAssertTrue(takeBackResult, "TakeBackResult is not true.")
    XCTAssertTrue(pos.pieceAt(.f7) == .whitePawn, "No white pawn on f7.")
    XCTAssertTrue(pos.pieceAt(.g8) == .blackKnight, "No black knight on g8.")
  }
  
  func testMakeMoveKingMayNotBeInCheckAfterMove() {
    let pos = CTPosition(fen: "rnbqk1nr/pppp1ppp/4p3/8/1b1P4/2N5/PPP1PPPP/R1BQKBNR w KQkq - 4 3")
    
    let result = pos.makeMove(from: .c3, to: .b5)
    
    XCTAssertFalse(result, "Result is not false.")
  }
  
  func testMakeMoveKingMayNotMoveIntoCheck() {
    let pos = CTPosition(fen: "rnbqk1nr/pppp1ppp/8/2b1p3/4PP2/8/PPPP2PP/RNBQKBNR w KQkq - 4 3")
    
    let result = pos.makeMove(from: .e1, to: .f2)
    
    XCTAssertFalse(result, "Result is not false.")
  }
  
  func testMakeMoveWithCastlingAndCheckCastlingRights() {
    let pos = CTPosition(fen: "rnbqk2r/pppp1ppp/5n2/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 6 4")
    
    let result = pos.makeMove(from: .e1, to: .g1)
    XCTAssertTrue(result, "Result is not true.")
    
    XCTAssertFalse(pos.castlingRights.whiteCanCastleShort, "WhiteCanCastleShort is not false.")
    XCTAssertFalse(pos.castlingRights.whiteCanCastleLong, "WhiteCanCastleLong is not false.")
  }
  
  func testTakeBackMovesWithKingAndRookAndCheckCastlingRights() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .h2, to: .h4)
    let _ = pos.makeMove(from: .e7, to: .e5)
    
    let _ = pos.makeMove(from: .h1, to: .h3)
    XCTAssertFalse(pos.castlingRights.whiteCanCastleShort, "White still can castle short after rook move.")
    
    let _ = pos.makeMove(from: .e8, to: .e7)
    XCTAssertFalse(pos.castlingRights.blackCanCastleLong, "Black still can castle long after rook move.")
    XCTAssertFalse(pos.castlingRights.blackCanCastleShort, "Black still can castle short after rook move.")
    
    let tb1 = pos.takeBackMove()
    
    XCTAssertTrue(tb1, "TakeBack1 is not true.")
    XCTAssertTrue(pos.pieceAt(.e8) == .blackKing, "No black king on e8.")
    XCTAssertTrue(pos.castlingRights.blackCanCastleLong, "Black cannot castle long after takeback.")
    XCTAssertTrue(pos.castlingRights.blackCanCastleShort, "Black cannot castle short after takeback.")
    
    let _ = pos.takeBackMove()
    
    XCTAssertTrue(tb1, "TakeBack2 is not true.")
    XCTAssertTrue(pos.pieceAt(.h1) == .whiteRook, "No white rook on h1.")
    XCTAssertTrue(pos.castlingRights.whiteCanCastleLong, "White cannot castle long after takeback.")
    XCTAssertTrue(pos.castlingRights.whiteCanCastleShort, "White cannot castle short after takeback.")
  }
  
  func testMakeMoveWithCastlingShouldFailWhenKingInCheckBeforeMove() {
    let pos = CTPosition(fen: "r1bqk1nr/p1pp1ppp/1pn1p3/8/1b1P4/5NP1/PPP1PPBP/RNBQK2R w KQkq - 8 5")
    
    let result = pos.makeMove(from: .e1, to: .g1)
    
    XCTAssertFalse(result, "Result is not false.")
  }
  
  func testMakeMoveWithCastlingShouldFailWhenSquareBetweenRookAndKingIsAttacked() {
    let pos = CTPosition(fen: "r1bqk2r/p1pp1ppp/1pn1Nn2/b7/3P4/6P1/PPPBPPBP/RN1QK2R b KQkq - 13 7")
    
    let result = pos.makeMove(from: .e8, to: .g8)
    
    XCTAssertFalse(result, "Result is not false.")
  }
  
  func testMakeMoveWithCastlingShouldWorkWhenOnlyRookIsAttacked() {
    let pos = CTPosition(fen: "r1b1k2r/p1p2ppp/1pn1pn2/b2q4/3P4/6PB/PPPBPP1P/RN1QK2R w KQkq - 16 9")
    
    let result = pos.makeMove(from: .e1, to: .g1)
    
    XCTAssertTrue(result, "Result is not true.")
  }
  
  func testFENFromPositionWithInitialPosition() {
    let pos = CTPosition()
    
    let fen = pos.toFEN()
    
    XCTAssert(fen == "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", "Invalid fen from initial position.")
  }
  
  func testFENFromPositionCreatedFromFEN() {
    let pos = CTPosition(fen: "r1b1k2r/p1p2ppp/1pn1pn2/b2q4/3P4/6PB/PPPBPP1P/RN1QK2R w KQkq - 16 9")
    let fen = pos.toFEN()
    
    XCTAssert(fen == "r1b1k2r/p1p2ppp/1pn1pn2/b2q4/3P4/6PB/PPPBPP1P/RN1QK2R w KQkq - 16 9", "Invalid fen from position.")
  }
  
  func testFENFromPositionCreatedFromFEN2() {
    let pos = CTPosition(fen: "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPPKPPP/RNBQ1BNR b kq - 3 2")
    let fen = pos.toFEN()
    
    XCTAssert(fen == "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPPKPPP/RNBQ1BNR b kq - 3 2", "Invalid fen from position.")
  }
  
  func testFENFromPositionCreatedFromFEN3() {
    let pos = CTPosition(fen: "rnbqkbnr/ppp2ppp/8/4p3/2PpP3/7P/PP1PKPP1/RNBQ1BNR b kq c3 7 4")
    let fen = pos.toFEN()
    
    XCTAssert(fen == "rnbqkbnr/ppp2ppp/8/4p3/2PpP3/7P/PP1PKPP1/RNBQ1BNR b kq c3 7 4", "Invalid fen from position.")
  }
  
  func testLastMoveIsSetCorrectly() {
    let pos = CTPosition()
    
    let _ = pos.makeMove(from: .e2, to: .e4, validate: true)
    let _ = pos.makeMove(from: .e7, to: .e5, validate: true)
    let _ = pos.makeMove(from: .g1, to: .f3, validate: true)
    
    XCTAssert(pos.lastMove!.from == .g1, "From is not g1.")
    XCTAssert(pos.lastMove!.to == .f3, "To is not f3.")
  }
  
  func testCheckPropertyIsSetWhenKingIsAttackedInCurrentPosition() {
    let pos = CTPosition(fen: "rnbqkbnr/ppp2ppp/3p4/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 4 3")
    
    XCTAssert(pos.check == false, "Check flag is not false befor Bb5+.")
    
    let _ = pos.makeMove(from: .f1, to: .b5)
    
    XCTAssert(pos.check == true, "Check flag is not true after Bb5+.")
  }
  
  func testMoveNumberIncreasesBeforeWhiteMoves() {
    let pos = CTPosition()
    
    XCTAssert(pos.moveNumber == 1, "Move number is not one after initial setup of position.")
    
    let _ = pos.makeMove(from: .e2, to: .e4)
    
    XCTAssert(pos.moveNumber == 1, "Move number is not one after 1.e4.")
    
    let _ = pos.makeMove(from: .e7, to: .e5)
    
    XCTAssert(pos.moveNumber == 2, "Move number is not two after 1.... e5.")
  }
  
  func testHashKeyIsTheSameAfterMoveIsMadeAndTakenBack() {
    let pos = CTPosition()
    let initialHash = pos.hashKey
    
    pos.makeMove(from: .e2, to: .e4)
    let hashAfterMove = pos.hashKey
    
    XCTAssertNotEqual(initialHash, hashAfterMove)
    XCTAssertEqual(hashAfterMove, pos.calculateHashKey())
    
    pos.takeBackMove()
    let hashAfterTakeBack = pos.hashKey
    
    XCTAssertEqual(hashAfterTakeBack, initialHash)
    XCTAssertEqual(hashAfterTakeBack, pos.calculateHashKey())
  }
  
  func testHashKeyIsTheSameAfterMoveIsMadeAndTakenBackWithGivenFENPosition() {
    let pos = CTPosition(fen: "4k3/8/8/5B2/3b4/8/8/4K3 w - - 0 1")
    let initialHash = pos.hashKey
    
    pos.makeMove(from: .f5, to: .g4)
    pos.makeMove(from: .d4, to: .e5)
    
    XCTAssertNotEqual(pos.hashKey, initialHash)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())

    pos.makeMove(from: .g4, to: .f5)
    pos.makeMove(from: .e5, to: .d4)
    let hashAfterMoves = pos.hashKey
    
    XCTAssertEqual(initialHash, hashAfterMoves)
    XCTAssertEqual(hashAfterMoves, pos.calculateHashKey())
    
    pos.takeBackMove()
    pos.takeBackMove()
    pos.takeBackMove()
    pos.takeBackMove()
    let hashAfterTakeBack = pos.hashKey
    
    XCTAssertEqual(hashAfterTakeBack, initialHash)
    XCTAssertEqual(hashAfterTakeBack, pos.calculateHashKey())
  }

  func testHashKeyIsDifferentInSamePositionButWithDifferentSideToMove() {
    let pos = CTPosition(fen: "4k3/8/8/5B2/3b4/8/8/4K3 w - - 0 1")
    let initialHash = pos.hashKey
  
    pos.makeMove(from: .f5, to: .d3)
    pos.makeMove(from: .d4, to: .f6)
    pos.makeMove(from: .d3, to: .e4)
    pos.makeMove(from: .f6, to: .d4)
    pos.makeMove(from: .e4, to: .f5)
    let hashAfterMoves = pos.hashKey
    
    XCTAssertNotEqual(hashAfterMoves, initialHash)
    XCTAssertEqual(hashAfterMoves, pos.calculateHashKey())
  }
  
  func testHashKeyAfterEnPassantFieldIsSet() {
    let pos = CTPosition()
    let pos2 = CTPosition()

    pos.makeMove(from: .d2, to: .d4)
    pos2.makeMove(from: .d2, to: .d4)
    pos.makeMove(from: .h7, to: .h6)
    pos2.makeMove(from: .e7, to: .e5)
    pos.makeMove(from: .d4, to: .d5)
    pos2.makeMove(from: .d4, to: .d5)
    pos.makeMove(from: .e7, to: .e5)
    pos2.makeMove(from: .h7, to: .h6)
    let posHash = pos.hashKey
    let pos2Hash = pos2.hashKey
    
    XCTAssertNotEqual(posHash, pos2Hash)
    XCTAssertEqual(posHash, pos.calculateHashKey())
    XCTAssertEqual(pos2Hash, pos2.calculateHashKey())
  }
  
  func testHashKeyAfterEnPassantMoveIsTakenBack() {
    let pos = CTPosition()
    
    pos.makeMove(from: .d2, to: .d4)
    pos.makeMove(from: .h7, to: .h6)
    pos.makeMove(from: .d4, to: .d5)
    let hashBeforeEp = pos.hashKey
    pos.makeMove(from: .e7, to: .e5)
    pos.takeBackMove()
    let hashAfterTakeBack = pos.hashKey

    XCTAssertEqual(hashBeforeEp, hashAfterTakeBack)
    XCTAssertEqual(hashAfterTakeBack, pos.calculateHashKey())
  }
  
  func testEnPassantSquareIsResetAfterTakeBack() {
    let pos = CTPosition()
    
    pos.makeMove(from: .d2, to: .d4)
    pos.makeMove(from: .h7, to: .h6)
    pos.makeMove(from: .d4, to: .d5)
    pos.makeMove(from: .e7, to: .e5)
    
    XCTAssertEqual(pos.enPassantSquare, CTSquare.e6)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
    
    pos.takeBackMove()
    
    XCTAssertNil(pos.enPassantSquare)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
    
    pos.makeMove(from: .e7, to: .e5)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())

    pos.makeMove(from: .h2, to: .h4)
    
    XCTAssertNil(pos.enPassantSquare)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
    
    pos.takeBackMove()
    
    XCTAssertEqual(pos.enPassantSquare, CTSquare.e6)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
  }
  
  func testHashKeyIsDifferentIfCastlingRightsAreDifferent() {
    let pos = CTPosition()
    
    pos.makeMove(from: .e2, to: .e4)
    pos.makeMove(from: .e7, to: .e5)
    pos.makeMove(from: .g1, to: .f3)
    pos.makeMove(from: .b8, to: .c6)
    pos.makeMove(from: .f1, to: .b5)
    pos.makeMove(from: .g8, to: .f6)
    
    let initialHash = pos.hashKey
    
    pos.makeMove(from: .e1, to: .e2)
    pos.makeMove(from: .f6, to: .g8)
    pos.makeMove(from: .e2, to: .e1)
    pos.makeMove(from: .g8, to: .f6)
    
    let hashWithDifferentCR = pos.hashKey
    
    XCTAssertNotEqual(initialHash, hashWithDifferentCR)
    XCTAssertEqual(hashWithDifferentCR, pos.calculateHashKey())
  }
  
  func testCastlingPieceMovementIsHashedCorrectly() {
    let pos = CTPosition()
    
    pos.makeMove(from: .e2, to: .e4)
    pos.makeMove(from: .e7, to: .e5)
    pos.makeMove(from: .g1, to: .f3)
    pos.makeMove(from: .b8, to: .c6)
    pos.makeMove(from: .f1, to: .b5)
    pos.makeMove(from: .g8, to: .f6)
    
    let hashBeforeCastling = pos.hashKey
    
    pos.makeMove(from: .e1, to: .g1)
    
    let hashAfterCastling = pos.hashKey
    
    let rookHashH1 = HashUtils.shared.hash(for: .whiteRook, on: .h1)
    let rookHashF1 = HashUtils.shared.hash(for: .whiteRook, on: .f1)
    let kingHashG1 = HashUtils.shared.hash(for: .whiteKing, on: .g1)
    let kingHashE1 = HashUtils.shared.hash(for: .whiteKing, on: .e1)
    let castlingHashAfterCastling = HashUtils.shared.hash(for: pos.castlingRights)
    let castlingHashExpectedAfterTakeBack = HashUtils.shared.hash(for: CTCastlingRights())
    
    var expectedHashKeyAfterTakeBack = hashAfterCastling
    expectedHashKeyAfterTakeBack ^= rookHashF1
    expectedHashKeyAfterTakeBack ^= rookHashH1
    expectedHashKeyAfterTakeBack ^= kingHashG1
    expectedHashKeyAfterTakeBack ^= kingHashE1
    expectedHashKeyAfterTakeBack ^= castlingHashAfterCastling
    expectedHashKeyAfterTakeBack ^= castlingHashExpectedAfterTakeBack
    expectedHashKeyAfterTakeBack ^= HashUtils.shared.sideHashKey
    
    pos.takeBackMove()
    
    XCTAssertEqual(hashBeforeCastling, pos.hashKey)
    XCTAssertEqual(hashBeforeCastling, expectedHashKeyAfterTakeBack)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
  }
  
  func testEnPassantMovementIsHashedCorrectly() {
    let pos = CTPosition()
    
    pos.makeMove(from: .d2, to: .d4)
    pos.makeMove(from: .h7, to: .h6)
    pos.makeMove(from: .d4, to: .d5)
    pos.makeMove(from: .e7, to: .e5)

    let hashBeforeEp = pos.hashKey
    
    pos.makeMove(from: .d5, to: .e6)
    
    let hashAfterEp = pos.hashKey
    
    let hashPawnE6 = HashUtils.shared.hash(for: .whitePawn, on: .e6)
    let hashPawnD5 = HashUtils.shared.hash(for: .whitePawn, on: .d5)
    let hashPawnE5 = HashUtils.shared.hash(for: .blackPawn, on: .e5)
    
    var expectedHashKeyAfterTakeBack = hashAfterEp
    expectedHashKeyAfterTakeBack ^= hashPawnE6
    expectedHashKeyAfterTakeBack ^= hashPawnD5
    expectedHashKeyAfterTakeBack ^= hashPawnE5
    expectedHashKeyAfterTakeBack ^= HashUtils.shared.sideHashKey
    expectedHashKeyAfterTakeBack ^= HashUtils.shared.hash(for: .e6)
    
    pos.takeBackMove()
    
    XCTAssertEqual(hashBeforeEp, pos.hashKey)
    XCTAssertEqual(hashBeforeEp, expectedHashKeyAfterTakeBack)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
  }
  
  func testPromotionIsHashedCorrectly() {
    let pos = CTPosition(fen: "7k/1P6/8/8/8/8/8/4K3 w - - 0 1")
    
    pos.promotionPieceWhite = .whiteQueen
    pos.makeMove(from: .b7, to: .b8)
    
    XCTAssertEqual(pos.pieceAt(.b8), .whiteQueen)
    
    let pawnHashB7 = HashUtils.shared.hash(for: .whitePawn, on: .b7)
    let queenHashB8 = HashUtils.shared.hash(for: .whiteQueen, on: .b8)
    
    var expectedHash = pos.hashKey
    expectedHash ^= queenHashB8
    expectedHash ^= pawnHashB7
    expectedHash ^= HashUtils.shared.sideHashKey
    
    pos.takeBackMove()
    
    XCTAssertEqual(pos.pieceAt(.b7), .whitePawn)
    XCTAssertEqual(pos.hashKey, expectedHash)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
  }
  
  func testPromotionWithCaptureIsHashedCorrectly() {
    let pos = CTPosition(fen: "2r4k/1P6/8/8/8/8/8/4K3 w - - 0 1")
    
    pos.promotionPieceWhite = .whiteQueen
    pos.makeMove(from: .b7, to: .c8)
    
    XCTAssertEqual(pos.pieceAt(.c8), .whiteQueen)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
    
    pos.takeBackMove()
    
    XCTAssertEqual(pos.pieceAt(.b7), .whitePawn)
    XCTAssertEqual(pos.hashKey, pos.calculateHashKey())
  }
}
