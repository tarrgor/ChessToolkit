//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

#if !os(macOS)

import UIKit

class IosDrawingStrategy: DrawingStrategy {
  
  func fillRectangle(_ rect: RectType) {
    UIRectFill(rect)
  }
  
  func rectForRow(_ row: Int, col: Int, size: CGFloat, offset: CGFloat = 0.0) -> RectType {
    let squareRect = CGRect(x: CGFloat(col) * size + offset,
                            y: CGFloat(7 - row) * size + offset,
                            width: size,
                            height: size)
    return squareRect
  }
  
}

#endif
