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
        let txtContainer = textContainers[0] as! ComicBubbleTextContainer
        txtContainer.minLineFragmentY = 0
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
    }

    func textContainerFull() {
        increaseTextContainerSize()
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
        textContainer.exclusionPaths = [getExclusionPath(width: bounds.width)]
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.mainBubbleLayer = self.mainBubbleLayer
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
        textContainer.exclusionPaths = [getExclusionPath(width: bounds.width)]
    }
    
    func getExclusionPath(width: CGFloat) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func drawBackgroundShapes(width: CGFloat) -> (shapes: [CAShapeLayer], mainBubble: CAShapeLayer) {
        return ([], CAShapeLayer())
    }
    
}
