//
//  CTMoveTests.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 06.08.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import XCTest
@testable import ChessToolkit

class CTMoveTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNotationFromMoveE2E4() {
        let pos = CTPosition()
        let move = CTMoveBuilder.build(pos, from: .e2, to: .e4)
        
        let nShort = move.toNotation(.short)
        let nLong = move.toNotation(.long)
        
        XCTAssert(nShort == "e4", "Short notation is not e4.")
        XCTAssert(nLong == "e2-e4", "Long notation is not e2-e4.")
    }

    func testNotationFromMoveE7E5() {
        let pos = CTPosition()
        let _ = pos.makeMove(from: .e2, to: .e4)
        let _ = pos.makeMove(from: .e7, to: .e5)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "e5", "Short notation is not e5.")
        XCTAssert(nLong == "e7-e5", "Long notation is not e7-e5.")
    }

    func testNotationFromMoveG1F3() {
        let pos = CTPosition()
        let _ = pos.makeMove(from: .e2, to: .e4)
        let _ = pos.makeMove(from: .e7, to: .e5)
        let _ = pos.makeMove(from: .g1, to: .f3)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "Nf3", "Short notation is not Nf3.")
        XCTAssert(nLong == "Ng1-f3", "Long notation is not Ng1-f3.")
    }
    
    func testNotationForCapturingMoveWithPiece() {
        let pos = CTPosition(fen: "r1bqkbnr/1ppp1ppp/p1n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 6 4")
        
        let _ = pos.makeMove(from: .b5, to: .c6)

        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "Bxc6", "Short notation is not Bxc6.")
        XCTAssert(nLong == "Bb5xc6", "Long notation is not Bb5xc6.")
    }

    func testNotationForCapturingMoveWithPawn() {
        let pos = CTPosition(fen: "r1bqkbnr/1ppp1ppp/p1n5/1B2p3/4P3/5N1P/PPPP1PP1/RNBQK2R b KQkq - 7 4")
        
        let _ = pos.makeMove(from: .a6, to: .b5)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "axb5", "Short notation is not axb5.")
        XCTAssert(nLong == "a6xb5", "Long notation is not a6xb5.")
    }
    
    func testNotationForMoveWithCheck() {
        let pos = CTPosition(fen: "rnbqkbnr/ppp2ppp/3p4/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 4 3")
        
        let _ = pos.makeMove(from: .f1, to: .b5)

        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)

        XCTAssert(nShort == "Bb5+", "Short notation is not Bb5+.")
        XCTAssert(nLong == "Bf1-b5+", "Long notation is not Bf1-b5+.")
    }
    
    func testNotationWithPromotionAndCheck() {
        let pos = CTPosition(fen: "rnbqkbnr/ppp3P1/3p4/4p3/4P2p/5N2/PPPP1P1P/RNBQKB1R w KQkq - 12 7")
        
        let _ = pos.makeMove(from: .g7, to: .f8)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "gxf8Q+", "Short notation is not gxf8Q+.")
        XCTAssert(nLong == "g7xf8Q+", "Long notation is not g7xf8Q+.")
    }
    
    func testNotationWithCastlingShort() {
        let pos = CTPosition(fen: "rnbqk2r/pppp1ppp/5n2/2b1p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 6 4")
        
        let _ = pos.makeMove(from: .e1, to: .g1)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "O-O", "Short notation is not O-O.")
        XCTAssert(nLong == "O-O", "Long notation is not O-O.")
    }

    func testNotationWithCastlingLong() {
        let pos = CTPosition(fen: "rnb5/pppk1p2/5n1r/2P1p1p1/1N2P3/5N2/PPP1QPPP/R3K2R w KQ - 22 12")
        
        let _ = pos.makeMove(from: .e1, to: .c1)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "O-O-O+", "Short notation is not O-O-O+.")
        XCTAssert(nLong == "O-O-O+", "Long notation is not O-O-O+.")
    }
    
    func testNotationWithEnPassantCapture() {
        let pos = CTPosition(fen: "rnbqkbnr/1pppp1pp/p7/4Pp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 4 3")
        
        let _ = pos.makeMove(from: .e5, to: .f6)
        
        let nShort = pos.lastMove!.toNotation(.short)
        let nLong = pos.lastMove!.toNotation(.long)
        
        XCTAssert(nShort == "exf6", "Short notation is not exf6.")
        XCTAssert(nLong == "e5xf6", "Long notation is not e5xf6.")
    }
}
