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

#if !os(macOS)
public typealias ViewType = UIView
public typealias ImageViewType = UIImageView
public typealias FontType = UIFont
public typealias ColorType = UIColor
public typealias ImageType = UIImage
public typealias RectType = CGRect
#else
public typealias ViewType = NSView
public typealias ImageViewType = NSImageView
public typealias FontType = NSFont
public typealias ColorType = NSColor
public typealias ImageType = NSImage
public typealias RectType = NSRect
#endif

