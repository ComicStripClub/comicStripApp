//
//  ThoughtBubble.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/27/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import CoreText

class ClassicSpeechBubbleElement: ComicFrameElement {
    var icon: UIImage = #imageLiteral(resourceName: "classicSpeechBubble")
    var type: ComicElementType = .dialogBubble
    lazy var view: UIView = ClassicSpeechBubble(nil)!
    lazy var effectFunc: (ComicFrame) -> Void = {(comicFrame) in
        comicFrame.addElement(self)
    }
}

@IBDesignable class ClassicSpeechBubble : UITextView, UITextViewDelegate {
    private let MINIMUM_WIDTH: CGFloat = 100
    
    private var sublayers: [CAShapeLayer] = []
    private var bubbleHeight: CGFloat = 0
    
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
        adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor.clear
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = false
        contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        clipsToBounds = false
    }
    
    // Draws the thought bubble outline/fill in the background of the UITextView,
    // and sets the exclusionPaths so that text flows within the boundaries of 
    // the thought bubble
    override func layoutSubviews() {
        super.layoutSubviews()
        let (shapes, bubbleHeight) = createShapes(width: bounds.width)
        self.bubbleHeight = bubbleHeight
        for existingLayer in sublayers {
            existingLayer.removeFromSuperlayer()
        }
        
        for (i, shape) in shapes.enumerated() {
            layer.insertSublayer(shape, at: UInt32(i))
            sublayers.append(shape)
        }
        verticallyCenter()
    }
    
    // Only count touches which are inside the dialog bubble
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for layer in sublayers {
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
            let aspectRatio = self.frame.size.width / self.frame.size.height
            let oldTransform = self.transform
            let newInset = max(self.contentInset.left * widthScale, 8)
            UIView.animate(withDuration: 0.15, delay: 0, animations: {
                self.transform = self.transform.scaledBy(x: widthScale, y: widthScale)
            }, completion: { (b) in
                self.transform = oldTransform
                self.frame.size.width = newWidth
                self.frame.size.height = newWidth / aspectRatio
                self.center = oldCenter
                self.setNeedsLayout()
                self.isResizing = false
                self.resizeIfNeeded()
            })
        }
        
    }

    private func verticallyCenter(){
        let sizeOfText = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        var topCorrection = (bubbleHeight - sizeOfText.height * zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        textContainer.exclusionPaths = [
            UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: topCorrection))),
            UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: 8, height: bounds.height))),
            UIBezierPath(rect: CGRect(x: bounds.width - 8, y: 0, width: 8, height: bounds.height)),
            getExclusionPath()
        ]
        if (bounds.height > bounds.width) {
            textContainer.exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: bounds.width, width: bounds.width, height: bounds.height - bounds.width)))
        }
    }

    private func getExclusionPath() -> UIBezierPath {
        let lineHeight = font?.lineHeight ?? 0
        return UIBezierPath(rect: CGRect(x: 8, y: bubbleHeight - lineHeight / 2, width: bounds.width, height: bounds.height - bubbleHeight))
    }
    
    private func createShapes(width: CGFloat) -> (shapes:[CAShapeLayer], bubbleHeight: CGFloat) {
        
        //// Color Declarations
        let whiteColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let blackColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// Group 2
        //// Bezier Drawing
        let whiteBackgroundShape = CAShapeLayer()
        let bezierPath = UIBezierPath()
        let bottomOfBubble = (width * 0.4903)
        bezierPath.move(to: CGPoint(x: (width * 0.1843), y: (width * 0.4903)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1487), y: (width * 0.7223)), controlPoint1: CGPoint(x: (width * 0.1632), y: (width * 0.5516)), controlPoint2: CGPoint(x: (width * 0.1514), y: (width * 0.6475)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3280), y: (width * 0.4903)), controlPoint1: CGPoint(x: (width * 0.1917), y: (width * 0.6424)), controlPoint2: CGPoint(x: (width * 0.2759), y: (width * 0.5256)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.9968), y: (width * 0.4903)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.9968), y: (width * 0.0075)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.0075)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.4903)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.1843), y: (width * 0.4903)))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        whiteBackgroundShape.path = bezierPath.cgPath
        whiteBackgroundShape.fillColor = whiteColor.cgColor
        whiteBackgroundShape.fillRule = kCAFillRuleEvenOdd
        
        
        //// Bezier 2 Drawing
        let speechBubbleBorderShape = CAShapeLayer()
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: (width * 0.9734), y: (width * 0.4535)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.3570), y: (width * 0.4535)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.3183), y: (width * 0.4549)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1802), y: (width * 0.6034)), controlPoint1: CGPoint(x: (width * 0.2673), y: (width * 0.4924)), controlPoint2: CGPoint(x: (width * 0.2244), y: (width * 0.5406)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2130), y: (width * 0.4547)), controlPoint1: CGPoint(x: (width * 0.1855), y: (width * 0.5639)), controlPoint2: CGPoint(x: (width * 0.1953), y: (width * 0.5109)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.2015), y: (width * 0.4535)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.0275), y: (width * 0.4535)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.0275), y: (width * 0.0270)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.9734), y: (width * 0.0270)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.9734), y: (width * 0.4535)))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: (width * 0.0005), y: -0))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.0005), y: (width * 0.4835)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.1843), y: (width * 0.4835)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1487), y: (width * 0.7154)), controlPoint1: CGPoint(x: (width * 0.1632), y: (width * 0.5465)), controlPoint2: CGPoint(x: (width * 0.1514), y: (width * 0.6407)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3280), y: (width * 0.4835)), controlPoint1: CGPoint(x: (width * 0.1917), y: (width * 0.6356)), controlPoint2: CGPoint(x: (width * 0.2759), y: (width * 0.5255)))
        bezier2Path.addLine(to: CGPoint(x: (width * 1.0005), y: (width * 0.4835)))
        bezier2Path.addLine(to: CGPoint(x: (width * 1.0005), y: -0))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.0005), y: -0))
        bezier2Path.close()
        bezier2Path.usesEvenOddFillRule = true
        speechBubbleBorderShape.path = bezier2Path.cgPath
        speechBubbleBorderShape.fillColor = blackColor.cgColor
        return (shapes: [whiteBackgroundShape, speechBubbleBorderShape], bubbleHeight: bottomOfBubble)
    }

}
