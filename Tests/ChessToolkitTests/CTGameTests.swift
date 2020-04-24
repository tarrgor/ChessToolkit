//
//  CTGameTests.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 30.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import XCTest
@testable import ChessToolkit

class CTGameTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreateGame() {
        let game = CTGame()
        
        XCTAssert(game.position.sideToMove == .white, "Side to move is not white.")
        XCTAssert(game.rootNode.move == nil, "Root node: Move is not nil.")
        XCTAssert(game.rootNode.parent == nil, "Root node: Parent is not nil.")
        XCTAssert(game.rootNode.nextMoves == nil, "Root node: Next moves not nil after creation.")
    }
    
    func testCreateGameAndAddFirstMove() {
        let game = CTGame()
        
        let valid = game.insertMoveAtNode(game.currentNode, from: .e2, to: .e4, mode: .overwrite)
        
        XCTAssert(valid == true, "Valid not true.")
        XCTAssert(game.rootNode.move == nil, "Root node: Move is not nil.")
        XCTAssertNotNil(game.rootNode.nextMoves, "Root node: Next moves is still nil.")
        XCTAssert(game.rootNode.nextMoves?.first?.move != nil, "Root node: Next moves first element has no move.")
        XCTAssert(game.currentNode.move != nil, "Move of current node is nil.")
        XCTAssert(game.position.pieceAt(.e2) == .empty, "e2 is not empty.")
        XCTAssert(game.position.pieceAt(.e4) == .whitePawn, "No white pawn on e4.")
    }
    
    func testCreateGameAndAddVariations() {
        let game = CTGame()
        
        let _ = game.insertMoveAtNode(game.currentNode, from: .e2, to: .e4)
        let _ = game.insertMoveAtNode(game.currentNode, from: .e7, to: .e5)
        
        let node = game.currentNode
        let _ = game.insertMoveAtNode(node, from: .g1, to: .f3)
        let _ = game.insertMoveAtNode(node, from: .b1, to: .c3)
        
        let parentNode = game.currentNode.parent
        XCTAssert(parentNode?.nextMoves?.count == 2, "Number of variations not 2.")
    }
    
    func testMovesInsertedCorrectlyAfterPositionChanges() {
        let game = CTGame()
        
        let _ = game.position.makeMove(from: .e2, to: .e4)
        
        XCTAssert(game.rootNode.nextMoves?.count == 1, "Move count is not one.")
        XCTAssert(game.rootNode.nextMoves?.first?.move?.from == .e2, "Move from is not e2.")
    }
}
