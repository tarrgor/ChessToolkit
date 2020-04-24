//
//  String+Extension.swift
//  ChessToolkit
//
//  Created by Thorsten Klusemann on 28.06.15.
//  Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

import Foundation

public extension String {
  
  func trim() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
  
  subscript (index: Int) -> Character {
    return self[self.index(self.startIndex, offsetBy: index)]
  }

  subscript (index: Int) -> String {
    return String(self[index] as Character)
  }

}
