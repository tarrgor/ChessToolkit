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
  
  fileprivate let kFileNamePrefix = "FileName."
  
  fileprivate var _configuration: Dictionary<CTPiece, String>!
  
  #if !os(macOS)
  fileprivate var _cache = Dictionary<CTPiece, UIImage>()
  #else
  fileprivate var _cache = Dictionary<CTPiece, NSImage>()
  #endif
  
  var bundle: Bundle
  var name: String
  
  // MARK: Initialization
  
  public init(bundle: Bundle, name: String) {
    self.bundle = bundle
    self.name = name
    
    loadConfiguration()
  }
  
  // MARK: Image handling
  
  #if !os(macOS)
  func imageForPiece(_ piece: CTPiece, size: CGSize? = nil) -> UIImage? {
    // Create and return image
    var image: UIImage? = nil
    
    if let cachedImg = _cache[piece] {
      image = cachedImg
    } else {
      if let name = _configuration[piece] {
        if let pdfImage = UIImage(named: name, in: bundle, compatibleWith: nil) {
          image = pdfImage
          _cache.updateValue(image!, forKey: piece)
        }
      }
    }
    
    return image
  }
  #else
  func imageForPiece(_ piece: CTPiece, size: CGSize? = nil) -> NSImage? {
    // Create and return image
    var image: NSImage? = nil

    if let cachedImg = _cache[piece] {
      image = cachedImg
    } else {
      if let name = _configuration[piece] {
        guard let url = bundle.url(forResource: name, withExtension: "pdf") else { return nil }
        if let pdfImage = NSImage(contentsOf: url) {
          image = pdfImage
          _cache.updateValue(image!, forKey: piece)
        }
      }
    }
    
    return image
  }
  #endif
  
  // MARK: Private methods
  
  fileprivate func loadConfiguration() {
    var config = Dictionary<CTPiece, String>()
    
    let fileName = "PieceSet_\(self.name)"
    let ext = "plist"
    
    if let configPath = bundle.path(forResource: fileName, ofType: ext) {
      if let plistFile = NSDictionary(contentsOfFile: configPath) {
        let enumerator = plistFile.keyEnumerator()
        while let key = enumerator.nextObject() as? String {
          let value = plistFile.object(forKey: key)! as! String
          
          let index = kFileNamePrefix.count
          let pieceChar: Character = key[index]
          
          if let piece = CTPiece.fromFEN(pieceChar) {
            config.updateValue(value, forKey: piece)
          } else {
            print("Invalid piece found.")
          }
        }
      }
    } else {
      print("Error opening config file")
    }
    
    self._configuration = config
  }
}
