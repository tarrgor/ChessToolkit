//
//  CTFENParserTests.swift
//  ChessDB
//
//  Created by Thorsten Klusemann on 13.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import XCTest
@testable import ChessToolkit

class CTFENParserTests: XCTestCase {
  
  static var allTests = [
    ("testCreateFENParser_InvalidNumberOfRows", testCreateFENParser_InvalidNumberOfRows),
    ("testCreateFENParser_CorrectNumberOfRows", testCreateFENParser_CorrectNumberOfRows),
    ("testCreateFENParser_PositionCorrect", testCreateFENParser_PositionCorrect),
    ("testCreateFENParser_PositionCorrect2", testCreateFENParser_PositionCorrect2),
    ("testCreateFENParser_InvalidCharacterInPos", testCreateFENParser_InvalidCharacterInPos),
    ("testCreateFENParser_MismatchInColumnCount", testCreateFENParser_MismatchInColumnCount),
    ("testCreateFENParser_SideToMoveIsCorrect", testCreateFENParser_SideToMoveIsCorrect),
    ("testCreateFENParser_SideToMoveIsIncorrect", testCreateFENParser_SideToMoveIsIncorrect),
    ("testCreateFENParser_CastlingRightsAreCorrect", testCreateFENParser_CastlingRightsAreCorrect),
    ("testCreateFENParser_CastlingRightsAreCorrect2", testCreateFENParser_CastlingRightsAreCorrect2),
    ("testCreateFENParser_CastlingRightsAreCorrect3", testCreateFENParser_CastlingRightsAreCorrect3),
    ("testCreateFENParser_CastlingRightsWithInvalidCharacter", testCreateFENParser_CastlingRightsWithInvalidCharacter),
    ("testCreateFENParser_EnPassantFieldSetCorrectly", testCreateFENParser_EnPassantFieldSetCorrectly),
    ("testCreateFENParser_EnPassantFieldSetCorrectlyWhenEmpty", testCreateFENParser_EnPassantFieldSetCorrectlyWhenEmpty),
    ("testCreateFENParser_EnPassantFieldWithInvalidCombination", testCreateFENParser_EnPassantFieldWithInvalidCombination),
    ("testCreateFENParser_EnPassantFieldWithInvalidLength", testCreateFENParser_EnPassantFieldWithInvalidLength),
    ("testCreateFENParser_HalfMovesAreSetCorrectly", testCreateFENParser_HalfMovesAreSetCorrectly),
    ("testCreateFENParser_HalfMovesIncorrect", testCreateFENParser_HalfMovesIncorrect),
    ("testCreateFENParser_FullMoveNumberIsSetCorrectly", testCreateFENParser_FullMoveNumberIsSetCorrectly),
    ("testCreateFENParser_FullMoveNumberIncorrect", testCreateFENParser_FullMoveNumberIncorrect),
    ("testCreateFENParser_InvalidElementCount", testCreateFENParser_InvalidElementCount),
    ("testCreateFENParser_BugEnPassantSquareOnD6", testCreateFENParser_BugEnPassantSquareOnD6)
  ]
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCreateFENParser_InvalidNumberOfRows() {
    let fp = CTFENParser(fen:"rnbqkbnr/pppppppp/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    XCTAssert(fp.valid == false, "FEN is not marked invalid.")
    XCTAssert(fp.validationMessage == "Invalid number of rows", "FEN has not the correct validation message.")
  }
  
  func testCreateFENParser_CorrectNumberOfRows() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    XCTAssert(fp.valid == true, "FEN is not marked valid.")
    XCTAssert(fp.validationMessage == "OK", "FEN has not the correct validation message.")
  }
  
  func testCreateFENParser_PositionCorrect() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    
    let sqa8 = fp.posData[CTSquare.a8.rawValue]
    let sqe7 = fp.posData[CTSquare.e7.rawValue]
    let sqc4 = fp.posData[CTSquare.c4.rawValue]
    let sqd1 = fp.posData[CTSquare.d1.rawValue]
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(sqa8 == .blackRook, "Piece on a8 is not a black rook.")
    XCTAssert(sqe7 == .blackPawn, "Piece on e7 is not a black pawn.")
    XCTAssert(sqc4 == .empty, "Piece on c4 is not empty.")
    XCTAssert(sqd1 == .whiteQueen, "Piece on d1 is not a white queen.")
  }
  
  func testCreateFENParser_PositionCorrect2() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    
    let sqa8 = fp.posData[CTSquare.a8.rawValue]
    let sqe2 = fp.posData[CTSquare.e2.rawValue]
    let sqc5 = fp.posData[CTSquare.c5.rawValue]
    let sqf3 = fp.posData[CTSquare.f3.rawValue]
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(sqa8 == .blackRook, "Piece on a8 is not a black rook.")
    XCTAssert(sqe2 == .empty, "Piece on e2 is not empty.")
    XCTAssert(sqc5 == .blackPawn, "Piece on c5 is not a black pawn.")
    XCTAssert(sqf3 == .whiteKnight, "Piece on f3 is not a white knight.")
  }
  
  func testCreateFENParser_InvalidCharacterInPos() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1Xpppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Invalid character found: X", "Wrong validation message.")
  }
  
  func testCreateFENParser_MismatchInColumnCount() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp3ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Mismatch in column count: 10", "Wrong validation message.")
  }
  
  func testCreateFENParser_SideToMoveIsCorrect() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    
    XCTAssert(fp.sideToMove == .black, "Side to move is not black.")
  }
  
  func testCreateFENParser_SideToMoveIsIncorrect() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R y KQkq - 1 2")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Invalid side to move: y", "Validation message is incorrect.")
  }
  
  func testCreateFENParser_CastlingRightsAreCorrect() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    
    XCTAssert(fp.castlingRights.blackCanCastleLong == true, "Black can castle long is not true.")
    XCTAssert(fp.castlingRights.blackCanCastleShort == true, "Black can castle short is not true.")
    XCTAssert(fp.castlingRights.whiteCanCastleLong == true, "White can castle long is not true.")
    XCTAssert(fp.castlingRights.whiteCanCastleShort == true, "White can castle short is not true.")
  }
  
  func testCreateFENParser_CastlingRightsAreCorrect2() {
    let fp = CTFENParser(fen: "4k3/8/8/8/8/8/4P3/4K3 w - - 5 39")
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(fp.castlingRights.blackCanCastleLong == false, "Black can castle long is not false.")
    XCTAssert(fp.castlingRights.blackCanCastleShort == false, "Black can castle short is not false.")
    XCTAssert(fp.castlingRights.whiteCanCastleLong == false, "White can castle long is not false.")
    XCTAssert(fp.castlingRights.whiteCanCastleShort == false, "White can castle short is not false.")
  }
  
  func testCreateFENParser_CastlingRightsAreCorrect3() {
    let fp = CTFENParser(fen: "r1bqk1nr/pppp1ppp/2n5/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 7 4")
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(fp.castlingRights.blackCanCastleLong == true, "Black can castle long is not true.")
    XCTAssert(fp.castlingRights.blackCanCastleShort == true, "Black can castle short is not true.")
    XCTAssert(fp.castlingRights.whiteCanCastleLong == false, "White can castle long is not false.")
    XCTAssert(fp.castlingRights.whiteCanCastleShort == false, "White can castle short is not false.")
  }
  
  func testCreateFENParser_CastlingRightsWithInvalidCharacter() {
    let fp = CTFENParser(fen: "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQmq - 1 2")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Invalid castling flag: m", "Incorrect validation message.")
  }
  
  func testCreateFENParser_EnPassantFieldSetCorrectly() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(fp.enPassantSquare == CTSquare.e3, "En passant field is not e3.")
  }
  
  func testCreateFENParser_EnPassantFieldSetCorrectlyWhenEmpty() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b KQkq - 0 1")
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(fp.enPassantSquare == nil, "En passant field is not nil.")
  }
  
  func testCreateFENParser_EnPassantFieldWithInvalidCombination() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq ee 0 1")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Invalid combination for en passant square: ee", "Wrong validation message.")
  }
  
  func testCreateFENParser_EnPassantFieldWithInvalidLength() {
    let fp = CTFENParser(fen: "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e22 0 1")
    
    XCTAssert(fp.valid == false, "Valid is not false.")
    XCTAssert(fp.validationMessage == "Invalid length of en passant square: 3", "Wrong validation message.")
  }
  
  func testCreateFENParser_HalfMovesAreSetCorrectly() {
    let fp = CTFENParser(fen: "7r/p3q1k1/1pQ3p1/2Pp1p2/1P1P4/4P3/5P2/2B1K1R1 b - - 79 40")
    
    XCTAssert(fp.halfMoveClock == 79, "Invalid halfmove clock: \(fp.halfMoveClock)")
  }
  
  func testCreateFENParser_HalfMovesIncorrect() {
    let fp = CTFENParser(fen: "7r/p3q1k1/1pQ3p1/2Pp1p2/1P1P4/4P3/5P2/2B1K1R1 b - - 7a 40")
    
    XCTAssert(fp.valid == false, "Valid is not true.")
    XCTAssertEqual(fp.validationMessage, "Invalid half move clock: 7a", "Incorrect validation message.")
  }
  
  func testCreateFENParser_FullMoveNumberIsSetCorrectly() {
    let fp = CTFENParser(fen: "7r/p3q1k1/1pQ3p1/2Pp1p2/1P1P4/4P3/5P2/2B1K1R1 b - - 79 40")
    
    XCTAssert(fp.fullMoveNumber == 40, "Invalid full move number: \(fp.fullMoveNumber)")
  }
  
  func testCreateFENParser_FullMoveNumberIncorrect() {
    let fp = CTFENParser(fen: "7r/p3q1k1/1pQ3p1/2Pp1p2/1P1P4/4P3/5P2/2B1K1R1 b - - 79 4a")
    
    XCTAssert(fp.valid == false, "Valid is not true.")
    XCTAssertEqual(fp.validationMessage, "Invalid full move number: 4a", "Incorrect validation message.")
  }
  
  func testCreateFENParser_InvalidElementCount() {
    let fp = CTFENParser(fen: "7r/p3q1k1/1pQ3p1/2Pp1p2/1P1P4/4P3/5P2/2B1K1R1 b - - 79 4a xy")
    
    XCTAssert(fp.valid == false, "Valid is not true.")
    XCTAssertEqual(fp.validationMessage, "Invalid element count: 7", "Incorrect validation message.")
  }
  
  func testCreateFENParser_BugEnPassantSquareOnD6() {
    let fp = CTFENParser(fen: "rnbqkbnr/p1p1ppp1/1p5p/3pP3/8/P7/1PPP1PPP/RNBQKBNR w KQkq d6 6 4")
    
    XCTAssert(fp.valid == true, "Valid is not true.")
    XCTAssert(fp.enPassantSquare == .d6, "En passant square is not D6.")
  }
}
