//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

import Foundation

struct PlatformFactory {
  
  static func drawingStrategy() -> DrawingStrategy {
    #if !os(macOS)
    return IosDrawingStrategy()
    #else
    return MacosDrawingStrategy()
    #endif
  }
  
}
