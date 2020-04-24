//
//  CTMoveNode.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 30.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

class CTMoveNode {
  
  var fen: String
  weak var parent: CTMoveNode?
  var move: CTMove?
  var nextMoves: [CTMoveNode]?
  
  init(fen: String) {
    self.fen = fen
    self.parent = nil
    self.move = nil
    self.nextMoves = nil
  }
  
  init(fen: String, parent: CTMoveNode, move: CTMove, mode: CTMoveInsertionMode) {
    self.fen = fen
    self.parent = parent
    self.move = move
    self.nextMoves = nil
    
    switch mode {
    case .overwrite:
      self.parent!.nextMoves = [self]
    case .variation:
      if self.parent!.nextMoves != nil {
        self.parent!.nextMoves!.append(self)
      } else {
        self.parent!.nextMoves = [self]
      }
    }
  }
}
