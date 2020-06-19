//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

#if os(macOS)

import AppKit

class MacosDrawingStrategy: DrawingStrategy {
  
  func fillRectangle(_ rect: RectType) {
    rect.fill()
  }
  
  func rectForRow(_ row: Int, col: Int, size: CGFloat, offset: CGFloat = 0.0) -> RectType {
    let squareRect = RectType(x: CGFloat(col) * size + offset,
                            y: CGFloat(row) * size + offset,
                            width: size,
                            height: size)
    return squareRect
  }
  
}

#endif
