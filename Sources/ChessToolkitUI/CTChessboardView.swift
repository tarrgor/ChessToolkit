//
// Created by Thorsten Klusemann on 18.06.15.
// Copyright (c) 2015 Thorsten Klusemann. All rights reserved.
//

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

import ChessToolkit

let kLabelXOffsetFactor: CGFloat = 0.068
let kLabelYOffsetFactor: CGFloat = 0.045

@IBDesignable
open class CTChessboardView : ViewType {
  
  fileprivate var _rowLabels = [ "1", "2", "3", "4", "5", "6", "7", "8" ]
  fileprivate var _colLabels = [ "A", "B", "C", "D", "E", "F", "G", "H" ]
  
  fileprivate var _referenceRect: CGRect = CGRect.zero
  fileprivate var _squareSize: CGFloat = 0
  
  #if !os(tvOS)
  internal var _draggedItem: ImageType?
  internal var _dragFromSquare: CTSquare?
  internal var _draggedPiece: CTPiece?
  internal var _dragImage: ViewType?
  #endif
  
  fileprivate var _markings = Array<CTSquareMarkingStyle?>(repeating: nil, count: 144)
  
  open var position: CTPosition = CTPosition()

  open var squareLabelFont: FontType = FontType(name: "HelveticaNeue", size: 12)!
  
  @IBInspectable open var lightSquareColor: ColorType = ColorType.lightGray
  @IBInspectable open var darkSquareColor: ColorType = ColorType.darkGray
  @IBInspectable open var markAllPossibleMoves: Bool = true
  @IBInspectable open var markingColor: ColorType = ColorType.green
  @IBInspectable open var markingAlpha: CGFloat = 0.5 {
    didSet {
      if markingAlpha > 1.0 {
        markingAlpha = 1.0
      } else if markingAlpha < 0.0 {
        markingAlpha = 0.0
      }
    }
  }
  @IBInspectable open var border: Bool = false
  @IBInspectable open var borderColor: ColorType = ColorType.white
  @IBInspectable open var borderWidth: CGFloat = 20
  @IBInspectable open var squareLabels: Bool = false
  @IBInspectable open var squareLabelColor: ColorType = ColorType.white
  @IBInspectable open var squareLabelFontSize: CGFloat = 12 {
    didSet {
      #if os(macOS)
      if let fontFamilyName = self.squareLabelFont.familyName {
        if let newFont = FontType(name: fontFamilyName, size: self.squareLabelFontSize) {
          self.squareLabelFont = newFont
        }
      }
      #else
      let fontFamilyName = self.squareLabelFont.familyName
      if let newFont = FontType(name: fontFamilyName, size: self.squareLabelFontSize) {
        self.squareLabelFont = newFont
      }
      #endif
    }
  }
  @IBInspectable open var isBoardFlipped: Bool = false {
    didSet {
      self.setNeedsDisplay(self.frame)
    }
  }
  @IBInspectable open var scalePiecesWhenDragged: Bool = true
  @IBInspectable open var scaledPieceBackgroundColor: ColorType = ColorType(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
  @IBInspectable open var scaledPieceBackgroundAlpha: CGFloat = 0.4
  
  open var markingStyle: CTSquareMarkingStyle = .transparentFill
  open var pieceSet: PieceSet?
  
  var squareSize: CGFloat {
    return _squareSize
  }
  
  // MARK: Initialization
  
  public override init(frame: CGRect) {
    super.init(frame: frame)

    // calculate square sizes
    calculateSizes()
    
    // platform specific initialization
    initializeView()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    
    // calculate square sizes
    calculateSizes()

    // platform specific initialization
    initializeView()
  }
  
  public convenience init(frame: CGRect, pieceSet: PieceSet) {
    self.init(frame: frame)
    self.pieceSet = pieceSet
  }
}

extension CTChessboardView {
  
  func initializeView() {
    #if !os(tvOS)
    
    // reset all dragging helper fields
    self._draggedItem = nil
    self._dragImage = nil
    self._dragFromSquare = nil
    self._draggedPiece = nil
    
    #endif
  }
  
}

extension CTChessboardView {
  // MARK: - Drawing
  
  override open func draw(_ dirtyRect: CGRect) {
    calculateSizes()
    drawBorder()
    drawSquares()
    drawMarkings()
  }
  
  fileprivate func calculateSizes() {
    var offset: CGFloat = 0.0
    if self.border {
      offset = self.borderWidth
    }
    
    let boardSize = self.frame.size.width > self.frame.size.height ? self.frame.size.height - offset * 2.0 : self.frame.size.width - offset * 2.0
    self._referenceRect = CGRect(x: offset, y: offset, width: boardSize, height: boardSize)
    self._squareSize = boardSize / 8
  }
  
  fileprivate func drawBorder() {
    if self.border {
      self.borderColor.setFill()
      DrawingUtils.fillRectangle(self.bounds)
    }
  }
  
  fileprivate func drawSquares() {
    // draw squares
    for row in 0...7 {
      for col in 0...7 {
        let squareRect = rectForRow(row, col: col)
        let index = row + col
        if index % 2 == 0 {
          self.darkSquareColor.set()
        } else {
          self.lightSquareColor.set()
        }
        
        DrawingUtils.fillRectangle(squareRect)

        if (self.squareLabels) {
          if (col == 0) {
            drawLabelForRow(row, squareRect: squareRect)
          }
          if (row == 0) {
            drawLabelForColumn(col, squareRect: squareRect)
          }
        }

        let square = self.isBoardFlipped ? CTSquare.fromRow(7 - row, column: 7 - col) : CTSquare.fromRow(row, column: col)
        
        #if !os(tvOS)
          if _dragFromSquare == nil || square != _dragFromSquare {
            if let image = pieceSet?.imageForPiece(position.pieceAt(square!)) {
              image.draw(in: squareRect.insetBy(dx: _squareSize * 0.12, dy: _squareSize * 0.12))
            }
          }
        #else
          if let image = pieceSet?.imageForPiece(position.pieceAt(square!)) {
            image.draw(in: squareRect.insetBy(dx: _squareSize * 0.12, dy: _squareSize * 0.12))
          }
        #endif
      }
    }
  }
  
  fileprivate func drawLabelForRow(_ row: Int, squareRect: CGRect) {
    let rowIndex = self.isBoardFlipped ? 7 - row : row
    let label = _rowLabels[rowIndex] as NSString
    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.foregroundColor : self.squareLabelColor,
      NSAttributedString.Key.font : self.squareLabelFont ]
    let textSize = label.size(withAttributes: attributes)

    let goodBorder = self.border && self.borderWidth >= 16
    let xp = goodBorder ? squareRect.origin.x - self.borderWidth / 2 - textSize.width / 2 : squareRect.origin.x + self.squareSize * kLabelXOffsetFactor
    let yp = goodBorder ? squareRect.midY - textSize.height / 2 : squareRect.origin.y + self.squareSize * kLabelYOffsetFactor
    
    label.draw(at: CGPoint(x: xp, y: yp), withAttributes: attributes)
  }
  
  fileprivate func drawLabelForColumn(_ column: Int, squareRect: CGRect) {
    let columnIndex = self.isBoardFlipped ? 7 - column : column
    let label = _colLabels[columnIndex] as NSString
    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.foregroundColor : self.squareLabelColor,
      NSAttributedString.Key.font : self.squareLabelFont ]
    let textSize = label.size(withAttributes: attributes)
    
    let goodBorder = self.border && self.borderWidth >= 16
    let xp = goodBorder ? squareRect.midX - textSize.width / 2 : squareRect.origin.x + self.squareSize - self.squareSize * kLabelXOffsetFactor - textSize.width
    let yp = goodBorder ? squareRect.origin.y + self.squareSize + self.borderWidth / 2 - textSize.height / 2 : squareRect.origin.y + self.squareSize - self.squareSize * kLabelYOffsetFactor - textSize.height
    
    label.draw(at: CGPoint(x: xp, y: yp), withAttributes: attributes)
  }
  
  fileprivate func drawMarkings() {
    for i in 26...117 {
      if self._markings[i] != nil {
        if let square = CTSquare(rawValue: i) {
          let pos = square.toRowAndColumn()
          let row = self.isBoardFlipped ? 7 - pos.row : pos.row
          let col = self.isBoardFlipped ? 7 - pos.column : pos.column
          let rect = rectForRow(row, col: col)
          if self.markingStyle == .border {
            self.markingColor.set()
            DrawingUtils.fillRectangle(rect)
          } else {
            let color = self.markingColor.withAlphaComponent(self.markingAlpha)
            color.setFill()
            DrawingUtils.fillRectangle(rect) // using CGBlendMode.normal?
          }
        }
      }
    }
  }
}

extension CTChessboardView {
  // MARK: - Board control methods
  
  public func markSquare(_ square: CTSquare, style: CTSquareMarkingStyle) {
    self._markings[square.rawValue] = style
  }
  
  public func unmarkSquare(_ square: CTSquare, style: CTSquareMarkingStyle) {
    self._markings[square.rawValue] = nil
  }
  
  public func clearAllMarkings() {
    self._markings = Array<CTSquareMarkingStyle?>(repeating: nil, count: 144)
  }
}

extension CTChessboardView {
  // MARK: - Private methods
  
  internal func rowAndColFromLocation(_ location: CGPoint) -> (row: Int, column: Int) {
    if location.x < self._referenceRect.origin.x ||
      location.x > self._referenceRect.origin.x + self._referenceRect.size.width {
        return (-1, -1)
    }
    if location.y < self._referenceRect.origin.y ||
      location.y > self._referenceRect.origin.y + self._referenceRect.size.height {
        return (-1, -1)
    }
    
    let calcY: CGFloat = self._referenceRect.size.height - location.y + self._referenceRect.origin.y
    let calcX: CGFloat = location.x - self._referenceRect.origin.x
    
    var row = Int(calcY / self.squareSize)
    var col = Int(calcX / self.squareSize)
    
    if self.isBoardFlipped {
      row = 7 - row
      col = 7 - col
    }
    
    return (row, col)
  }
  
  internal func rectForRow(_ row: Int, col: Int) -> CGRect {
    var offset: CGFloat = 0.0
    if self.border {
      offset = self.borderWidth
    }
    let squareRect = CGRect(x: CGFloat(col) * self._squareSize + offset, y: CGFloat(7 - row) * self._squareSize + offset, width: self._squareSize, height: self._squareSize)
    return squareRect
  }
  
  internal func rectForLocation(_ location: CGPoint, sizeAddition: CGFloat = 0) -> CGRect {
    let refSize = _squareSize + sizeAddition
    let halfSize = refSize / 2
    let squareRect = CGRect(x: location.x - halfSize, y: location.y - halfSize, width: refSize, height: refSize)
    return squareRect
  }
  
  internal func createPieceImageSubview(_ piece: CTPiece, location: CGPoint) {
    var pieceSize = self.squareSize
    if self.scalePiecesWhenDragged {
      pieceSize = pieceSize * 1.4
    }
    
    if let pieceImage = pieceSet?.imageForPiece(piece) {
      let imageView = ImageViewType(image: pieceImage)
      imageView.translatesAutoresizingMaskIntoConstraints = false
      
      let backgroundView = ViewType()
      backgroundView.bounds = CGRect(x: 0, y: 0, width: (imageView.bounds.size.width) * 1.4,
                                     height: (imageView.bounds.size.height) * 1.4)
      #if !os(macOS)
      if (self.scalePiecesWhenDragged) {
        backgroundView.layer.cornerRadius = backgroundView.bounds.size.height / 2
        backgroundView.backgroundColor = self.scaledPieceBackgroundColor.withAlphaComponent(self.scaledPieceBackgroundAlpha)
      }
      backgroundView.center = location
      #endif
      backgroundView.addSubview(imageView)
      
      self.addSubview(backgroundView)
      
      imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
      imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
      
      #if os(iOS)
      self._dragImage = backgroundView
      #endif
    }
  }
  
  internal func markPossibleSquares(_ square: CTSquare) {
    let generator = self.position.moveGenerator
    let moves = generator.generateAllMovesForSide(self.position.sideToMove)
    moves.forEach { move in
      if (move.from == square) {
        self.markSquare(move.to, style: .border)
      }
    }
  }
}
