//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

protocol DrawingStrategy {
  
  func fillRectangle(_ rect: RectType)
  func rectForRow(_ row: Int, col: Int, size: CGFloat, offset: CGFloat) -> RectType
  
}
