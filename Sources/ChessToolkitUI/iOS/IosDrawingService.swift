//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

#if !os(macOS)

import UIKit

class IosDrawingService: DrawingService {
  
  func fillRectangle(_ rect: RectType) {
    UIRectFill(rect)
  }
  
}

#endif
