//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 25.04.20.
//

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

internal class DrawingUtils {
  
  static func fillRectangle(_ rect: RectType) {
    #if !os(macOS)
    UIRectFill(rect)
    #else
    rect.fill()
    #endif
  }
  
}
