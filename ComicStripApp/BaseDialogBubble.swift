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


@IBDesignable class BaseDialogBubble : UITextView, UITextViewDelegate {
    private let MINIMUM_WIDTH: CGFloat = 100
    
    var backgroundShapes: [CAShapeLayer] = []
    var mainBubbleLayer: CAShapeLayer!
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init?(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)
        }
        else {
            super.init(frame: CGRect.zero, textContainer: nil)
        }
        
        delegate = self
        font = UIFont(name: "BackIssuesBB-Italic", size: 14.0)
        textAlignment = .center
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        backgroundColor = UIColor.clear
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = false
        contentOffset = CGPoint.zero
        clipsToBounds = false
        contentMode = .center
        resizeIfNeeded()
    }
    
    // Draws the thought bubble outline/fill in the background of the UITextView,
    // and sets the exclusionPaths so that text flows within the boundaries of
    // the thought bubble
    override func layoutSubviews() {
        super.layoutSubviews()
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
            verticallyCenter()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        resizeIfNeeded()
        verticallyCenter()
    }
    
    private var isResizing: Bool = false
    
    private func resizeIfNeeded(){
        guard (!isResizing) else {
            return
        }
        
        let sizeOfText = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        if let bubbleHeight = mainBubbleLayer?.path?.boundingBox.height {
            // Resize if necessary
            let lineHeight = font?.lineHeight ?? 0
            let oldCenter = center
            var newWidth: CGFloat?

            if (sizeOfText.height + lineHeight >= bubbleHeight){
                newWidth = frame.size.width * 1.15
            } else if (sizeOfText.height < bubbleHeight / 3.0 && frame.size.width > MINIMUM_WIDTH) {
                newWidth = max(sizeOfText.height + 50, MINIMUM_WIDTH)
            }
            
            if let newWidth = newWidth {
                isResizing = true
                let widthScale = newWidth / self.frame.size.width
                let oldTransform = self.transform
                UIView.animate(withDuration: 0.15, delay: 0, options: .layoutSubviews, animations: {
                    self.transform = self.transform.scaledBy(x: widthScale, y: widthScale)
                }, completion: { (b) in
                    self.transform = oldTransform
                    self.frame.size.width = newWidth
                    self.frame.size.height = newWidth
                    self.center = oldCenter
                    self.setNeedsLayout()
                    self.isResizing = false
                    self.resizeIfNeeded()
                })
            }
        }
    }
    
    private var lastHeightDifferential: CGFloat = CGFloat.greatestFiniteMagnitude
    
    private func verticallyCenter(){
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
