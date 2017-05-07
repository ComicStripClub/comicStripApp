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

class MyLayoutManager: NSLayoutManager {
    override init() {
        super.init()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func lineFragmentRect(forGlyphAt glyphIndex: Int, effectiveRange effectiveGlyphRange: NSRangePointer?) -> CGRect {
        return super.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: effectiveGlyphRange)
    }
    
}

protocol TextContainerDelegate {
    func textContainerFull()
}

class MyTextContainer: NSTextContainer {
    var delegate: TextContainerDelegate?
    override var isSimpleRectangularTextContainer: Bool { get { return false } }
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        let rect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        print("Proposed: [\(proposedRect)], Returned: [\(rect)]")
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
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init?(_ coder: NSCoder? = nil) {
        let txtStorage = NSTextStorage()
        let layoutMgr = MyLayoutManager()
        txtStorage.addLayoutManager(layoutMgr)
        
        let customTextContainer = MyTextContainer()
        customTextContainer.lineBreakMode = .byWordWrapping
        customTextContainer.widthTracksTextView = false
        customTextContainer.heightTracksTextView = false
        layoutMgr.addTextContainer(customTextContainer)
        
        super.init(frame: CGRect.zero, textContainer: customTextContainer)
        delegate = self
        font = UIFont(name: "BackIssuesBB-Italic", size: 14.0)
        textAlignment = .center
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = UIColor.clear
        clipsToBounds = false
        resizeIfNeeded()
    }
    
    func textContainerFull() {
        <#code#>
    }
    
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
        }
        verticallyCenter()
    }
    
    // Only count touches which are inside the dialog bubble
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for layer in backgroundShapes {
            if (layer.path!.contains(point)){
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
        print("textChanged: \(textView.text!)")
        resizeIfNeeded()
        verticallyCenter()
    }
    
    private var isResizing: Bool = false
    private var lastTextHeight: CGFloat = 0
    

    private func increaseTextContainerSize(by scaleFactor: Double = 1.10){
        guard (!isResizing) else {
            return
        }
        isResizing = true
        let oldCenter = center
        var newWidth = bounds.width * scaleFactor
        let widthScale = newWidth / self.frame.size.width
        let oldTransform = self.transform
        UIView.animate(withDuration: 0.15, delay: 0, options: .layoutSubviews, animations: {
            self.transform = self.transform.scaledBy(x: widthScale, y: widthScale)
            print("resizing: \(newWidth)")
        }, completion: { (b) in
            print("finishedResizing: \(newWidth)")
            self.transform = oldTransform
            self.frame.size = CGSize(width: newWidth, height: newWidth)
            self.center = oldCenter
            self.setNeedsLayout()
            self.isResizing = false
            self.verticallyCenter()
        })
    }
    
    private var lastHeightDifferential: CGFloat = CGFloat.greatestFiniteMagnitude
    
    private func verticallyCenter(){
        guard (!isResizing) else {
            return
        }
        let sizeOfText = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        if let bubbleHeight = mainBubbleLayer?.path?.boundingBox.height {
            let heightDifference = bubbleHeight - sizeOfText.height;
            if (abs(lastHeightDifferential - heightDifference) < 1.0){
                return
            }
            lastHeightDifferential = heightDifference
            var topCorrection = mainBubbleLayer!.path!.boundingBox.minY +
                (heightDifference) / 2.0
            topCorrection = max(0, topCorrection)
            textContainer.exclusionPaths = [
                getExclusionPath(width: bounds.width),
                UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: topCorrection)))
            ]
            if (bounds.height > bounds.width) {
                textContainer.exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: bounds.width, width: bounds.width, height: bounds.height - bounds.width)))
            }
        }
    }
    
    func getExclusionPath(width: CGFloat) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func drawBackgroundShapes(width: CGFloat) -> (shapes: [CAShapeLayer], mainBubble: CAShapeLayer) {
        return ([], CAShapeLayer())
    }
    
}
