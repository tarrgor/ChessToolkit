//
//  CTPieceSet.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 06.07.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

import ChessToolkit

public class CTPieceSet {
  
  fileprivate var _cache = Dictionary<CTPiece, ImageType>()
  
  var name: String
  
  // MARK: Initialization
  
  public init(name: String) {
    self.name = name
  }
  
  // MARK: Image handling
  
  func imageForPiece(_ piece: CTPiece, size: CGSize? = nil) -> UIImage? {
    guard let filename = determineFilename(forSetWithName: name, piece: piece) else { return nil }

    // Create and return image
    var image: UIImage? = nil
    
    if let cachedImg = _cache[piece] {
      image = cachedImg
    } else {
      guard let pdfImage = ImageType(named: filename) else {
        print("Cannot load image for pieceSet \(name): \(filename)")
        return nil
      }
      image = pdfImage
      _cache.updateValue(image!, forKey: piece)
    }
    
    return image
  }
  
  // MARK: Private methods

  fileprivate func determineFilename(forSetWithName namespace: String, piece: CTPiece) -> String? {
    // Check piece
    guard piece != .empty && piece != .invalid else { return nil }
    
    let color = piece.side() == .white ? "W" : "B"
    let pieceString = piece.toPGN() == "" ? "P" : piece.toPGN()
    let filename = "\(namespace)/\(color)\(pieceString)"
    return filename
  }
  
}
