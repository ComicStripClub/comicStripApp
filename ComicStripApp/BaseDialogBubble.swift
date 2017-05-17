//
//  BaseDialogBubble.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/5/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import CoreText

class ComicBubbleLayoutManager: NSLayoutManager {
    override init() {
        super.init()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var mainBubblePath: UIBezierPath!
    
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        if (editMask.contains(.editedCharacters)){
            let txtContainer = textContainers[0] as! ComicBubbleTextContainer
            txtContainer.minLineFragmentY = 0
        }
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
    }
    
    func verticallyCenter(){
        return
        let txtContainer = textContainers[0] as! ComicBubbleTextContainer
        let rect = usedRect(for: txtContainer)
        let heightDelta = mainBubblePath.cgPath.boundingBox.height - rect.height;
        let lineHeight = lineFragmentRect(forGlyphAt: 0, effectiveRange: nil).size.height
        txtContainer.minLineFragmentY = max(0, heightDelta / 2.0 - lineHeight / 2.0)
        invalidateLayout(forCharacterRange: NSRange(location: 0, length: textStorage!.length), actualCharacterRange: nil)
    }
}

protocol TextContainerDelegate {
    func textContainerFull()
}

class ComicBubbleTextContainer: NSTextContainer {
    var delegate: TextContainerDelegate?
    var minLineFragmentY: CGFloat = 0 {
        didSet {
            print("minLineFragmentY: \(minLineFragmentY)")
        }
    }
    
    var shape: UIBezierPath?

    override var isSimpleRectangularTextContainer: Bool { get { return false } }
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        let lineHeight = proposedRect.height
        let minRectWidth = lineHeight * 3
        var adjustedRect = proposedRect
        
        print("proposed: [\(proposedRect)], charIndex: [\(characterIndex)]")
        
        adjustedRect.origin.y = max(proposedRect.origin.y, minLineFragmentY)
        var rect = CGRect.zero
        let numTries = 7 //proposedRect.origin.y < 0.01 ? 3 : 1
        for i in 0..<numTries {
            rect = super.lineFragmentRect(forProposedRect: adjustedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
            print("lineFragmentRect: proposed[\(adjustedRect)] returned[\(rect)]")

            if (rect.minY < proposedRect.minY){
                rect = CGRect.zero
                break
            }
            else if (rect.width > minRectWidth) {
                break
            } else if let rem = remainingRect?.pointee, rem.width > minRectWidth {
                print("Retrying, shifting over [\(rem.minX)]")
                adjustedRect.origin.x = rem.minX
            } else {
                print("Retrying, shifting down [\(adjustedRect.minY + lineHeight)]")
                adjustedRect.origin = CGPoint(x: 0, y: adjustedRect.minY + lineHeight)
            }
        }
        print("remaining: [\(remainingRect?.pointee)], return: [\(rect)]")
        // print("Proposed: [\(proposedRect)], Returned: [\(rect)]")
        if let shape = shape {
            if (rect.isEmpty && proposedRect.origin.y > shape.bounds.maxY - (lineHeight * 2)){
                print("textContainerFull")
                delegate?.textContainerFull()
            }
        }
        return rect
    }
}

@IBDesignable class BaseDialogBubble : UITextView, UITextViewDelegate, TextContainerDelegate {
    private let MINIMUM_WIDTH: CGFloat = 100
    
    var backgroundShapes: [CAShapeLayer] = []
    var mainBubblePath: UIBezierPath!
    private var shouldAutoResize: Bool = true
    var aspectRatio: CGFloat { get { return 1.0 } }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }

    var actions: [UIBarButtonItem]?

    init?(_ coder: NSCoder? = nil) {
        let txtStorage = NSTextStorage()
        let layoutMgr = ComicBubbleLayoutManager()
        layoutMgr.hyphenationFactor = CGFloat.greatestFiniteMagnitude
        txtStorage.addLayoutManager(layoutMgr)
        
        let customTextContainer = ComicBubbleTextContainer()
        customTextContainer.lineBreakMode = .byWordWrapping
        customTextContainer.lineFragmentPadding = 0
        customTextContainer.widthTracksTextView = false
        customTextContainer.heightTracksTextView = false
        layoutMgr.addTextContainer(customTextContainer)
        
        super.init(frame: CGRect.zero, textContainer: customTextContainer)
        
        delegate = self
        customTextContainer.delegate = self
        font = UIFont(name: "BackIssuesBB-Italic", size: 14.0)
        textAlignment = .center
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = UIColor.clear
        clipsToBounds = false

        let rotateAction = UIBarButtonItem(image: UIImage.imageFromSystemBarButton(.reply), style: .plain, target: self, action: #selector(didRotateBubble))
        let increaseTextSizeAction = UIBarButtonItem(image: #imageLiteral(resourceName: "increase_text_size"), style: .plain, target: self, action: #selector(didIncreaseTextSize))
        let decreaseTextSizeAction = UIBarButtonItem(image: #imageLiteral(resourceName: "decrease_font_size"), style: .plain, target: self, action: #selector(didDecreaseTextSize))
        actions = [rotateAction, increaseTextSizeAction, decreaseTextSizeAction]

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(userDidPinchBubble))
        addGestureRecognizer(pinchRecognizer)
    }

    @objc private func didRotateBubble(_: UIBarButtonItem){
        changeOrientation()
    }
    @objc private func didIncreaseTextSize(_: UIBarButtonItem){
        changeFontSizeBy(2.0)
    }
    
    @objc private func didDecreaseTextSize(_: UIBarButtonItem){
        changeFontSizeBy(-2.0)
    }
    
    private func changeFontSizeBy(_ amount: CGFloat){
        let currentSize = font!.pointSize
        let newSize = currentSize + amount
        guard (newSize > 2.0) else {
            return
        }
        if let selection = selectedTextRange, selection.isEmpty {
            selectAll(self)
            font = font!.withSize(newSize)
            selectedTextRange = textRange(from: endOfDocument, to: endOfDocument)
        } else {
            font = font!.withSize(newSize)
        }

    }
    
    @objc private func didTapFlipButton(_: UITapGestureRecognizer){
        changeOrientation()
    }
    
    func textContainerFull() {
        guard (shouldAutoResize && bounds.size.width > 0 && bounds.size.height > 0) else {
            return
        }
        increaseTextContainerSize()
    }
    
    private var originalSize: CGSize = CGSize.zero
    @objc private func userDidPinchBubble(_ gestureRecognizer: UIPinchGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            shouldAutoResize = false
            originalSize = bounds.size
            break
        case .changed:
            let scale = gestureRecognizer.scale
            // isResizing = true
            let oldCenter = center
            let newSize = originalSize.applying(CGAffineTransform(scaleX: scale, y: scale))
            self.bounds.size = newSize
            self.center = oldCenter
            self.setNeedsLayout()
            self.updateExclusionPath()
            let layoutMgr = self.layoutManager as! ComicBubbleLayoutManager
            layoutMgr.verticallyCenter()
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
    
    override var transform: CGAffineTransform {
        didSet {
            // If this element was moved (e.g. because the user dragged
            // or panned the element), we need to recalculate the exclusionPaths
            // in case the bubble is up against an edge of its superview
            updateExclusionPath()
//            print("Frame: \(frame)")
        }
    }
    
    enum BubbleOrientation: Int {
        case normal
        case flippedHorizontally
        case flippedHorizontallyAndVertically
        case flippedVertically
    }
    
    private var bubbleOrientation: BubbleOrientation = .normal
    
    // Draws the thought bubble outline/fill in the background of the UITextView,
    // and sets the exclusionPaths so that text flows within the boundaries of
    // the thought bubble
    override func layoutSubviews() {
        guard (!isResizing) else {
            return
        }
        super.layoutSubviews()
        print("layoutSubviews (\(bounds))")
        for shape in backgroundShapes {
            shape.removeFromSuperlayer()
        }
        var mainBubble: UIBezierPath
        (self.backgroundShapes, mainBubble) = drawBackgroundShapes(width: bounds.width, height: bounds.height)
        self.mainBubblePath = mainBubble
        for (i, shape) in backgroundShapes.enumerated() {
            layer.insertSublayer(shape, at: UInt32(i))
            adjustShapeForBubbleOrientation(shape)
        }
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.mainBubblePath = self.mainBubblePath
        let comicTextContainer = textContainer as! ComicBubbleTextContainer
        comicTextContainer.shape = mainBubblePath
        updateExclusionPath()
        comicTextContainer.size = bounds.size
        print("layoutSubviews - size[\(bounds.size)] tcSize[\(textContainer.size)]")
    }
    
    private func adjustShapeForBubbleOrientation(_ shape: CAShapeLayer) {
        switch bubbleOrientation {
        case .flippedHorizontally:
            let translate = CATransform3DMakeTranslation(bounds.width, 0, 0)
            let scale = CATransform3DMakeScale(-1.0, 1, 1)
            shape.transform = CATransform3DConcat(scale, translate)
            break
        case .flippedVertically:
            let translate = CATransform3DMakeTranslation(0, bounds.height, 0)
            let scale = CATransform3DMakeScale(1, -1.0, 1)
            shape.transform = CATransform3DConcat(scale, translate)
            break
        case .flippedHorizontallyAndVertically:
            let translate = CATransform3DMakeTranslation(bounds.width, bounds.height, 0)
            let scale = CATransform3DMakeScale(-1.0, -1.0, 1)
            shape.transform = CATransform3DConcat(scale, translate)
            break
        case .normal:
            fallthrough
        default:
            break
        }
    }
    
    func changeOrientation(){
        bubbleOrientation = BubbleOrientation(rawValue: (bubbleOrientation.rawValue + 1) % 4) ?? .normal
        setNeedsLayout()
    }
    
    // Only count touches which are inside the dialog bubble
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for layer in backgroundShapes {
            let affineTransform = CATransform3DGetAffineTransform(layer.transform)
            let transformedPoint = __CGPointApplyAffineTransform(point, affineTransform)
            if (layer.path!.contains(transformedPoint)){
                return super.point(inside: point, with: event)
            }
        }
        return false
    }
    
    override var contentSize: CGSize {
        didSet {
            print("contentSizeChanged: [\(contentSize.width), \(contentSize.height)]")
            // verticallyCenter()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard (!isResizing) else {
            return
        }
        print("textChanged: \(textView.text!)")
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.verticallyCenter()
    }
    
    private var isResizing: Bool = false

    private func increaseTextContainerSize(by pixels: CGFloat = 40){
        guard (!isResizing) else {
            return
        }
        isResizing = true
        let oldCenter = center
        let newWidth = bounds.width + pixels
        let scale = newWidth / bounds.width
        let newHeight = bounds.height * scale
        let oldTransform = self.transform
        let oldOrigin = self.bounds.origin
        let oldSize = self.bounds.size
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            //self.transform = self.transform.scaledBy(x: scale, y: scale)
            self.frame.size = CGSize(width: newWidth, height: newHeight)
            self.updateExclusionPath()
            //self.center = oldCenter
            self.superview!.layoutIfNeeded()
            print("resizing: \(newWidth)")
        }, completion: { (b) in
            self.transform = oldTransform
            self.bounds.size = CGSize(width: newWidth, height: newHeight)
            self.center = oldCenter
            self.isResizing = false
            self.setNeedsLayout()
//            self.updateExclusionPath()
//            self.setNeedsLayout()
//            let layoutMgr = self.layoutManager as! ComicBubbleLayoutManager
//            layoutMgr.verticallyCenter()
            print("finishedResizing: \(newWidth)")
        })
    }
    
    private func updateExclusionPath(){
        var exclusionPaths = [getTransformedExclusionPath(width: bounds.width, height: bounds.height)]
        if (frame.origin.x < 0){
            exclusionPaths.append(UIBezierPath(rect: CGRect(origin: bounds.origin, size: CGSize(width: -frame.origin.x, height: bounds.height))))
        }
        if (frame.origin.y < 0){
            exclusionPaths.append(UIBezierPath(rect: CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: -frame.origin.y))))
        }
        if let parentView = superview {
            if (frame.maxX > parentView.bounds.width){
                let xOrigin = parentView.bounds.width - frame.minX
                exclusionPaths.append(UIBezierPath(rect: CGRect(x: xOrigin, y: 0, width: frame.maxX - xOrigin, height: bounds.height)))
            }
            let mainBubbleBounds = mainBubblePath.cgPath.boundingBox
            if (frame.minY + mainBubbleBounds.maxY > parentView.bounds.height){
                let yOrigin = parentView.bounds.height - frame.minY
                exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: yOrigin, width: bounds.width, height: (frame.minY + mainBubbleBounds.maxY) - yOrigin)))
            }
        }
        textContainer.exclusionPaths = exclusionPaths
    }
    
    func getTransformedExclusionPath(width: CGFloat, height: CGFloat) -> UIBezierPath {
        let path = getExclusionPath(width: width, height: height)
        switch bubbleOrientation {
        case .flippedHorizontally:
            let scale = CGAffineTransform(scaleX: -1.0, y: 1.0)
            let translate = CGAffineTransform(translationX: bounds.width, y: 0)
            path.apply(scale.concatenating(translate))
            break
        case .flippedVertically:
            let scale = CGAffineTransform(scaleX: 1.0, y: -1.0)
            let translate = CGAffineTransform(translationX: 0, y: bounds.height)
            path.apply(scale.concatenating(translate))
            break
        case .flippedHorizontallyAndVertically:
            let scale = CGAffineTransform(scaleX: -1.0, y: -1.0)
            let translate = CGAffineTransform(translationX: bounds.width, y: bounds.height)
            path.apply(scale.concatenating(translate))
            break
        default:
            break
        }
        return path
    }
    
    func getExclusionPath(width: CGFloat, height: CGFloat) -> UIBezierPath {
        let exclusionPath = UIBezierPath(cgPath: mainBubblePath.cgPath)
        exclusionPath.move(to: bounds.origin)
        exclusionPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        exclusionPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        exclusionPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        exclusionPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.minY))
        exclusionPath.close()
        exclusionPath.usesEvenOddFillRule = true
        return exclusionPath
    }
    
    func drawBackgroundShapes(width: CGFloat, height: CGFloat) -> (shapes: [CAShapeLayer], mainBubblePath: UIBezierPath) {
        return ([], UIBezierPath())
    }
    
}
