//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

#if os(macOS)

import AppKit

class MacosDrawingService: DrawingService {
  
  func fillRectangle(_ rect: RectType) {
    rect.fill()
  }
  
}

#endif
