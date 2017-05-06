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

@IBDesignable class ClassicSpeechBubble : BaseDialogBubble {
    override init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    
    override func getExclusionPath(width: CGFloat) -> UIBezierPath {
        let lineHeight = font?.lineHeight ?? 0
        let bubbleBottom = mainBubbleLayer.path!.boundingBox.maxY
        let exclusionPathY = bubbleBottom - lineHeight / 2;
        return UIBezierPath(rect: CGRect(x: 0, y: exclusionPathY, width: bounds.width, height: bounds.height - exclusionPathY))
    }
    
    override func drawBackgroundShapes(width: CGFloat) -> (shapes: [CAShapeLayer], mainBubble: CAShapeLayer) {
        //// Color Declarations
        let whiteColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let blackColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// Group 2
        //// Bezier Drawing
        let whiteBackgroundShape = CAShapeLayer()
        let bezierPath = UIBezierPath()
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

        let mainBubble = CAShapeLayer()
        let mainBubblePath = UIBezierPath()
        mainBubblePath.move(to: CGPoint(x: (width * 0.0000), y: (width * 0.4903)))
        mainBubblePath.addLine(to: CGPoint(x: (width * 0.9968), y: (width * 0.4903)))
        mainBubblePath.addLine(to: CGPoint(x: (width * 0.9968), y: (width * 0.0075)))
        mainBubblePath.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.0075)))
        mainBubblePath.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.4903)))
        mainBubblePath.close()
        mainBubble.path = mainBubblePath.cgPath
        mainBubble.fillColor = UIColor.clear.cgColor
        mainBubble.fillRule = kCAFillRuleEvenOdd
        
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
        return (shapes: [whiteBackgroundShape, mainBubble, speechBubbleBorderShape], mainBubble: mainBubble)
    }

}
