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
    
    override func processEditing(for textStorage: NSTextStorage, edited editMask: NSTextStorageEditActions, range newCharRange: NSRange, changeInLength delta: Int, invalidatedRange invalidatedCharRange: NSRange) {
        let txtContainer = textContainers[0] as! ComicBubbleTextContainer
        txtContainer.minLineFragmentY = 0
        super.processEditing(for: textStorage, edited: editMask, range: newCharRange, changeInLength: delta, invalidatedRange: invalidatedCharRange)

//        var index = 0
//        var lineRange = NSRange()
//        while (index < numberOfGlyphs) {
//            enumerateLineFragments(forGlyphRange: <#T##NSRange#>, using: <#T##(CGRect, CGRect, NSTextContainer, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void#>)
//            lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//            index = NSMaxRange(lineRange);
//        }
    }
    
    func verticallyCenter(){
        let txtContainer = textContainers[0] as! ComicBubbleTextContainer
        let rect = usedRect(for: txtContainer)
        let heightDelta = txtContainer.size.height - rect.height;
        let lineHeight = lineFragmentRect(forGlyphAt: 0, effectiveRange: nil).size.height
        txtContainer.minLineFragmentY = heightDelta / 2.0 - lineHeight
        invalidateLayout(forCharacterRange: NSRange(location: 0, length: textStorage!.length), actualCharacterRange: nil)
    }
    
    override func setLocation(_ location: CGPoint, forStartOfGlyphRange glyphRange: NSRange) {
        super.setLocation(location, forStartOfGlyphRange: glyphRange)
    }
    override func ensureLayout(for container: NSTextContainer) {
        super.ensureLayout(for: container)
    }
    override func ensureLayout(forBoundingRect bounds: CGRect, in container: NSTextContainer) {
        super.ensureLayout(forBoundingRect: bounds, in: container)
    }
    override func ensureLayout(forGlyphRange glyphRange: NSRange) {
        super.ensureLayout(forGlyphRange: glyphRange)
    }
    override func ensureLayout(forCharacterRange charRange: NSRange) {
        super.ensureLayout(forCharacterRange: charRange)
    }
    override func invalidateLayout(forCharacterRange charRange: NSRange, actualCharacterRange actualCharRange: NSRangePointer?) {
        super.invalidateLayout(forCharacterRange: charRange, actualCharacterRange: actualCharRange)
    }
    override func enumerateEnclosingRects(forGlyphRange glyphRange: NSRange, withinSelectedGlyphRange selectedRange: NSRange, in textContainer: NSTextContainer, using block: @escaping (CGRect, UnsafeMutablePointer<ObjCBool>) -> Void) {
        super.enumerateEnclosingRects(forGlyphRange: glyphRange, withinSelectedGlyphRange: selectedRange, in: textContainer, using: block)
    }
    override func enumerateLineFragments(forGlyphRange glyphRange: NSRange, using block: @escaping (CGRect, CGRect, NSTextContainer, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void) {
        super.enumerateLineFragments(forGlyphRange: glyphRange, using: block)
    }
}

protocol TextContainerDelegate {
    func textContainerFull()
}

class ComicBubbleTextStorage: NSTextStorage {
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let backingStore = NSMutableAttributedString()
    
    override var string: String {
        return backingStore.string
    }
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        backingStore.replaceCharacters(in: range, with: str)
        edited([.editedCharacters, .editedAttributes], range: range, changeInLength: (str as NSString).length - range.length)
        endEditing()
        
//        let layoutMgr = layoutManagers[0] as! ComicBubbleLayoutManager
//        layoutMgr.verticallyCenter()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
}
class ComicBubbleTextContainer: NSTextContainer {
    var delegate: TextContainerDelegate?
    var minLineFragmentY: CGFloat = 0 {
        didSet {
            print("minLineFragmentY: \(minLineFragmentY)")
        }
    }
    var verticallyCenterExclusionPath: UIBezierPath? {
        didSet {
            if let oldPath = oldValue {
                for (i, path) in exclusionPaths.enumerated() {
                    if (path.isEqual(oldPath)){
                        exclusionPaths.remove(at: i)
                        break
                    }
                }
            }
            if let newPath = verticallyCenterExclusionPath {
                exclusionPaths.append(newPath)
            }
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
    
    override func insertText(_ text: String) {
        super.insertText(text)
        let layoutMgr = layoutManager as! ComicBubbleLayoutManager
        layoutMgr.verticallyCenter()
    }
    
    init?(_ coder: NSCoder? = nil) {
        let txtStorage = ComicBubbleTextStorage()
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
        textContainer.size.height = mainBubbleLayer!.path!.boundingBox.maxY
//        verticallyCenter()
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
//        verticallyCenter()
    }
    
    private var isResizing: Bool = false
    private var lastTextHeight: CGFloat = 0
    

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
            print("finishedResizing: \(newWidth)")
            self.transform = oldTransform
            self.frame.size = CGSize(width: newWidth, height: newWidth)
            self.center = oldCenter
            self.setNeedsLayout()
            self.updateExclusionPath()
            let layoutMgr = self.layoutManager as! ComicBubbleLayoutManager
            layoutMgr.verticallyCenter()
            self.isResizing = false
        })
    }
    
    private func updateExclusionPath(){
        textContainer.exclusionPaths = [getExclusionPath(width: bounds.width)]
    }
    private var lastHeightDifferential: CGFloat = CGFloat.greatestFiniteMagnitude
    
//    private func verticallyCenter(){
//        guard (!isResizing) else {
//            return
//        }
//        if let bubbleHeight = mainBubbleLayer?.path?.boundingBox.height {
//            let sizeOfText = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: text.characters.count), in: textContainer).size
//            let heightDifference = bubbleHeight - sizeOfText.height;
//            if (abs(lastHeightDifferential - heightDifference) < 1.0){
//                return
//            }
//            lastHeightDifferential = heightDifference
//            var topCorrection = mainBubbleLayer!.path!.boundingBox.minY +
//                (heightDifference) / 2.0
//            topCorrection = max(0, topCorrection)
//            textContainer.exclusionPaths = [
//                getExclusionPath(width: bounds.width),
//                UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: topCorrection)))
//            ]
//            if (bounds.height > bounds.width) {
//                textContainer.exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: bounds.width, width: bounds.width, height: bounds.height - bounds.width)))
//            }
//        }
//    }
    
    func getExclusionPath(width: CGFloat) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func drawBackgroundShapes(width: CGFloat) -> (shapes: [CAShapeLayer], mainBubble: CAShapeLayer) {
        return ([], CAShapeLayer())
    }
    
}
