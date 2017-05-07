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
    
    var mainBubbleLayer: CAShapeLayer!
    
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        if (editMask.contains(.editedCharacters)){
            let txtContainer = textContainers[0] as! ComicBubbleTextContainer
            txtContainer.minLineFragmentY = 0
        }
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)
    }
    
    func verticallyCenter(){
        let txtContainer = textContainers[0] as! ComicBubbleTextContainer
        let rect = usedRect(for: txtContainer)
        let heightDelta = mainBubbleLayer.path!.boundingBox.height - rect.height;
        let lineHeight = lineFragmentRect(forGlyphAt: 0, effectiveRange: nil).size.height
        txtContainer.minLineFragmentY = heightDelta / 2.0 - lineHeight / 2.0
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

    override var isSimpleRectangularTextContainer: Bool { get { return false } }
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        var adjustedRect = proposedRect
        adjustedRect.origin.y = max(proposedRect.origin.y, minLineFragmentY)
        let rect = super.lineFragmentRect(forProposedRect: adjustedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        // print("Proposed: [\(proposedRect)], Returned: [\(rect)]")
        if (rect.isEmpty){
            delegate?.textContainerFull()
        }
        return rect
    }
}

@IBDesignable class BaseDialogBubble : UITextView, UITextViewDelegate, TextContainerDelegate {
    private let MINIMUM_WIDTH: CGFloat = 100
    
    var backgroundShapes: [CAShapeLayer] = []
    var mainBubbleLayer: CAShapeLayer!
    private var shouldAutoResize: Bool = true
    private var flipBubbleImageView: UIImageView!
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init?(_ coder: NSCoder? = nil) {
        let txtStorage = NSTextStorage()
        let layoutMgr = ComicBubbleLayoutManager()
        txtStorage.addLayoutManager(layoutMgr)
        
        let customTextContainer = ComicBubbleTextContainer()
        customTextContainer.lineBreakMode = .byWordWrapping
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

        let flipImageView = UIImageView(image: #imageLiteral(resourceName: "flipIcon"))
        flipImageView.isUserInteractionEnabled = true
        flipImageView.contentMode = .scaleAspectFill
        flipImageView.bounds.size = CGSize(width: 32, height: 32)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFlipButton))
        flipImageView.addGestureRecognizer(tapRecognizer)
        addSubview(flipImageView)
        flipBubbleImageView = flipImageView

        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(userDidPinchBubble))
        addGestureRecognizer(pinchRecognizer)
    }

    @objc private func didTapFlipButton(_: UITapGestureRecognizer){
        changeOrientation()
    }
    
    func textContainerFull() {
        guard (shouldAutoResize) else {
            return
        }
        increaseTextContainerSize()
    }
    
    private var originalWidth: CGFloat = 0
    @objc private func userDidPinchBubble(_ gestureRecognizer: UIPinchGestureRecognizer){
        switch gestureRecognizer.state {
        case .began:
            shouldAutoResize = false
            originalWidth = bounds.width
            break
        case .changed:
            let scale = gestureRecognizer.scale
            isResizing = true
            let oldCenter = center
            let newWidth = originalWidth * scale
            self.frame.size = CGSize(width: newWidth, height: newWidth)
            self.center = oldCenter
            self.setNeedsLayout()
            self.updateExclusionPath()
            let layoutMgr = self.layoutManager as! ComicBubbleLayoutManager
            layoutMgr.verticallyCenter()
            self.isResizing = false
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
            updateExclusionPath()
            updateButtonPositions()
            print("Frame: \(frame)")
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
        super.layoutSubviews()
        guard (!isResizing) else {
            return
        }
        print("layoutSubviews (\(bounds.width))")
        for shape in backgroundShapes {
            shape.removeFromSuperlayer()
        }
        var mainBubble: CAShapeLayer
        (self.backgroundShapes, mainBubble) = drawBackgroundShapes(width: bounds.width)
        self.mainBubbleLayer = mainBubble
        for (i, shape) in backgroundShapes.enumerated() {
            layer.insertSublayer(shape, at: UInt32(i))
            adjustShapeForBubbleOrientation(shape)
        }
        updateExclusionPath()
        updateButtonPositions()
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.mainBubbleLayer = self.mainBubbleLayer
    }
    
    private func updateButtonPositions(){
        let bubbleBounds = mainBubbleLayer.path!.boundingBox
        var x: CGFloat = bubbleBounds.width - flipBubbleImageView.bounds.width
        var y: CGFloat = 0
        if let parentView = superview{
            if (frame.maxX > parentView.bounds.width){
                x = parentView.bounds.width - frame.minX - flipBubbleImageView.bounds.width
            }
            if (frame.minY < 0){
                y = -frame.minY
            }
        }
        flipBubbleImageView.frame.origin = CGPoint(x: x, y: y)
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
        if (flipBubbleImageView.frame.contains(point)){
            return true
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
        print("textChanged: \(textView.text!)")
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.verticallyCenter()
    }
    
    private var isResizing: Bool = false

    private func increaseTextContainerSize(by pixels: CGFloat = 20){
        guard (!isResizing) else {
            return
        }
        isResizing = true
        let oldCenter = center
        let newWidth = bounds.width + pixels
        let widthScale = newWidth / self.frame.size.width
        let oldTransform = self.transform
        UIView.animate(withDuration: 0.15, delay: 0, options: .layoutSubviews, animations: {
            self.transform = self.transform.scaledBy(x: widthScale, y: widthScale)
            print("resizing: \(newWidth)")
        }, completion: { (b) in
            self.transform = oldTransform
            self.frame.size = CGSize(width: newWidth, height: newWidth)
            self.center = oldCenter
            self.setNeedsLayout()
            self.updateExclusionPath()
            let layoutMgr = self.layoutManager as! ComicBubbleLayoutManager
            layoutMgr.verticallyCenter()
            print("finishedResizing: \(newWidth)")
            self.isResizing = false
        })
    }
    
    private func updateExclusionPath(){
        var exclusionPaths = [getTransformedExclusionPath(width: bounds.width)]
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
            let mainBubbleBounds = mainBubbleLayer.path!.boundingBox
            if (frame.minY + mainBubbleBounds.maxY > parentView.bounds.height){
                let yOrigin = parentView.bounds.height - frame.minY
                exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: yOrigin, width: bounds.width, height: (frame.minY + mainBubbleBounds.maxY) - yOrigin)))
            }
        }
        textContainer.exclusionPaths = exclusionPaths
    }
    
    func getTransformedExclusionPath(width: CGFloat) -> UIBezierPath {
        let path = getExclusionPath(width: width)
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
    
    func getExclusionPath(width: CGFloat) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func drawBackgroundShapes(width: CGFloat) -> (shapes: [CAShapeLayer], mainBubble: CAShapeLayer) {
        return ([], CAShapeLayer())
    }
    
}
