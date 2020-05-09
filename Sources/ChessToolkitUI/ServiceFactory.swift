//
//  File.swift
//  
//
//  Created by Thorsten Klusemann on 09.05.20.
//

import Foundation

struct ServiceFactory {
  
  static func createBoardDrawingService() -> DrawingService {
    #if !os(macOS)
    return IosDrawingService()
    #else
    return MacosBoardDrawingService()
    #endif
  }
  
}
