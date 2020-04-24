//
//  CTGame.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 30.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

open class CTGame {
  
  fileprivate var _currentNode: CTMoveNode
  
  open var position: CTPosition
  
  var rootNode: CTMoveNode
  
  var currentNode: CTMoveNode {
    return _currentNode
  }
  
  // MARK: Initialization
  
  public init() {
    position = CTPosition()
    rootNode = CTMoveNode(fen: position.toFEN())
    _currentNode = rootNode
    
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(forName: NSNotification.Name(rawValue: CTConstants.kNotificationPositionDidMakeMove), object: self.position, queue: OperationQueue.main) { [weak self] (notification) -> Void in
      if let moveWrapper: CTObjectWrapper<CTMove> = notification.userInfo?[CTConstants.kUserInfoAttributeMove] as? CTObjectWrapper<CTMove> {
        let move = moveWrapper.wrappedValue
        print("Received notification with move \(move.toNotation(.short))")
        let fen = self!.position.toFEN()
        let parentNode = self!._currentNode
        self!._currentNode = CTMoveNode(fen: fen, parent: parentNode, move: move, mode: .variation)
        self!.sendDidInsertMoveNodeNotification(self!._currentNode)
      }
    }
  }
  
  // MARK: Move methods
  
  func insertMoveAtNode(_ node: CTMoveNode, from: CTSquare, to: CTSquare, mode: CTMoveInsertionMode = .variation) -> Bool {
    if node !== _currentNode {
      position.setToFEN(node.fen)
    }
    
    let valid = position.makeMove(from: from, to: to, validate: true, notifications: false)
    
    if valid {
      if let move = position.lastMove {
        let fen = position.toFEN()
        _currentNode = CTMoveNode(fen: fen, parent: node, move: move, mode: mode)
        sendDidInsertMoveNodeNotification(_currentNode)
        return true
      }
    }
    
    return false
  }
  
  // MARK: Notifications
  
  fileprivate func sendDidInsertMoveNodeNotification(_ node: CTMoveNode) {
    let notificationCenter = NotificationCenter.default
    notificationCenter.post(name: Notification.Name(rawValue: CTConstants.kNotificationGameDidInsertMoveNode), object: self, userInfo: [ CTConstants.kUserInfoAttributeNode : node ])
  }
}
