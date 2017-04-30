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

//class ComicBubbleLayoutManager: NSLayoutManager {
//    
//}
//
//class ComicBubbleTextContainer: NSTextContainer {
//    override var isSimpleRectangularTextContainer: Bool {
//        get { return false }
//    }
//    
//    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
//        let rect = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
//        return rect
//    }
//}

class ThoughtBubbleElement: ComicFrameElement {
    var icon: UIImage = #imageLiteral(resourceName: "thoughtBubble1")
    var type: ComicElementType = .dialogBubble
    lazy var view: UIView = ThoughtBubble(nil)!
    lazy var effectFunc: (ComicFrame) -> Void = {(comicFrame) in
        comicFrame.addElement(self, size: CGSize(width: comicFrame.bounds.width / 3, height: comicFrame.bounds.height / 3))
    }
}

@IBDesignable class ThoughtBubble : UITextView, UITextViewDelegate {
    
    private var sublayers: [CAShapeLayer] = []
    private var cloudLayer: CAShapeLayer!
    
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
        
        let layoutManager = NSLayoutManager()
        let customTextContainer = ComicBubbleTextContainer(size: CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        customTextContainer.widthTracksTextView = true
        layoutManager.addTextContainer(customTextContainer)
        textStorage.addLayoutManager(layoutManager)
        delegate = self
        font = UIFont(name: "BackIssuesBB-Italic", size: 18.0)
        textAlignment = .center
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor.clear
        textContainer.lineBreakMode = .byWordWrapping

    }
    
    // Draws the thought bubble outline/fill in the background of the UITextView,
    // and sets the exclusionPaths so that text flows within the boundaries of 
    // the thought bubble
    override func layoutSubviews() {
        super.layoutSubviews()
        let shapes = createShapes(width: bounds.width)
        
        for existingLayer in sublayers {
            existingLayer.removeFromSuperlayer()
        }
        
        for (i, shape) in shapes.enumerated() {
            layer.insertSublayer(shape, at: UInt32(i))
            sublayers.append(shape)
        }
        textContainer.exclusionPaths = [ThoughtBubble.getExclusionPath(width: bounds.width)]
    }
    
    func textViewDidChange(_ textView: UITextView) {
        verticallyCenter()
    }
    
    func verticallyCenter(){
        let sizeOfText = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let cloudHeight = cloudLayer.path!.boundingBox.height
        var topCorrection = (cloudHeight - sizeOfText.height * zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        textContainer.exclusionPaths = [
            UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: topCorrection))),
            ThoughtBubble.getExclusionPath(width: bounds.width)
        ]
    }

    private class func getExclusionPath(width: CGFloat) -> UIBezierPath {
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: (width * 0.9969), y: (width * 0.2630)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 1.0006), y: (width * 0.3183)), controlPoint1: CGPoint(x: (width * 1.0016), y: (width * 0.2800)), controlPoint2: CGPoint(x: (width * 1.0035), y: (width * 0.2989)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8975), y: (width * 0.3447)), controlPoint1: CGPoint(x: (width * 0.9980), y: (width * 0.3376)), controlPoint2: CGPoint(x: (width * 0.8976), y: (width * 0.3507)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9141), y: (width * 0.4034)), controlPoint1: CGPoint(x: (width * 0.8974), y: (width * 0.3417)), controlPoint2: CGPoint(x: (width * 0.9144), y: (width * 0.4007)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9112), y: (width * 0.4196)), controlPoint1: CGPoint(x: (width * 0.9133), y: (width * 0.4086)), controlPoint2: CGPoint(x: (width * 0.9127), y: (width * 0.4140)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8994), y: (width * 0.4538)), controlPoint1: CGPoint(x: (width * 0.9087), y: (width * 0.4306)), controlPoint2: CGPoint(x: (width * 0.9049), y: (width * 0.4423)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8790), y: (width * 0.4874)), controlPoint1: CGPoint(x: (width * 0.8940), y: (width * 0.4653)), controlPoint2: CGPoint(x: (width * 0.8872), y: (width * 0.4770)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8486), y: (width * 0.5153)), controlPoint1: CGPoint(x: (width * 0.8708), y: (width * 0.4977)), controlPoint2: CGPoint(x: (width * 0.8604), y: (width * 0.5070)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.7729), y: (width * 0.5488)), controlPoint1: CGPoint(x: (width * 0.8248), y: (width * 0.5317)), controlPoint2: CGPoint(x: (width * 0.7980), y: (width * 0.5424)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.7364), y: (width * 0.5556)), controlPoint1: CGPoint(x: (width * 0.7602), y: (width * 0.5519)), controlPoint2: CGPoint(x: (width * 0.7480), y: (width * 0.5542)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.7044), y: (width * 0.5570)), controlPoint1: CGPoint(x: (width * 0.7248), y: (width * 0.5568)), controlPoint2: CGPoint(x: (width * 0.7138), y: (width * 0.5577)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6787), y: (width * 0.5515)), controlPoint1: CGPoint(x: (width * 0.6948), y: (width * 0.5561)), controlPoint2: CGPoint(x: (width * 0.6861), y: (width * 0.5540)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6686), y: (width * 0.5470)), controlPoint1: CGPoint(x: (width * 0.6751), y: (width * 0.5500)), controlPoint2: CGPoint(x: (width * 0.6716), y: (width * 0.5486)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6650), y: (width * 0.5451)), controlPoint1: CGPoint(x: (width * 0.6674), y: (width * 0.5463)), controlPoint2: CGPoint(x: (width * 0.6662), y: (width * 0.5457)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6630), y: (width * 0.5114)), controlPoint1: CGPoint(x: (width * 0.6661), y: (width * 0.5332)), controlPoint2: CGPoint(x: (width * 0.6652), y: (width * 0.5218)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6118), y: (width * 0.4348)), controlPoint1: CGPoint(x: (width * 0.6585), y: (width * 0.4897)), controlPoint2: CGPoint(x: (width * 0.6066), y: (width * 0.4210)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6385), y: (width * 0.5148)), controlPoint1: CGPoint(x: (width * 0.6170), y: (width * 0.4485)), controlPoint2: CGPoint(x: (width * 0.6373), y: (width * 0.4965)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6275), y: (width * 0.5695)), controlPoint1: CGPoint(x: (width * 0.6397), y: (width * 0.5331)), controlPoint2: CGPoint(x: (width * 0.6373), y: (width * 0.5530)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5855), y: (width * 0.6047)), controlPoint1: CGPoint(x: (width * 0.6183), y: (width * 0.5862)), controlPoint2: CGPoint(x: (width * 0.6023), y: (width * 0.5974)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5728), y: (width * 0.6094)), controlPoint1: CGPoint(x: (width * 0.5813), y: (width * 0.6064)), controlPoint2: CGPoint(x: (width * 0.5771), y: (width * 0.6081)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5665), y: (width * 0.6115)), controlPoint1: CGPoint(x: (width * 0.5707), y: (width * 0.6101)), controlPoint2: CGPoint(x: (width * 0.5686), y: (width * 0.6108)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5604), y: (width * 0.6130)), controlPoint1: CGPoint(x: (width * 0.5644), y: (width * 0.6120)), controlPoint2: CGPoint(x: (width * 0.5624), y: (width * 0.6125)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5544), y: (width * 0.6143)), controlPoint1: CGPoint(x: (width * 0.5584), y: (width * 0.6134)), controlPoint2: CGPoint(x: (width * 0.5564), y: (width * 0.6141)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5487), y: (width * 0.6152)), controlPoint1: CGPoint(x: (width * 0.5525), y: (width * 0.6146)), controlPoint2: CGPoint(x: (width * 0.5506), y: (width * 0.6149)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5378), y: (width * 0.6159)), controlPoint1: CGPoint(x: (width * 0.5449), y: (width * 0.6160)), controlPoint2: CGPoint(x: (width * 0.5413), y: (width * 0.6157)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5047), y: (width * 0.6081)), controlPoint1: CGPoint(x: (width * 0.5238), y: (width * 0.6158)), controlPoint2: CGPoint(x: (width * 0.5125), y: (width * 0.6114)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5003), y: (width * 0.6058)), controlPoint1: CGPoint(x: (width * 0.5030), y: (width * 0.6073)), controlPoint2: CGPoint(x: (width * 0.5016), y: (width * 0.6065)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5056), y: (width * 0.5873)), controlPoint1: CGPoint(x: (width * 0.5028), y: (width * 0.5995)), controlPoint2: CGPoint(x: (width * 0.5045), y: (width * 0.5933)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.4916), y: (width * 0.5832)), controlPoint1: CGPoint(x: (width * 0.5000), y: (width * 0.5186)), controlPoint2: CGPoint(x: (width * 0.4970), y: (width * 0.5707)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.3693), y: (width * 0.5948)), controlPoint1: CGPoint(x: (width * 0.4858), y: (width * 0.5956)), controlPoint2: CGPoint(x: (width * 0.3720), y: (width * 0.5927)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1398), y: (width * 0.5963)), controlPoint1: CGPoint(x: (width * 0.3665), y: (width * 0.5970)), controlPoint2: CGPoint(x: (width * 0.1398), y: (width * 0.5963)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1063), y: (width * 0.5253)), controlPoint1: CGPoint(x: (width * 0.1152), y: (width * 0.5740)), controlPoint2: CGPoint(x: (width * 0.1096), y: (width * 0.5530)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1055), y: (width * 0.5150)), controlPoint1: CGPoint(x: (width * 0.1061), y: (width * 0.5218)), controlPoint2: CGPoint(x: (width * 0.1054), y: (width * 0.5184)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1058), y: (width * 0.5048)), controlPoint1: CGPoint(x: (width * 0.1056), y: (width * 0.5116)), controlPoint2: CGPoint(x: (width * 0.1057), y: (width * 0.5082)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1072), y: (width * 0.4951)), controlPoint1: CGPoint(x: (width * 0.1060), y: (width * 0.5015)), controlPoint2: CGPoint(x: (width * 0.1068), y: (width * 0.4983)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1080), y: (width * 0.4902)), controlPoint1: CGPoint(x: (width * 0.1075), y: (width * 0.4934)), controlPoint2: CGPoint(x: (width * 0.1076), y: (width * 0.4918)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1093), y: (width * 0.4853)), controlPoint1: CGPoint(x: (width * 0.1084), y: (width * 0.4886)), controlPoint2: CGPoint(x: (width * 0.1089), y: (width * 0.4870)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1398), y: (width * 0.4037)), controlPoint1: CGPoint(x: (width * 0.1124), y: (width * 0.4723)), controlPoint2: CGPoint(x: (width * 0.1355), y: (width * 0.4144)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0460), y: (width * 0.4008)), controlPoint1: CGPoint(x: (width * 0.1395), y: (width * 0.4042)), controlPoint2: CGPoint(x: (width * 0.0466), y: (width * 0.4006)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0298), y: (width * 0.3455)), controlPoint1: CGPoint(x: (width * 0.0382), y: (width * 0.3845)), controlPoint2: CGPoint(x: (width * 0.0319), y: (width * 0.3653)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0348), y: (width * 0.2886)), controlPoint1: CGPoint(x: (width * 0.0278), y: (width * 0.3255)), controlPoint2: CGPoint(x: (width * 0.0300), y: (width * 0.3056)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0858), y: (width * 0.2579)), controlPoint1: CGPoint(x: (width * 0.0399), y: (width * 0.2717)), controlPoint2: CGPoint(x: (width * 0.0853), y: (width * 0.2553)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0867), y: (width * 0.2618)), controlPoint1: CGPoint(x: (width * 0.0864), y: (width * 0.2605)), controlPoint2: CGPoint(x: (width * 0.0867), y: (width * 0.2618)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0871), y: (width * 0.2579)), controlPoint1: CGPoint(x: (width * 0.0867), y: (width * 0.2618)), controlPoint2: CGPoint(x: (width * 0.0868), y: (width * 0.2605)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0884), y: (width * 0.2465)), controlPoint1: CGPoint(x: (width * 0.0874), y: (width * 0.2552)), controlPoint2: CGPoint(x: (width * 0.0876), y: (width * 0.2514)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0936), y: (width * 0.2195)), controlPoint1: CGPoint(x: (width * 0.0893), y: (width * 0.2395)), controlPoint2: CGPoint(x: (width * 0.0908), y: (width * 0.2302)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0938), y: (width * 0.2193)), controlPoint1: CGPoint(x: (width * 0.0937), y: (width * 0.2194)), controlPoint2: CGPoint(x: (width * 0.0938), y: (width * 0.2193)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0936), y: (width * 0.2194)), controlPoint1: CGPoint(x: (width * 0.0938), y: (width * 0.2193)), controlPoint2: CGPoint(x: (width * 0.0937), y: (width * 0.2194)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0974), y: (width * 0.2066)), controlPoint1: CGPoint(x: (width * 0.0947), y: (width * 0.2153)), controlPoint2: CGPoint(x: (width * 0.0959), y: (width * 0.2110)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1239), y: (width * 0.1546)), controlPoint1: CGPoint(x: (width * 0.1026), y: (width * 0.1903)), controlPoint2: CGPoint(x: (width * 0.1111), y: (width * 0.1720)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.2702), y: (width * 0.1677)), controlPoint1: CGPoint(x: (width * 0.1242), y: (width * 0.1553)), controlPoint2: CGPoint(x: (width * 0.2702), y: (width * 0.1677)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.3012), y: (width * 0.1118)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.8665), y: (width * 0.1149)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8973), y: (width * 0.1352)), controlPoint1: CGPoint(x: (width * 0.8770), y: (width * 0.1209)), controlPoint2: CGPoint(x: (width * 0.8882), y: (width * 0.1278)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9101), y: (width * 0.1468)), controlPoint1: CGPoint(x: (width * 0.9017), y: (width * 0.1390)), controlPoint2: CGPoint(x: (width * 0.9061), y: (width * 0.1428)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.9131), y: (width * 0.1497)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9158), y: (width * 0.1525)), controlPoint1: CGPoint(x: (width * 0.9141), y: (width * 0.1507)), controlPoint2: CGPoint(x: (width * 0.9149), y: (width * 0.1516)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9208), y: (width * 0.1584)), controlPoint1: CGPoint(x: (width * 0.9175), y: (width * 0.1543)), controlPoint2: CGPoint(x: (width * 0.9192), y: (width * 0.1564)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9969), y: (width * 0.2630)), controlPoint1: CGPoint(x: (width * 0.9338), y: (width * 0.1751)), controlPoint2: CGPoint(x: (width * 0.9923), y: (width * 0.2459)))
        bezier3Path.close()
        bezier3Path.move(to: CGPoint(x: (width * 1.0311), y: (width * 0.0031)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.6273), y: (width * 0.0031)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.0031)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0007), y: (width * 0.3484)), controlPoint1: CGPoint(x: (width * 0.0000), y: (width * 0.0031)), controlPoint2: CGPoint(x: (width * 0.0000), y: (width * 0.3478)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0000), y: (width * 0.9969)), controlPoint1: CGPoint(x: (width * 0.0000), y: (width * 0.3478)), controlPoint2: CGPoint(x: (width * 0.0000), y: (width * 0.9969)))
        bezier3Path.addLine(to: CGPoint(x: (width * 1.0311), y: (width * 0.9969)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 1.0296), y: (width * 0.3226)), controlPoint1: CGPoint(x: (width * 1.0311), y: (width * 0.9969)), controlPoint2: CGPoint(x: (width * 1.0280), y: (width * 0.3349)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 1.0311), y: (width * 0.0031)), controlPoint1: CGPoint(x: (width * 1.0334), y: (width * 0.2979)), controlPoint2: CGPoint(x: (width * 1.0311), y: (width * 0.0031)))
        bezier3Path.close()
        return bezier3Path
    }
    
    private func createShapes(width: CGFloat) -> [CAShapeLayer] {
        
        //// Color Declarations
        let whiteColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let blackColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// Bezier 2 Drawing
        let shape2 = CAShapeLayer()
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: (width * 0.9969), y: (width * 0.2630)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 1.0006), y: (width * 0.3183)), controlPoint1: CGPoint(x: (width * 1.0016), y: (width * 0.2800)), controlPoint2: CGPoint(x: (width * 1.0035), y: (width * 0.2989)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9812), y: (width * 0.3708)), controlPoint1: CGPoint(x: (width * 0.9980), y: (width * 0.3376)), controlPoint2: CGPoint(x: (width * 0.9903), y: (width * 0.3552)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9528), y: (width * 0.4111)), controlPoint1: CGPoint(x: (width * 0.9721), y: (width * 0.3864)), controlPoint2: CGPoint(x: (width * 0.9618), y: (width * 0.3999)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9303), y: (width * 0.4371)), controlPoint1: CGPoint(x: (width * 0.9437), y: (width * 0.4222)), controlPoint2: CGPoint(x: (width * 0.9358), y: (width * 0.4310)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9288), y: (width * 0.4389)), controlPoint1: CGPoint(x: (width * 0.9298), y: (width * 0.4378)), controlPoint2: CGPoint(x: (width * 0.9293), y: (width * 0.4384)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9311), y: (width * 0.4226)), controlPoint1: CGPoint(x: (width * 0.9298), y: (width * 0.4334)), controlPoint2: CGPoint(x: (width * 0.9306), y: (width * 0.4279)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9315), y: (width * 0.4038)), controlPoint1: CGPoint(x: (width * 0.9318), y: (width * 0.4161)), controlPoint2: CGPoint(x: (width * 0.9316), y: (width * 0.4098)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9306), y: (width * 0.3949)), controlPoint1: CGPoint(x: (width * 0.9314), y: (width * 0.4008)), controlPoint2: CGPoint(x: (width * 0.9309), y: (width * 0.3978)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9293), y: (width * 0.3866)), controlPoint1: CGPoint(x: (width * 0.9303), y: (width * 0.3920)), controlPoint2: CGPoint(x: (width * 0.9300), y: (width * 0.3893)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9275), y: (width * 0.3787)), controlPoint1: CGPoint(x: (width * 0.9287), y: (width * 0.3839)), controlPoint2: CGPoint(x: (width * 0.9280), y: (width * 0.3812)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9249), y: (width * 0.3714)), controlPoint1: CGPoint(x: (width * 0.9267), y: (width * 0.3761)), controlPoint2: CGPoint(x: (width * 0.9257), y: (width * 0.3737)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9190), y: (width * 0.3587)), controlPoint1: CGPoint(x: (width * 0.9235), y: (width * 0.3666)), controlPoint2: CGPoint(x: (width * 0.9211), y: (width * 0.3625)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9175), y: (width * 0.3559)), controlPoint1: CGPoint(x: (width * 0.9185), y: (width * 0.3577)), controlPoint2: CGPoint(x: (width * 0.9180), y: (width * 0.3568)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9157), y: (width * 0.3534)), controlPoint1: CGPoint(x: (width * 0.9170), y: (width * 0.3550)), controlPoint2: CGPoint(x: (width * 0.9163), y: (width * 0.3542)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9123), y: (width * 0.3487)), controlPoint1: CGPoint(x: (width * 0.9146), y: (width * 0.3517)), controlPoint2: CGPoint(x: (width * 0.9134), y: (width * 0.3502)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9056), y: (width * 0.3413)), controlPoint1: CGPoint(x: (width * 0.9103), y: (width * 0.3456)), controlPoint2: CGPoint(x: (width * 0.9076), y: (width * 0.3434)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8949), y: (width * 0.3328)), controlPoint1: CGPoint(x: (width * 0.9015), y: (width * 0.3369)), controlPoint2: CGPoint(x: (width * 0.8974), y: (width * 0.3346)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8911), y: (width * 0.3302)), controlPoint1: CGPoint(x: (width * 0.8924), y: (width * 0.3311)), controlPoint2: CGPoint(x: (width * 0.8911), y: (width * 0.3302)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8941), y: (width * 0.3337)), controlPoint1: CGPoint(x: (width * 0.8911), y: (width * 0.3302)), controlPoint2: CGPoint(x: (width * 0.8921), y: (width * 0.3314)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9020), y: (width * 0.3442)), controlPoint1: CGPoint(x: (width * 0.8960), y: (width * 0.3361)), controlPoint2: CGPoint(x: (width * 0.8992), y: (width * 0.3392)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9147), y: (width * 0.3883)), controlPoint1: CGPoint(x: (width * 0.9082), y: (width * 0.3536)), controlPoint2: CGPoint(x: (width * 0.9143), y: (width * 0.3689)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9146), y: (width * 0.3957)), controlPoint1: CGPoint(x: (width * 0.9149), y: (width * 0.3907)), controlPoint2: CGPoint(x: (width * 0.9148), y: (width * 0.3931)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9141), y: (width * 0.4034)), controlPoint1: CGPoint(x: (width * 0.9144), y: (width * 0.3982)), controlPoint2: CGPoint(x: (width * 0.9144), y: (width * 0.4007)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9112), y: (width * 0.4196)), controlPoint1: CGPoint(x: (width * 0.9133), y: (width * 0.4086)), controlPoint2: CGPoint(x: (width * 0.9127), y: (width * 0.4140)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8994), y: (width * 0.4538)), controlPoint1: CGPoint(x: (width * 0.9087), y: (width * 0.4306)), controlPoint2: CGPoint(x: (width * 0.9049), y: (width * 0.4423)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8790), y: (width * 0.4874)), controlPoint1: CGPoint(x: (width * 0.8940), y: (width * 0.4653)), controlPoint2: CGPoint(x: (width * 0.8872), y: (width * 0.4770)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8486), y: (width * 0.5153)), controlPoint1: CGPoint(x: (width * 0.8708), y: (width * 0.4977)), controlPoint2: CGPoint(x: (width * 0.8604), y: (width * 0.5070)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7729), y: (width * 0.5488)), controlPoint1: CGPoint(x: (width * 0.8248), y: (width * 0.5317)), controlPoint2: CGPoint(x: (width * 0.7980), y: (width * 0.5424)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7364), y: (width * 0.5556)), controlPoint1: CGPoint(x: (width * 0.7602), y: (width * 0.5519)), controlPoint2: CGPoint(x: (width * 0.7480), y: (width * 0.5542)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7044), y: (width * 0.5570)), controlPoint1: CGPoint(x: (width * 0.7248), y: (width * 0.5568)), controlPoint2: CGPoint(x: (width * 0.7138), y: (width * 0.5577)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6787), y: (width * 0.5515)), controlPoint1: CGPoint(x: (width * 0.6948), y: (width * 0.5561)), controlPoint2: CGPoint(x: (width * 0.6861), y: (width * 0.5540)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6686), y: (width * 0.5470)), controlPoint1: CGPoint(x: (width * 0.6751), y: (width * 0.5500)), controlPoint2: CGPoint(x: (width * 0.6716), y: (width * 0.5486)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6650), y: (width * 0.5451)), controlPoint1: CGPoint(x: (width * 0.6674), y: (width * 0.5463)), controlPoint2: CGPoint(x: (width * 0.6662), y: (width * 0.5457)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6630), y: (width * 0.5114)), controlPoint1: CGPoint(x: (width * 0.6661), y: (width * 0.5332)), controlPoint2: CGPoint(x: (width * 0.6652), y: (width * 0.5218)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6404), y: (width * 0.4590)), controlPoint1: CGPoint(x: (width * 0.6585), y: (width * 0.4897)), controlPoint2: CGPoint(x: (width * 0.6495), y: (width * 0.4722)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6154), y: (width * 0.4311)), controlPoint1: CGPoint(x: (width * 0.6313), y: (width * 0.4457)), controlPoint2: CGPoint(x: (width * 0.6220), y: (width * 0.4368)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6075), y: (width * 0.4248)), controlPoint1: CGPoint(x: (width * 0.6121), y: (width * 0.4282)), controlPoint2: CGPoint(x: (width * 0.6094), y: (width * 0.4261)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6047), y: (width * 0.4228)), controlPoint1: CGPoint(x: (width * 0.6057), y: (width * 0.4235)), controlPoint2: CGPoint(x: (width * 0.6047), y: (width * 0.4228)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6066), y: (width * 0.4257)), controlPoint1: CGPoint(x: (width * 0.6047), y: (width * 0.4228)), controlPoint2: CGPoint(x: (width * 0.6053), y: (width * 0.4238)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6119), y: (width * 0.4340)), controlPoint1: CGPoint(x: (width * 0.6079), y: (width * 0.4275)), controlPoint2: CGPoint(x: (width * 0.6097), y: (width * 0.4303)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6275), y: (width * 0.4659)), controlPoint1: CGPoint(x: (width * 0.6163), y: (width * 0.4413)), controlPoint2: CGPoint(x: (width * 0.6223), y: (width * 0.4520)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6385), y: (width * 0.5148)), controlPoint1: CGPoint(x: (width * 0.6327), y: (width * 0.4796)), controlPoint2: CGPoint(x: (width * 0.6373), y: (width * 0.4965)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6275), y: (width * 0.5695)), controlPoint1: CGPoint(x: (width * 0.6397), y: (width * 0.5331)), controlPoint2: CGPoint(x: (width * 0.6373), y: (width * 0.5530)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5855), y: (width * 0.6047)), controlPoint1: CGPoint(x: (width * 0.6183), y: (width * 0.5862)), controlPoint2: CGPoint(x: (width * 0.6023), y: (width * 0.5974)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5728), y: (width * 0.6094)), controlPoint1: CGPoint(x: (width * 0.5813), y: (width * 0.6064)), controlPoint2: CGPoint(x: (width * 0.5771), y: (width * 0.6081)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5665), y: (width * 0.6115)), controlPoint1: CGPoint(x: (width * 0.5707), y: (width * 0.6101)), controlPoint2: CGPoint(x: (width * 0.5686), y: (width * 0.6108)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5604), y: (width * 0.6130)), controlPoint1: CGPoint(x: (width * 0.5644), y: (width * 0.6120)), controlPoint2: CGPoint(x: (width * 0.5624), y: (width * 0.6125)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5544), y: (width * 0.6143)), controlPoint1: CGPoint(x: (width * 0.5584), y: (width * 0.6134)), controlPoint2: CGPoint(x: (width * 0.5564), y: (width * 0.6141)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5487), y: (width * 0.6152)), controlPoint1: CGPoint(x: (width * 0.5525), y: (width * 0.6146)), controlPoint2: CGPoint(x: (width * 0.5506), y: (width * 0.6149)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5378), y: (width * 0.6159)), controlPoint1: CGPoint(x: (width * 0.5449), y: (width * 0.6160)), controlPoint2: CGPoint(x: (width * 0.5413), y: (width * 0.6157)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5047), y: (width * 0.6081)), controlPoint1: CGPoint(x: (width * 0.5238), y: (width * 0.6158)), controlPoint2: CGPoint(x: (width * 0.5125), y: (width * 0.6114)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5003), y: (width * 0.6058)), controlPoint1: CGPoint(x: (width * 0.5030), y: (width * 0.6073)), controlPoint2: CGPoint(x: (width * 0.5016), y: (width * 0.6065)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5056), y: (width * 0.5873)), controlPoint1: CGPoint(x: (width * 0.5028), y: (width * 0.5995)), controlPoint2: CGPoint(x: (width * 0.5045), y: (width * 0.5933)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5027), y: (width * 0.5502)), controlPoint1: CGPoint(x: (width * 0.5083), y: (width * 0.5713)), controlPoint2: CGPoint(x: (width * 0.5060), y: (width * 0.5582)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5017), y: (width * 0.5473)), controlPoint1: CGPoint(x: (width * 0.5023), y: (width * 0.5492)), controlPoint2: CGPoint(x: (width * 0.5020), y: (width * 0.5482)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5004), y: (width * 0.5449)), controlPoint1: CGPoint(x: (width * 0.5012), y: (width * 0.5465)), controlPoint2: CGPoint(x: (width * 0.5008), y: (width * 0.5457)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4985), y: (width * 0.5412)), controlPoint1: CGPoint(x: (width * 0.4997), y: (width * 0.5435)), controlPoint2: CGPoint(x: (width * 0.4990), y: (width * 0.5422)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4968), y: (width * 0.5383)), controlPoint1: CGPoint(x: (width * 0.4974), y: (width * 0.5393)), controlPoint2: CGPoint(x: (width * 0.4968), y: (width * 0.5383)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4973), y: (width * 0.5417)), controlPoint1: CGPoint(x: (width * 0.4968), y: (width * 0.5383)), controlPoint2: CGPoint(x: (width * 0.4970), y: (width * 0.5394)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4978), y: (width * 0.5457)), controlPoint1: CGPoint(x: (width * 0.4974), y: (width * 0.5427)), controlPoint2: CGPoint(x: (width * 0.4976), y: (width * 0.5441)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4982), y: (width * 0.5482)), controlPoint1: CGPoint(x: (width * 0.4980), y: (width * 0.5464)), controlPoint2: CGPoint(x: (width * 0.4980), y: (width * 0.5473)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4982), y: (width * 0.5511)), controlPoint1: CGPoint(x: (width * 0.4982), y: (width * 0.5491)), controlPoint2: CGPoint(x: (width * 0.4982), y: (width * 0.5500)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4916), y: (width * 0.5832)), controlPoint1: CGPoint(x: (width * 0.4987), y: (width * 0.5591)), controlPoint2: CGPoint(x: (width * 0.4970), y: (width * 0.5707)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4633), y: (width * 0.6216)), controlPoint1: CGPoint(x: (width * 0.4858), y: (width * 0.5956)), controlPoint2: CGPoint(x: (width * 0.4763), y: (width * 0.6091)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4416), y: (width * 0.6398)), controlPoint1: CGPoint(x: (width * 0.4569), y: (width * 0.6280)), controlPoint2: CGPoint(x: (width * 0.4494), y: (width * 0.6340)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4293), y: (width * 0.6480)), controlPoint1: CGPoint(x: (width * 0.4377), y: (width * 0.6427)), controlPoint2: CGPoint(x: (width * 0.4335), y: (width * 0.6454)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4228), y: (width * 0.6518)), controlPoint1: CGPoint(x: (width * 0.4271), y: (width * 0.6493)), controlPoint2: CGPoint(x: (width * 0.4250), y: (width * 0.6505)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4158), y: (width * 0.6553)), controlPoint1: CGPoint(x: (width * 0.4205), y: (width * 0.6530)), controlPoint2: CGPoint(x: (width * 0.4182), y: (width * 0.6542)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3606), y: (width * 0.6744)), controlPoint1: CGPoint(x: (width * 0.3972), y: (width * 0.6648)), controlPoint2: CGPoint(x: (width * 0.3784), y: (width * 0.6713)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3126), y: (width * 0.6750)), controlPoint1: CGPoint(x: (width * 0.3429), y: (width * 0.6778)), controlPoint2: CGPoint(x: (width * 0.3264), y: (width * 0.6773)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2801), y: (width * 0.6653)), controlPoint1: CGPoint(x: (width * 0.2987), y: (width * 0.6727)), controlPoint2: CGPoint(x: (width * 0.2876), y: (width * 0.6686)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2745), y: (width * 0.6627)), controlPoint1: CGPoint(x: (width * 0.2779), y: (width * 0.6644)), controlPoint2: CGPoint(x: (width * 0.2761), y: (width * 0.6635)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2786), y: (width * 0.6615)), controlPoint1: CGPoint(x: (width * 0.2759), y: (width * 0.6623)), controlPoint2: CGPoint(x: (width * 0.2773), y: (width * 0.6619)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3157), y: (width * 0.6443)), controlPoint1: CGPoint(x: (width * 0.2929), y: (width * 0.6570)), controlPoint2: CGPoint(x: (width * 0.3052), y: (width * 0.6507)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3599), y: (width * 0.6073)), controlPoint1: CGPoint(x: (width * 0.3367), y: (width * 0.6310)), controlPoint2: CGPoint(x: (width * 0.3507), y: (width * 0.6171)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3701), y: (width * 0.5957)), controlPoint1: CGPoint(x: (width * 0.3645), y: (width * 0.6024)), controlPoint2: CGPoint(x: (width * 0.3679), y: (width * 0.5984)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3735), y: (width * 0.5916)), controlPoint1: CGPoint(x: (width * 0.3724), y: (width * 0.5930)), controlPoint2: CGPoint(x: (width * 0.3735), y: (width * 0.5916)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3693), y: (width * 0.5948)), controlPoint1: CGPoint(x: (width * 0.3735), y: (width * 0.5916)), controlPoint2: CGPoint(x: (width * 0.3720), y: (width * 0.5927)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3569), y: (width * 0.6039)), controlPoint1: CGPoint(x: (width * 0.3665), y: (width * 0.5970)), controlPoint2: CGPoint(x: (width * 0.3623), y: (width * 0.6000)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3089), y: (width * 0.6313)), controlPoint1: CGPoint(x: (width * 0.3461), y: (width * 0.6115)), controlPoint2: CGPoint(x: (width * 0.3300), y: (width * 0.6221)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2329), y: (width * 0.6433)), controlPoint1: CGPoint(x: (width * 0.2879), y: (width * 0.6402)), controlPoint2: CGPoint(x: (width * 0.2613), y: (width * 0.6470)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1500), y: (width * 0.6038)), controlPoint1: CGPoint(x: (width * 0.2046), y: (width * 0.6397)), controlPoint2: CGPoint(x: (width * 0.1746), y: (width * 0.6261)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1063), y: (width * 0.5253)), controlPoint1: CGPoint(x: (width * 0.1254), y: (width * 0.5816)), controlPoint2: CGPoint(x: (width * 0.1096), y: (width * 0.5530)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1055), y: (width * 0.5150)), controlPoint1: CGPoint(x: (width * 0.1061), y: (width * 0.5218)), controlPoint2: CGPoint(x: (width * 0.1054), y: (width * 0.5184)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1058), y: (width * 0.5048)), controlPoint1: CGPoint(x: (width * 0.1056), y: (width * 0.5116)), controlPoint2: CGPoint(x: (width * 0.1057), y: (width * 0.5082)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1072), y: (width * 0.4951)), controlPoint1: CGPoint(x: (width * 0.1060), y: (width * 0.5015)), controlPoint2: CGPoint(x: (width * 0.1068), y: (width * 0.4983)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1080), y: (width * 0.4902)), controlPoint1: CGPoint(x: (width * 0.1075), y: (width * 0.4934)), controlPoint2: CGPoint(x: (width * 0.1076), y: (width * 0.4918)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1093), y: (width * 0.4853)), controlPoint1: CGPoint(x: (width * 0.1084), y: (width * 0.4886)), controlPoint2: CGPoint(x: (width * 0.1089), y: (width * 0.4870)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1213), y: (width * 0.4498)), controlPoint1: CGPoint(x: (width * 0.1124), y: (width * 0.4723)), controlPoint2: CGPoint(x: (width * 0.1170), y: (width * 0.4606)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1491), y: (width * 0.4024)), controlPoint1: CGPoint(x: (width * 0.1305), y: (width * 0.4286)), controlPoint2: CGPoint(x: (width * 0.1409), y: (width * 0.4126)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1590), y: (width * 0.3907)), controlPoint1: CGPoint(x: (width * 0.1530), y: (width * 0.3969)), controlPoint2: CGPoint(x: (width * 0.1567), y: (width * 0.3934)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1626), y: (width * 0.3867)), controlPoint1: CGPoint(x: (width * 0.1613), y: (width * 0.3881)), controlPoint2: CGPoint(x: (width * 0.1626), y: (width * 0.3867)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1582), y: (width * 0.3898)), controlPoint1: CGPoint(x: (width * 0.1626), y: (width * 0.3867)), controlPoint2: CGPoint(x: (width * 0.1611), y: (width * 0.3878)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1458), y: (width * 0.3992)), controlPoint1: CGPoint(x: (width * 0.1553), y: (width * 0.3919)), controlPoint2: CGPoint(x: (width * 0.1508), y: (width * 0.3946)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1084), y: (width * 0.4430)), controlPoint1: CGPoint(x: (width * 0.1354), y: (width * 0.4078)), controlPoint2: CGPoint(x: (width * 0.1215), y: (width * 0.4221)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0994), y: (width * 0.4589)), controlPoint1: CGPoint(x: (width * 0.1054), y: (width * 0.4480)), controlPoint2: CGPoint(x: (width * 0.1024), y: (width * 0.4533)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0734), y: (width * 0.4404)), controlPoint1: CGPoint(x: (width * 0.0921), y: (width * 0.4556)), controlPoint2: CGPoint(x: (width * 0.0827), y: (width * 0.4496)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0460), y: (width * 0.4008)), controlPoint1: CGPoint(x: (width * 0.0635), y: (width * 0.4306)), controlPoint2: CGPoint(x: (width * 0.0538), y: (width * 0.4172)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0298), y: (width * 0.3455)), controlPoint1: CGPoint(x: (width * 0.0382), y: (width * 0.3845)), controlPoint2: CGPoint(x: (width * 0.0319), y: (width * 0.3653)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0348), y: (width * 0.2886)), controlPoint1: CGPoint(x: (width * 0.0278), y: (width * 0.3255)), controlPoint2: CGPoint(x: (width * 0.0300), y: (width * 0.3056)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0567), y: (width * 0.2468)), controlPoint1: CGPoint(x: (width * 0.0399), y: (width * 0.2717)), controlPoint2: CGPoint(x: (width * 0.0476), y: (width * 0.2571)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0821), y: (width * 0.2255)), controlPoint1: CGPoint(x: (width * 0.0655), y: (width * 0.2364)), controlPoint2: CGPoint(x: (width * 0.0750), y: (width * 0.2295)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0838), y: (width * 0.2466)), controlPoint1: CGPoint(x: (width * 0.0822), y: (width * 0.2339)), controlPoint2: CGPoint(x: (width * 0.0830), y: (width * 0.2410)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0858), y: (width * 0.2579)), controlPoint1: CGPoint(x: (width * 0.0844), y: (width * 0.2515)), controlPoint2: CGPoint(x: (width * 0.0853), y: (width * 0.2553)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0867), y: (width * 0.2618)), controlPoint1: CGPoint(x: (width * 0.0864), y: (width * 0.2605)), controlPoint2: CGPoint(x: (width * 0.0867), y: (width * 0.2618)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0871), y: (width * 0.2579)), controlPoint1: CGPoint(x: (width * 0.0867), y: (width * 0.2618)), controlPoint2: CGPoint(x: (width * 0.0868), y: (width * 0.2605)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0884), y: (width * 0.2465)), controlPoint1: CGPoint(x: (width * 0.0874), y: (width * 0.2552)), controlPoint2: CGPoint(x: (width * 0.0876), y: (width * 0.2514)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0936), y: (width * 0.2195)), controlPoint1: CGPoint(x: (width * 0.0893), y: (width * 0.2395)), controlPoint2: CGPoint(x: (width * 0.0908), y: (width * 0.2302)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0938), y: (width * 0.2193)), controlPoint1: CGPoint(x: (width * 0.0937), y: (width * 0.2194)), controlPoint2: CGPoint(x: (width * 0.0938), y: (width * 0.2193)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0936), y: (width * 0.2194)), controlPoint1: CGPoint(x: (width * 0.0938), y: (width * 0.2193)), controlPoint2: CGPoint(x: (width * 0.0937), y: (width * 0.2194)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0974), y: (width * 0.2066)), controlPoint1: CGPoint(x: (width * 0.0947), y: (width * 0.2153)), controlPoint2: CGPoint(x: (width * 0.0959), y: (width * 0.2110)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1239), y: (width * 0.1546)), controlPoint1: CGPoint(x: (width * 0.1026), y: (width * 0.1903)), controlPoint2: CGPoint(x: (width * 0.1111), y: (width * 0.1720)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1756), y: (width * 0.1107)), controlPoint1: CGPoint(x: (width * 0.1366), y: (width * 0.1373)), controlPoint2: CGPoint(x: (width * 0.1541), y: (width * 0.1213)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2418), y: (width * 0.0961)), controlPoint1: CGPoint(x: (width * 0.1970), y: (width * 0.0999)), controlPoint2: CGPoint(x: (width * 0.2203), y: (width * 0.0957)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2727), y: (width * 0.0993)), controlPoint1: CGPoint(x: (width * 0.2526), y: (width * 0.0964)), controlPoint2: CGPoint(x: (width * 0.2630), y: (width * 0.0973)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2870), y: (width * 0.1023)), controlPoint1: CGPoint(x: (width * 0.2775), y: (width * 0.1000)), controlPoint2: CGPoint(x: (width * 0.2824), y: (width * 0.1014)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2879), y: (width * 0.1025)), controlPoint1: CGPoint(x: (width * 0.2873), y: (width * 0.1024)), controlPoint2: CGPoint(x: (width * 0.2876), y: (width * 0.1024)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2797), y: (width * 0.1215)), controlPoint1: CGPoint(x: (width * 0.2846), y: (width * 0.1092)), controlPoint2: CGPoint(x: (width * 0.2819), y: (width * 0.1156)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2706), y: (width * 0.1544)), controlPoint1: CGPoint(x: (width * 0.2747), y: (width * 0.1352)), controlPoint2: CGPoint(x: (width * 0.2720), y: (width * 0.1465)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2687), y: (width * 0.1667)), controlPoint1: CGPoint(x: (width * 0.2691), y: (width * 0.1623)), controlPoint2: CGPoint(x: (width * 0.2687), y: (width * 0.1667)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2748), y: (width * 0.1560)), controlPoint1: CGPoint(x: (width * 0.2687), y: (width * 0.1667)), controlPoint2: CGPoint(x: (width * 0.2709), y: (width * 0.1629)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2927), y: (width * 0.1283)), controlPoint1: CGPoint(x: (width * 0.2788), y: (width * 0.1492)), controlPoint2: CGPoint(x: (width * 0.2848), y: (width * 0.1395)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3427), y: (width * 0.0743)), controlPoint1: CGPoint(x: (width * 0.3066), y: (width * 0.1085)), controlPoint2: CGPoint(x: (width * 0.3231), y: (width * 0.0886)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3663), y: (width * 0.0600)), controlPoint1: CGPoint(x: (width * 0.3501), y: (width * 0.0689)), controlPoint2: CGPoint(x: (width * 0.3579), y: (width * 0.0640)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3788), y: (width * 0.0551)), controlPoint1: CGPoint(x: (width * 0.3706), y: (width * 0.0583)), controlPoint2: CGPoint(x: (width * 0.3747), y: (width * 0.0562)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3916), y: (width * 0.0520)), controlPoint1: CGPoint(x: (width * 0.3830), y: (width * 0.0538)), controlPoint2: CGPoint(x: (width * 0.3873), y: (width * 0.0528)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4175), y: (width * 0.0504)), controlPoint1: CGPoint(x: (width * 0.4004), y: (width * 0.0506)), controlPoint2: CGPoint(x: (width * 0.4092), y: (width * 0.0501)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4600), y: (width * 0.0608)), controlPoint1: CGPoint(x: (width * 0.4343), y: (width * 0.0508)), controlPoint2: CGPoint(x: (width * 0.4491), y: (width * 0.0547)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4805), y: (width * 0.0826)), controlPoint1: CGPoint(x: (width * 0.4709), y: (width * 0.0669)), controlPoint2: CGPoint(x: (width * 0.4775), y: (width * 0.0757)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4825), y: (width * 0.0874)), controlPoint1: CGPoint(x: (width * 0.4814), y: (width * 0.0843)), controlPoint2: CGPoint(x: (width * 0.4820), y: (width * 0.0859)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4837), y: (width * 0.0910)), controlPoint1: CGPoint(x: (width * 0.4830), y: (width * 0.0888)), controlPoint2: CGPoint(x: (width * 0.4834), y: (width * 0.0900)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4845), y: (width * 0.0940)), controlPoint1: CGPoint(x: (width * 0.4843), y: (width * 0.0930)), controlPoint2: CGPoint(x: (width * 0.4845), y: (width * 0.0940)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4849), y: (width * 0.0909)), controlPoint1: CGPoint(x: (width * 0.4845), y: (width * 0.0940)), controlPoint2: CGPoint(x: (width * 0.4847), y: (width * 0.0930)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4852), y: (width * 0.0869)), controlPoint1: CGPoint(x: (width * 0.4851), y: (width * 0.0898)), controlPoint2: CGPoint(x: (width * 0.4852), y: (width * 0.0885)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4850), y: (width * 0.0815)), controlPoint1: CGPoint(x: (width * 0.4852), y: (width * 0.0853)), controlPoint2: CGPoint(x: (width * 0.4852), y: (width * 0.0835)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4809), y: (width * 0.0662)), controlPoint1: CGPoint(x: (width * 0.4847), y: (width * 0.0773)), controlPoint2: CGPoint(x: (width * 0.4835), y: (width * 0.0720)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4858), y: (width * 0.0611)), controlPoint1: CGPoint(x: (width * 0.4822), y: (width * 0.0648)), controlPoint2: CGPoint(x: (width * 0.4838), y: (width * 0.0630)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5136), y: (width * 0.0417)), controlPoint1: CGPoint(x: (width * 0.4916), y: (width * 0.0554)), controlPoint2: CGPoint(x: (width * 0.5011), y: (width * 0.0486)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5342), y: (width * 0.0323)), controlPoint1: CGPoint(x: (width * 0.5200), y: (width * 0.0383)), controlPoint2: CGPoint(x: (width * 0.5267), y: (width * 0.0350)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5584), y: (width * 0.0273)), controlPoint1: CGPoint(x: (width * 0.5416), y: (width * 0.0299)), controlPoint2: CGPoint(x: (width * 0.5498), y: (width * 0.0280)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6132), y: (width * 0.0361)), controlPoint1: CGPoint(x: (width * 0.5755), y: (width * 0.0256)), controlPoint2: CGPoint(x: (width * 0.5945), y: (width * 0.0286)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6613), y: (width * 0.0667)), controlPoint1: CGPoint(x: (width * 0.6318), y: (width * 0.0435)), controlPoint2: CGPoint(x: (width * 0.6482), y: (width * 0.0545)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6784), y: (width * 0.0856)), controlPoint1: CGPoint(x: (width * 0.6679), y: (width * 0.0727)), controlPoint2: CGPoint(x: (width * 0.6736), y: (width * 0.0791)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6905), y: (width * 0.1047)), controlPoint1: CGPoint(x: (width * 0.6833), y: (width * 0.0920)), controlPoint2: CGPoint(x: (width * 0.6874), y: (width * 0.0984)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7020), y: (width * 0.1364)), controlPoint1: CGPoint(x: (width * 0.6955), y: (width * 0.1144)), controlPoint2: CGPoint(x: (width * 0.6997), y: (width * 0.1252)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7037), y: (width * 0.1458)), controlPoint1: CGPoint(x: (width * 0.7030), y: (width * 0.1404)), controlPoint2: CGPoint(x: (width * 0.7033), y: (width * 0.1436)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7042), y: (width * 0.1491)), controlPoint1: CGPoint(x: (width * 0.7040), y: (width * 0.1480)), controlPoint2: CGPoint(x: (width * 0.7042), y: (width * 0.1491)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7049), y: (width * 0.1458)), controlPoint1: CGPoint(x: (width * 0.7042), y: (width * 0.1491)), controlPoint2: CGPoint(x: (width * 0.7045), y: (width * 0.1480)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7066), y: (width * 0.1362)), controlPoint1: CGPoint(x: (width * 0.7054), y: (width * 0.1437)), controlPoint2: CGPoint(x: (width * 0.7062), y: (width * 0.1404)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7064), y: (width * 0.1116)), controlPoint1: CGPoint(x: (width * 0.7074), y: (width * 0.1301)), controlPoint2: CGPoint(x: (width * 0.7077), y: (width * 0.1216)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7081), y: (width * 0.1107)), controlPoint1: CGPoint(x: (width * 0.7070), y: (width * 0.1112)), controlPoint2: CGPoint(x: (width * 0.7075), y: (width * 0.1110)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7452), y: (width * 0.0959)), controlPoint1: CGPoint(x: (width * 0.7167), y: (width * 0.1062)), controlPoint2: CGPoint(x: (width * 0.7293), y: (width * 0.0992)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7578), y: (width * 0.0940)), controlPoint1: CGPoint(x: (width * 0.7491), y: (width * 0.0948)), controlPoint2: CGPoint(x: (width * 0.7534), y: (width * 0.0946)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7722), y: (width * 0.0927)), controlPoint1: CGPoint(x: (width * 0.7624), y: (width * 0.0936)), controlPoint2: CGPoint(x: (width * 0.7673), y: (width * 0.0929)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8029), y: (width * 0.0935)), controlPoint1: CGPoint(x: (width * 0.7819), y: (width * 0.0921)), controlPoint2: CGPoint(x: (width * 0.7922), y: (width * 0.0925)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8678), y: (width * 0.1148)), controlPoint1: CGPoint(x: (width * 0.8241), y: (width * 0.0961)), controlPoint2: CGPoint(x: (width * 0.8466), y: (width * 0.1026)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8973), y: (width * 0.1352)), controlPoint1: CGPoint(x: (width * 0.8784), y: (width * 0.1208)), controlPoint2: CGPoint(x: (width * 0.8882), y: (width * 0.1278)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9101), y: (width * 0.1468)), controlPoint1: CGPoint(x: (width * 0.9017), y: (width * 0.1390)), controlPoint2: CGPoint(x: (width * 0.9061), y: (width * 0.1428)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.9131), y: (width * 0.1497)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9158), y: (width * 0.1525)), controlPoint1: CGPoint(x: (width * 0.9141), y: (width * 0.1507)), controlPoint2: CGPoint(x: (width * 0.9149), y: (width * 0.1516)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9208), y: (width * 0.1584)), controlPoint1: CGPoint(x: (width * 0.9175), y: (width * 0.1543)), controlPoint2: CGPoint(x: (width * 0.9192), y: (width * 0.1564)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9489), y: (width * 0.2091)), controlPoint1: CGPoint(x: (width * 0.9338), y: (width * 0.1751)), controlPoint2: CGPoint(x: (width * 0.9427), y: (width * 0.1935)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9588), y: (width * 0.2481)), controlPoint1: CGPoint(x: (width * 0.9549), y: (width * 0.2249)), controlPoint2: CGPoint(x: (width * 0.9579), y: (width * 0.2385)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9592), y: (width * 0.2593)), controlPoint1: CGPoint(x: (width * 0.9591), y: (width * 0.2529)), controlPoint2: CGPoint(x: (width * 0.9594), y: (width * 0.2567)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9591), y: (width * 0.2632)), controlPoint1: CGPoint(x: (width * 0.9591), y: (width * 0.2619)), controlPoint2: CGPoint(x: (width * 0.9591), y: (width * 0.2632)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9604), y: (width * 0.2595)), controlPoint1: CGPoint(x: (width * 0.9591), y: (width * 0.2632)), controlPoint2: CGPoint(x: (width * 0.9595), y: (width * 0.2619)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9634), y: (width * 0.2483)), controlPoint1: CGPoint(x: (width * 0.9614), y: (width * 0.2570)), controlPoint2: CGPoint(x: (width * 0.9623), y: (width * 0.2533)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9630), y: (width * 0.2054)), controlPoint1: CGPoint(x: (width * 0.9653), y: (width * 0.2384)), controlPoint2: CGPoint(x: (width * 0.9658), y: (width * 0.2235)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9606), y: (width * 0.1932)), controlPoint1: CGPoint(x: (width * 0.9624), y: (width * 0.2015)), controlPoint2: CGPoint(x: (width * 0.9615), y: (width * 0.1974)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9777), y: (width * 0.2189)), controlPoint1: CGPoint(x: (width * 0.9653), y: (width * 0.1995)), controlPoint2: CGPoint(x: (width * 0.9714), y: (width * 0.2082)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9969), y: (width * 0.2630)), controlPoint1: CGPoint(x: (width * 0.9848), y: (width * 0.2311)), controlPoint2: CGPoint(x: (width * 0.9923), y: (width * 0.2459)))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: (width * 1.0201), y: (width * 0.2546)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9893), y: (width * 0.2099)), controlPoint1: CGPoint(x: (width * 1.0117), y: (width * 0.2352)), controlPoint2: CGPoint(x: (width * 0.9999), y: (width * 0.2207)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9617), y: (width * 0.1873)), controlPoint1: CGPoint(x: (width * 0.9785), y: (width * 0.1991)), controlPoint2: CGPoint(x: (width * 0.9687), y: (width * 0.1919)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9585), y: (width * 0.1853)), controlPoint1: CGPoint(x: (width * 0.9606), y: (width * 0.1866)), controlPoint2: CGPoint(x: (width * 0.9595), y: (width * 0.1859)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9412), y: (width * 0.1444)), controlPoint1: CGPoint(x: (width * 0.9550), y: (width * 0.1724)), controlPoint2: CGPoint(x: (width * 0.9496), y: (width * 0.1585)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9357), y: (width * 0.1363)), controlPoint1: CGPoint(x: (width * 0.9395), y: (width * 0.1417)), controlPoint2: CGPoint(x: (width * 0.9379), y: (width * 0.1390)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9327), y: (width * 0.1323)), controlPoint1: CGPoint(x: (width * 0.9347), y: (width * 0.1350)), controlPoint2: CGPoint(x: (width * 0.9337), y: (width * 0.1335)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.9295), y: (width * 0.1286)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9159), y: (width * 0.1142)), controlPoint1: CGPoint(x: (width * 0.9254), y: (width * 0.1236)), controlPoint2: CGPoint(x: (width * 0.9207), y: (width * 0.1190)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8822), y: (width * 0.0893)), controlPoint1: CGPoint(x: (width * 0.9061), y: (width * 0.1050)), controlPoint2: CGPoint(x: (width * 0.8948), y: (width * 0.0965)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8041), y: (width * 0.0688)), controlPoint1: CGPoint(x: (width * 0.8570), y: (width * 0.0747)), controlPoint2: CGPoint(x: (width * 0.8289), y: (width * 0.0688)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7693), y: (width * 0.0729)), controlPoint1: CGPoint(x: (width * 0.7916), y: (width * 0.0691)), controlPoint2: CGPoint(x: (width * 0.7799), y: (width * 0.0704)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7544), y: (width * 0.0769)), controlPoint1: CGPoint(x: (width * 0.7640), y: (width * 0.0740)), controlPoint2: CGPoint(x: (width * 0.7592), y: (width * 0.0756)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7405), y: (width * 0.0820)), controlPoint1: CGPoint(x: (width * 0.7495), y: (width * 0.0785)), controlPoint2: CGPoint(x: (width * 0.7448), y: (width * 0.0798)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7192), y: (width * 0.0949)), controlPoint1: CGPoint(x: (width * 0.7318), y: (width * 0.0858)), controlPoint2: CGPoint(x: (width * 0.7249), y: (width * 0.0906)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7057), y: (width * 0.1066)), controlPoint1: CGPoint(x: (width * 0.7136), y: (width * 0.0992)), controlPoint2: CGPoint(x: (width * 0.7092), y: (width * 0.1032)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7043), y: (width * 0.0997)), controlPoint1: CGPoint(x: (width * 0.7053), y: (width * 0.1044)), controlPoint2: CGPoint(x: (width * 0.7049), y: (width * 0.1020)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6956), y: (width * 0.0753)), controlPoint1: CGPoint(x: (width * 0.7025), y: (width * 0.0920)), controlPoint2: CGPoint(x: (width * 0.6997), y: (width * 0.0837)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6795), y: (width * 0.0499)), controlPoint1: CGPoint(x: (width * 0.6916), y: (width * 0.0668)), controlPoint2: CGPoint(x: (width * 0.6862), y: (width * 0.0582)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6240), y: (width * 0.0088)), controlPoint1: CGPoint(x: (width * 0.6661), y: (width * 0.0334)), controlPoint2: CGPoint(x: (width * 0.6473), y: (width * 0.0181)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5542), y: (width * 0.0029)), controlPoint1: CGPoint(x: (width * 0.6008), y: -0.16), controlPoint2: CGPoint(x: (width * 0.5756), y: -0.76))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5257), y: (width * 0.0142)), controlPoint1: CGPoint(x: (width * 0.5436), y: (width * 0.0054)), controlPoint2: CGPoint(x: (width * 0.5339), y: (width * 0.0095)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5050), y: (width * 0.0298)), controlPoint1: CGPoint(x: (width * 0.5174), y: (width * 0.0191)), controlPoint2: CGPoint(x: (width * 0.5106), y: (width * 0.0248)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4821), y: (width * 0.0584)), controlPoint1: CGPoint(x: (width * 0.4936), y: (width * 0.0404)), controlPoint2: CGPoint(x: (width * 0.4860), y: (width * 0.0506)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4797), y: (width * 0.0637)), controlPoint1: CGPoint(x: (width * 0.4811), y: (width * 0.0604)), controlPoint2: CGPoint(x: (width * 0.4803), y: (width * 0.0621)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4690), y: (width * 0.0493)), controlPoint1: CGPoint(x: (width * 0.4772), y: (width * 0.0589)), controlPoint2: CGPoint(x: (width * 0.4738), y: (width * 0.0540)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4203), y: (width * 0.0258)), controlPoint1: CGPoint(x: (width * 0.4578), y: (width * 0.0381)), controlPoint2: CGPoint(x: (width * 0.4404), y: (width * 0.0294)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3882), y: (width * 0.0242)), controlPoint1: CGPoint(x: (width * 0.4103), y: (width * 0.0239)), controlPoint2: CGPoint(x: (width * 0.3995), y: (width * 0.0233)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3710), y: (width * 0.0272)), controlPoint1: CGPoint(x: (width * 0.3826), y: (width * 0.0247)), controlPoint2: CGPoint(x: (width * 0.3768), y: (width * 0.0257)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3539), y: (width * 0.0334)), controlPoint1: CGPoint(x: (width * 0.3649), y: (width * 0.0287)), controlPoint2: CGPoint(x: (width * 0.3595), y: (width * 0.0311)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3249), y: (width * 0.0526)), controlPoint1: CGPoint(x: (width * 0.3430), y: (width * 0.0387)), controlPoint2: CGPoint(x: (width * 0.3333), y: (width * 0.0453)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3038), y: (width * 0.0759)), controlPoint1: CGPoint(x: (width * 0.3167), y: (width * 0.0600)), controlPoint2: CGPoint(x: (width * 0.3097), y: (width * 0.0680)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2961), y: (width * 0.0874)), controlPoint1: CGPoint(x: (width * 0.3010), y: (width * 0.0798)), controlPoint2: CGPoint(x: (width * 0.2985), y: (width * 0.0836)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2924), y: (width * 0.0857)), controlPoint1: CGPoint(x: (width * 0.2949), y: (width * 0.0868)), controlPoint2: CGPoint(x: (width * 0.2937), y: (width * 0.0863)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2780), y: (width * 0.0799)), controlPoint1: CGPoint(x: (width * 0.2878), y: (width * 0.0839)), controlPoint2: CGPoint(x: (width * 0.2832), y: (width * 0.0817)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2438), y: (width * 0.0715)), controlPoint1: CGPoint(x: (width * 0.2678), y: (width * 0.0761)), controlPoint2: CGPoint(x: (width * 0.2562), y: (width * 0.0732)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1625), y: (width * 0.0844)), controlPoint1: CGPoint(x: (width * 0.2189), y: (width * 0.0680)), controlPoint2: CGPoint(x: (width * 0.1894), y: (width * 0.0709)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1031), y: (width * 0.1412)), controlPoint1: CGPoint(x: (width * 0.1356), y: (width * 0.0978)), controlPoint2: CGPoint(x: (width * 0.1155), y: (width * 0.1193)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0831), y: (width * 0.2035)), controlPoint1: CGPoint(x: (width * 0.0907), y: (width * 0.1632)), controlPoint2: CGPoint(x: (width * 0.0849), y: (width * 0.1852)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0820), y: (width * 0.2207)), controlPoint1: CGPoint(x: (width * 0.0824), y: (width * 0.2097)), controlPoint2: CGPoint(x: (width * 0.0821), y: (width * 0.2154)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0807), y: (width * 0.2210)), controlPoint1: CGPoint(x: (width * 0.0816), y: (width * 0.2208)), controlPoint2: CGPoint(x: (width * 0.0812), y: (width * 0.2209)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0468), y: (width * 0.2359)), controlPoint1: CGPoint(x: (width * 0.0723), y: (width * 0.2226)), controlPoint2: CGPoint(x: (width * 0.0600), y: (width * 0.2266)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0117), y: (width * 0.2799)), controlPoint1: CGPoint(x: (width * 0.0336), y: (width * 0.2450)), controlPoint2: CGPoint(x: (width * 0.0206), y: (width * 0.2603)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0007), y: (width * 0.3484)), controlPoint1: CGPoint(x: (width * 0.0030), y: (width * 0.2996)), controlPoint2: CGPoint(x: -0.61, y: (width * 0.3234)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0246), y: (width * 0.4132)), controlPoint1: CGPoint(x: (width * 0.0034), y: (width * 0.3737)), controlPoint2: CGPoint(x: (width * 0.0129), y: (width * 0.3956)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0645), y: (width * 0.4520)), controlPoint1: CGPoint(x: (width * 0.0363), y: (width * 0.4308)), controlPoint2: CGPoint(x: (width * 0.0508), y: (width * 0.4440)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0970), y: (width * 0.4637)), controlPoint1: CGPoint(x: (width * 0.0771), y: (width * 0.4594)), controlPoint2: CGPoint(x: (width * 0.0886), y: (width * 0.4627)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0903), y: (width * 0.4791)), controlPoint1: CGPoint(x: (width * 0.0947), y: (width * 0.4686)), controlPoint2: CGPoint(x: (width * 0.0923), y: (width * 0.4737)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0882), y: (width * 0.4843)), controlPoint1: CGPoint(x: (width * 0.0896), y: (width * 0.4808)), controlPoint2: CGPoint(x: (width * 0.0889), y: (width * 0.4825)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0866), y: (width * 0.4899)), controlPoint1: CGPoint(x: (width * 0.0876), y: (width * 0.4861)), controlPoint2: CGPoint(x: (width * 0.0871), y: (width * 0.4880)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0835), y: (width * 0.5016)), controlPoint1: CGPoint(x: (width * 0.0856), y: (width * 0.4937)), controlPoint2: CGPoint(x: (width * 0.0843), y: (width * 0.4976)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0818), y: (width * 0.5141)), controlPoint1: CGPoint(x: (width * 0.0830), y: (width * 0.5057)), controlPoint2: CGPoint(x: (width * 0.0824), y: (width * 0.5099)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0816), y: (width * 0.5270)), controlPoint1: CGPoint(x: (width * 0.0814), y: (width * 0.5183)), controlPoint2: CGPoint(x: (width * 0.0817), y: (width * 0.5227)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0953), y: (width * 0.5796)), controlPoint1: CGPoint(x: (width * 0.0822), y: (width * 0.5445)), controlPoint2: CGPoint(x: (width * 0.0869), y: (width * 0.5628)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1303), y: (width * 0.6255)), controlPoint1: CGPoint(x: (width * 0.1037), y: (width * 0.5966)), controlPoint2: CGPoint(x: (width * 0.1157), y: (width * 0.6122)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2309), y: (width * 0.6679)), controlPoint1: CGPoint(x: (width * 0.1595), y: (width * 0.6520)), controlPoint2: CGPoint(x: (width * 0.1966), y: (width * 0.6666)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2719), y: (width * 0.6634)), controlPoint1: CGPoint(x: (width * 0.2455), y: (width * 0.6685)), controlPoint2: CGPoint(x: (width * 0.2593), y: (width * 0.6667)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2775), y: (width * 0.6691)), controlPoint1: CGPoint(x: (width * 0.2733), y: (width * 0.6649)), controlPoint2: CGPoint(x: (width * 0.2751), y: (width * 0.6669)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3083), y: (width * 0.6890)), controlPoint1: CGPoint(x: (width * 0.2839), y: (width * 0.6748)), controlPoint2: CGPoint(x: (width * 0.2938), y: (width * 0.6827)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3631), y: (width * 0.6990)), controlPoint1: CGPoint(x: (width * 0.3227), y: (width * 0.6953)), controlPoint2: CGPoint(x: (width * 0.3418), y: (width * 0.7000)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4291), y: (width * 0.6815)), controlPoint1: CGPoint(x: (width * 0.3843), y: (width * 0.6984)), controlPoint2: CGPoint(x: (width * 0.4074), y: (width * 0.6925)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4990), y: (width * 0.6088)), controlPoint1: CGPoint(x: (width * 0.4638), y: (width * 0.6640)), controlPoint2: CGPoint(x: (width * 0.4877), y: (width * 0.6356)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5021), y: (width * 0.6119)), controlPoint1: CGPoint(x: (width * 0.5000), y: (width * 0.6097)), controlPoint2: CGPoint(x: (width * 0.5010), y: (width * 0.6108)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5357), y: (width * 0.6304)), controlPoint1: CGPoint(x: (width * 0.5087), y: (width * 0.6176)), controlPoint2: CGPoint(x: (width * 0.5192), y: (width * 0.6262)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5488), y: (width * 0.6325)), controlPoint1: CGPoint(x: (width * 0.5398), y: (width * 0.6312)), controlPoint2: CGPoint(x: (width * 0.5442), y: (width * 0.6325)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5558), y: (width * 0.6330)), controlPoint1: CGPoint(x: (width * 0.5511), y: (width * 0.6327)), controlPoint2: CGPoint(x: (width * 0.5534), y: (width * 0.6329)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5630), y: (width * 0.6329)), controlPoint1: CGPoint(x: (width * 0.5582), y: (width * 0.6332)), controlPoint2: CGPoint(x: (width * 0.5605), y: (width * 0.6329)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5705), y: (width * 0.6324)), controlPoint1: CGPoint(x: (width * 0.5654), y: (width * 0.6327)), controlPoint2: CGPoint(x: (width * 0.5679), y: (width * 0.6326)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5779), y: (width * 0.6313)), controlPoint1: CGPoint(x: (width * 0.5729), y: (width * 0.6320)), controlPoint2: CGPoint(x: (width * 0.5754), y: (width * 0.6317)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5936), y: (width * 0.6281)), controlPoint1: CGPoint(x: (width * 0.5830), y: (width * 0.6307)), controlPoint2: CGPoint(x: (width * 0.5882), y: (width * 0.6294)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6260), y: (width * 0.6132)), controlPoint1: CGPoint(x: (width * 0.6043), y: (width * 0.6251)), controlPoint2: CGPoint(x: (width * 0.6155), y: (width * 0.6204)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6530), y: (width * 0.5841)), controlPoint1: CGPoint(x: (width * 0.6365), y: (width * 0.6061)), controlPoint2: CGPoint(x: (width * 0.6461), y: (width * 0.5961)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6641), y: (width * 0.5520)), controlPoint1: CGPoint(x: (width * 0.6589), y: (width * 0.5739)), controlPoint2: CGPoint(x: (width * 0.6624), y: (width * 0.5628)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6649), y: (width * 0.5527)), controlPoint1: CGPoint(x: (width * 0.6643), y: (width * 0.5523)), controlPoint2: CGPoint(x: (width * 0.6646), y: (width * 0.5525)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6746), y: (width * 0.5598)), controlPoint1: CGPoint(x: (width * 0.6677), y: (width * 0.5551)), controlPoint2: CGPoint(x: (width * 0.6710), y: (width * 0.5573)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7018), y: (width * 0.5714)), controlPoint1: CGPoint(x: (width * 0.6820), y: (width * 0.5642)), controlPoint2: CGPoint(x: (width * 0.6911), y: (width * 0.5685)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7777), y: (width * 0.5730)), controlPoint1: CGPoint(x: (width * 0.7237), y: (width * 0.5765)), controlPoint2: CGPoint(x: (width * 0.7492), y: (width * 0.5770)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8653), y: (width * 0.5393)), controlPoint1: CGPoint(x: (width * 0.8060), y: (width * 0.5688)), controlPoint2: CGPoint(x: (width * 0.8371), y: (width * 0.5589)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9014), y: (width * 0.5042)), controlPoint1: CGPoint(x: (width * 0.8793), y: (width * 0.5296)), controlPoint2: CGPoint(x: (width * 0.8918), y: (width * 0.5177)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9224), y: (width * 0.4630)), controlPoint1: CGPoint(x: (width * 0.9109), y: (width * 0.4907)), controlPoint2: CGPoint(x: (width * 0.9175), y: (width * 0.4768)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9279), y: (width * 0.4436)), controlPoint1: CGPoint(x: (width * 0.9247), y: (width * 0.4565)), controlPoint2: CGPoint(x: (width * 0.9265), y: (width * 0.4500)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9332), y: (width * 0.4407)), controlPoint1: CGPoint(x: (width * 0.9294), y: (width * 0.4428)), controlPoint2: CGPoint(x: (width * 0.9311), y: (width * 0.4419)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9629), y: (width * 0.4217)), controlPoint1: CGPoint(x: (width * 0.9405), y: (width * 0.4367)), controlPoint2: CGPoint(x: (width * 0.9508), y: (width * 0.4306)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 1.0016), y: (width * 0.3848)), controlPoint1: CGPoint(x: (width * 0.9749), y: (width * 0.4127)), controlPoint2: CGPoint(x: (width * 0.9888), y: (width * 0.4010)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 1.0190), y: (width * 0.3571)), controlPoint1: CGPoint(x: (width * 1.0081), y: (width * 0.3769)), controlPoint2: CGPoint(x: (width * 1.0140), y: (width * 0.3675)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 1.0296), y: (width * 0.3226)), controlPoint1: CGPoint(x: (width * 1.0240), y: (width * 0.3467)), controlPoint2: CGPoint(x: (width * 1.0280), y: (width * 0.3349)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 1.0201), y: (width * 0.2546)), controlPoint1: CGPoint(x: (width * 1.0334), y: (width * 0.2979)), controlPoint2: CGPoint(x: (width * 1.0287), y: (width * 0.2736)))
        bezier2Path.close()
        shape2.path = bezier2Path.cgPath
        shape2.fillColor = blackColor.cgColor
        
        //// Bezier Drawing
        let shape = CAShapeLayer()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: (width * 1.0201), y: (width * 0.2546)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9893), y: (width * 0.2099)), controlPoint1: CGPoint(x: (width * 1.0117), y: (width * 0.2352)), controlPoint2: CGPoint(x: (width * 0.9999), y: (width * 0.2207)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9617), y: (width * 0.1873)), controlPoint1: CGPoint(x: (width * 0.9785), y: (width * 0.1991)), controlPoint2: CGPoint(x: (width * 0.9687), y: (width * 0.1919)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9585), y: (width * 0.1853)), controlPoint1: CGPoint(x: (width * 0.9606), y: (width * 0.1866)), controlPoint2: CGPoint(x: (width * 0.9595), y: (width * 0.1859)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9412), y: (width * 0.1444)), controlPoint1: CGPoint(x: (width * 0.9550), y: (width * 0.1724)), controlPoint2: CGPoint(x: (width * 0.9496), y: (width * 0.1585)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9357), y: (width * 0.1363)), controlPoint1: CGPoint(x: (width * 0.9395), y: (width * 0.1417)), controlPoint2: CGPoint(x: (width * 0.9379), y: (width * 0.1390)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9327), y: (width * 0.1323)), controlPoint1: CGPoint(x: (width * 0.9347), y: (width * 0.1350)), controlPoint2: CGPoint(x: (width * 0.9337), y: (width * 0.1335)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.9295), y: (width * 0.1286)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9159), y: (width * 0.1142)), controlPoint1: CGPoint(x: (width * 0.9254), y: (width * 0.1236)), controlPoint2: CGPoint(x: (width * 0.9207), y: (width * 0.1190)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8822), y: (width * 0.0893)), controlPoint1: CGPoint(x: (width * 0.9061), y: (width * 0.1050)), controlPoint2: CGPoint(x: (width * 0.8948), y: (width * 0.0965)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8041), y: (width * 0.0688)), controlPoint1: CGPoint(x: (width * 0.8570), y: (width * 0.0747)), controlPoint2: CGPoint(x: (width * 0.8289), y: (width * 0.0688)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7693), y: (width * 0.0729)), controlPoint1: CGPoint(x: (width * 0.7916), y: (width * 0.0691)), controlPoint2: CGPoint(x: (width * 0.7799), y: (width * 0.0704)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7544), y: (width * 0.0769)), controlPoint1: CGPoint(x: (width * 0.7640), y: (width * 0.0740)), controlPoint2: CGPoint(x: (width * 0.7592), y: (width * 0.0756)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7405), y: (width * 0.0820)), controlPoint1: CGPoint(x: (width * 0.7495), y: (width * 0.0785)), controlPoint2: CGPoint(x: (width * 0.7448), y: (width * 0.0798)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7191), y: (width * 0.0949)), controlPoint1: CGPoint(x: (width * 0.7318), y: (width * 0.0858)), controlPoint2: CGPoint(x: (width * 0.7249), y: (width * 0.0906)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7057), y: (width * 0.1066)), controlPoint1: CGPoint(x: (width * 0.7136), y: (width * 0.0992)), controlPoint2: CGPoint(x: (width * 0.7092), y: (width * 0.1032)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7043), y: (width * 0.0997)), controlPoint1: CGPoint(x: (width * 0.7053), y: (width * 0.1044)), controlPoint2: CGPoint(x: (width * 0.7048), y: (width * 0.1020)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6956), y: (width * 0.0753)), controlPoint1: CGPoint(x: (width * 0.7025), y: (width * 0.0920)), controlPoint2: CGPoint(x: (width * 0.6997), y: (width * 0.0837)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6795), y: (width * 0.0499)), controlPoint1: CGPoint(x: (width * 0.6916), y: (width * 0.0668)), controlPoint2: CGPoint(x: (width * 0.6862), y: (width * 0.0582)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6240), y: (width * 0.0088)), controlPoint1: CGPoint(x: (width * 0.6661), y: (width * 0.0334)), controlPoint2: CGPoint(x: (width * 0.6473), y: (width * 0.0181)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5542), y: (width * 0.0029)), controlPoint1: CGPoint(x: (width * 0.6008), y: -0.16), controlPoint2: CGPoint(x: (width * 0.5756), y: -0.76))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5257), y: (width * 0.0142)), controlPoint1: CGPoint(x: (width * 0.5436), y: (width * 0.0054)), controlPoint2: CGPoint(x: (width * 0.5339), y: (width * 0.0095)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5050), y: (width * 0.0298)), controlPoint1: CGPoint(x: (width * 0.5174), y: (width * 0.0191)), controlPoint2: CGPoint(x: (width * 0.5106), y: (width * 0.0248)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4821), y: (width * 0.0584)), controlPoint1: CGPoint(x: (width * 0.4936), y: (width * 0.0404)), controlPoint2: CGPoint(x: (width * 0.4860), y: (width * 0.0506)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4797), y: (width * 0.0637)), controlPoint1: CGPoint(x: (width * 0.4811), y: (width * 0.0604)), controlPoint2: CGPoint(x: (width * 0.4803), y: (width * 0.0621)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4690), y: (width * 0.0493)), controlPoint1: CGPoint(x: (width * 0.4772), y: (width * 0.0589)), controlPoint2: CGPoint(x: (width * 0.4738), y: (width * 0.0540)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4203), y: (width * 0.0258)), controlPoint1: CGPoint(x: (width * 0.4578), y: (width * 0.0381)), controlPoint2: CGPoint(x: (width * 0.4404), y: (width * 0.0294)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3882), y: (width * 0.0242)), controlPoint1: CGPoint(x: (width * 0.4103), y: (width * 0.0239)), controlPoint2: CGPoint(x: (width * 0.3995), y: (width * 0.0233)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3710), y: (width * 0.0272)), controlPoint1: CGPoint(x: (width * 0.3826), y: (width * 0.0247)), controlPoint2: CGPoint(x: (width * 0.3768), y: (width * 0.0257)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3539), y: (width * 0.0334)), controlPoint1: CGPoint(x: (width * 0.3649), y: (width * 0.0287)), controlPoint2: CGPoint(x: (width * 0.3595), y: (width * 0.0311)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3249), y: (width * 0.0526)), controlPoint1: CGPoint(x: (width * 0.3430), y: (width * 0.0387)), controlPoint2: CGPoint(x: (width * 0.3333), y: (width * 0.0453)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3038), y: (width * 0.0759)), controlPoint1: CGPoint(x: (width * 0.3167), y: (width * 0.0600)), controlPoint2: CGPoint(x: (width * 0.3097), y: (width * 0.0680)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2961), y: (width * 0.0874)), controlPoint1: CGPoint(x: (width * 0.3010), y: (width * 0.0798)), controlPoint2: CGPoint(x: (width * 0.2985), y: (width * 0.0836)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2924), y: (width * 0.0857)), controlPoint1: CGPoint(x: (width * 0.2949), y: (width * 0.0868)), controlPoint2: CGPoint(x: (width * 0.2937), y: (width * 0.0863)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2780), y: (width * 0.0799)), controlPoint1: CGPoint(x: (width * 0.2878), y: (width * 0.0839)), controlPoint2: CGPoint(x: (width * 0.2832), y: (width * 0.0817)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2438), y: (width * 0.0715)), controlPoint1: CGPoint(x: (width * 0.2678), y: (width * 0.0761)), controlPoint2: CGPoint(x: (width * 0.2562), y: (width * 0.0732)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1625), y: (width * 0.0844)), controlPoint1: CGPoint(x: (width * 0.2189), y: (width * 0.0680)), controlPoint2: CGPoint(x: (width * 0.1894), y: (width * 0.0709)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1031), y: (width * 0.1412)), controlPoint1: CGPoint(x: (width * 0.1356), y: (width * 0.0978)), controlPoint2: CGPoint(x: (width * 0.1155), y: (width * 0.1193)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0831), y: (width * 0.2035)), controlPoint1: CGPoint(x: (width * 0.0907), y: (width * 0.1632)), controlPoint2: CGPoint(x: (width * 0.0849), y: (width * 0.1852)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0820), y: (width * 0.2207)), controlPoint1: CGPoint(x: (width * 0.0824), y: (width * 0.2097)), controlPoint2: CGPoint(x: (width * 0.0821), y: (width * 0.2154)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0807), y: (width * 0.2210)), controlPoint1: CGPoint(x: (width * 0.0816), y: (width * 0.2208)), controlPoint2: CGPoint(x: (width * 0.0812), y: (width * 0.2209)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0468), y: (width * 0.2359)), controlPoint1: CGPoint(x: (width * 0.0723), y: (width * 0.2226)), controlPoint2: CGPoint(x: (width * 0.0600), y: (width * 0.2266)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0117), y: (width * 0.2799)), controlPoint1: CGPoint(x: (width * 0.0336), y: (width * 0.2450)), controlPoint2: CGPoint(x: (width * 0.0206), y: (width * 0.2603)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0007), y: (width * 0.3484)), controlPoint1: CGPoint(x: (width * 0.0030), y: (width * 0.2996)), controlPoint2: CGPoint(x: -0.61, y: (width * 0.3234)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0246), y: (width * 0.4132)), controlPoint1: CGPoint(x: (width * 0.0034), y: (width * 0.3737)), controlPoint2: CGPoint(x: (width * 0.0129), y: (width * 0.3956)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0645), y: (width * 0.4520)), controlPoint1: CGPoint(x: (width * 0.0363), y: (width * 0.4308)), controlPoint2: CGPoint(x: (width * 0.0508), y: (width * 0.4440)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0970), y: (width * 0.4637)), controlPoint1: CGPoint(x: (width * 0.0770), y: (width * 0.4594)), controlPoint2: CGPoint(x: (width * 0.0886), y: (width * 0.4627)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0903), y: (width * 0.4791)), controlPoint1: CGPoint(x: (width * 0.0947), y: (width * 0.4686)), controlPoint2: CGPoint(x: (width * 0.0923), y: (width * 0.4737)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0882), y: (width * 0.4843)), controlPoint1: CGPoint(x: (width * 0.0896), y: (width * 0.4808)), controlPoint2: CGPoint(x: (width * 0.0889), y: (width * 0.4826)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0866), y: (width * 0.4899)), controlPoint1: CGPoint(x: (width * 0.0876), y: (width * 0.4861)), controlPoint2: CGPoint(x: (width * 0.0871), y: (width * 0.4880)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0835), y: (width * 0.5016)), controlPoint1: CGPoint(x: (width * 0.0856), y: (width * 0.4937)), controlPoint2: CGPoint(x: (width * 0.0842), y: (width * 0.4976)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0818), y: (width * 0.5141)), controlPoint1: CGPoint(x: (width * 0.0830), y: (width * 0.5057)), controlPoint2: CGPoint(x: (width * 0.0824), y: (width * 0.5099)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0816), y: (width * 0.5270)), controlPoint1: CGPoint(x: (width * 0.0814), y: (width * 0.5184)), controlPoint2: CGPoint(x: (width * 0.0817), y: (width * 0.5227)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0953), y: (width * 0.5796)), controlPoint1: CGPoint(x: (width * 0.0822), y: (width * 0.5445)), controlPoint2: CGPoint(x: (width * 0.0869), y: (width * 0.5628)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1303), y: (width * 0.6255)), controlPoint1: CGPoint(x: (width * 0.1037), y: (width * 0.5966)), controlPoint2: CGPoint(x: (width * 0.1157), y: (width * 0.6122)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2309), y: (width * 0.6679)), controlPoint1: CGPoint(x: (width * 0.1595), y: (width * 0.6520)), controlPoint2: CGPoint(x: (width * 0.1966), y: (width * 0.6666)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2719), y: (width * 0.6634)), controlPoint1: CGPoint(x: (width * 0.2455), y: (width * 0.6685)), controlPoint2: CGPoint(x: (width * 0.2593), y: (width * 0.6667)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2775), y: (width * 0.6691)), controlPoint1: CGPoint(x: (width * 0.2733), y: (width * 0.6649)), controlPoint2: CGPoint(x: (width * 0.2751), y: (width * 0.6669)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3083), y: (width * 0.6890)), controlPoint1: CGPoint(x: (width * 0.2839), y: (width * 0.6748)), controlPoint2: CGPoint(x: (width * 0.2938), y: (width * 0.6827)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3631), y: (width * 0.6990)), controlPoint1: CGPoint(x: (width * 0.3227), y: (width * 0.6953)), controlPoint2: CGPoint(x: (width * 0.3418), y: (width * 0.7000)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4291), y: (width * 0.6815)), controlPoint1: CGPoint(x: (width * 0.3843), y: (width * 0.6984)), controlPoint2: CGPoint(x: (width * 0.4074), y: (width * 0.6925)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4990), y: (width * 0.6088)), controlPoint1: CGPoint(x: (width * 0.4638), y: (width * 0.6640)), controlPoint2: CGPoint(x: (width * 0.4877), y: (width * 0.6356)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5021), y: (width * 0.6119)), controlPoint1: CGPoint(x: (width * 0.5000), y: (width * 0.6097)), controlPoint2: CGPoint(x: (width * 0.5010), y: (width * 0.6108)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5357), y: (width * 0.6304)), controlPoint1: CGPoint(x: (width * 0.5087), y: (width * 0.6176)), controlPoint2: CGPoint(x: (width * 0.5192), y: (width * 0.6262)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5488), y: (width * 0.6325)), controlPoint1: CGPoint(x: (width * 0.5398), y: (width * 0.6312)), controlPoint2: CGPoint(x: (width * 0.5442), y: (width * 0.6325)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5558), y: (width * 0.6330)), controlPoint1: CGPoint(x: (width * 0.5511), y: (width * 0.6327)), controlPoint2: CGPoint(x: (width * 0.5534), y: (width * 0.6329)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5630), y: (width * 0.6329)), controlPoint1: CGPoint(x: (width * 0.5582), y: (width * 0.6332)), controlPoint2: CGPoint(x: (width * 0.5605), y: (width * 0.6329)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5705), y: (width * 0.6324)), controlPoint1: CGPoint(x: (width * 0.5654), y: (width * 0.6327)), controlPoint2: CGPoint(x: (width * 0.5679), y: (width * 0.6326)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5779), y: (width * 0.6313)), controlPoint1: CGPoint(x: (width * 0.5729), y: (width * 0.6320)), controlPoint2: CGPoint(x: (width * 0.5754), y: (width * 0.6317)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5936), y: (width * 0.6281)), controlPoint1: CGPoint(x: (width * 0.5830), y: (width * 0.6307)), controlPoint2: CGPoint(x: (width * 0.5882), y: (width * 0.6294)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6260), y: (width * 0.6132)), controlPoint1: CGPoint(x: (width * 0.6043), y: (width * 0.6251)), controlPoint2: CGPoint(x: (width * 0.6155), y: (width * 0.6204)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6530), y: (width * 0.5841)), controlPoint1: CGPoint(x: (width * 0.6365), y: (width * 0.6061)), controlPoint2: CGPoint(x: (width * 0.6461), y: (width * 0.5961)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6641), y: (width * 0.5520)), controlPoint1: CGPoint(x: (width * 0.6589), y: (width * 0.5739)), controlPoint2: CGPoint(x: (width * 0.6624), y: (width * 0.5628)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6649), y: (width * 0.5527)), controlPoint1: CGPoint(x: (width * 0.6643), y: (width * 0.5523)), controlPoint2: CGPoint(x: (width * 0.6646), y: (width * 0.5525)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6746), y: (width * 0.5598)), controlPoint1: CGPoint(x: (width * 0.6677), y: (width * 0.5551)), controlPoint2: CGPoint(x: (width * 0.6710), y: (width * 0.5573)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7018), y: (width * 0.5714)), controlPoint1: CGPoint(x: (width * 0.6820), y: (width * 0.5642)), controlPoint2: CGPoint(x: (width * 0.6911), y: (width * 0.5685)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7777), y: (width * 0.5730)), controlPoint1: CGPoint(x: (width * 0.7237), y: (width * 0.5765)), controlPoint2: CGPoint(x: (width * 0.7492), y: (width * 0.5770)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8653), y: (width * 0.5393)), controlPoint1: CGPoint(x: (width * 0.8060), y: (width * 0.5688)), controlPoint2: CGPoint(x: (width * 0.8371), y: (width * 0.5589)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9014), y: (width * 0.5042)), controlPoint1: CGPoint(x: (width * 0.8793), y: (width * 0.5296)), controlPoint2: CGPoint(x: (width * 0.8918), y: (width * 0.5177)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9224), y: (width * 0.4630)), controlPoint1: CGPoint(x: (width * 0.9109), y: (width * 0.4907)), controlPoint2: CGPoint(x: (width * 0.9175), y: (width * 0.4768)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9279), y: (width * 0.4437)), controlPoint1: CGPoint(x: (width * 0.9247), y: (width * 0.4565)), controlPoint2: CGPoint(x: (width * 0.9265), y: (width * 0.4500)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9332), y: (width * 0.4407)), controlPoint1: CGPoint(x: (width * 0.9294), y: (width * 0.4428)), controlPoint2: CGPoint(x: (width * 0.9311), y: (width * 0.4419)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9629), y: (width * 0.4217)), controlPoint1: CGPoint(x: (width * 0.9405), y: (width * 0.4367)), controlPoint2: CGPoint(x: (width * 0.9508), y: (width * 0.4306)))
        bezierPath.addCurve(to: CGPoint(x: (width * 1.0016), y: (width * 0.3848)), controlPoint1: CGPoint(x: (width * 0.9749), y: (width * 0.4127)), controlPoint2: CGPoint(x: (width * 0.9888), y: (width * 0.4010)))
        bezierPath.addCurve(to: CGPoint(x: (width * 1.0190), y: (width * 0.3571)), controlPoint1: CGPoint(x: (width * 1.0081), y: (width * 0.3769)), controlPoint2: CGPoint(x: (width * 1.0140), y: (width * 0.3675)))
        bezierPath.addCurve(to: CGPoint(x: (width * 1.0296), y: (width * 0.3226)), controlPoint1: CGPoint(x: (width * 1.0240), y: (width * 0.3467)), controlPoint2: CGPoint(x: (width * 1.0280), y: (width * 0.3349)))
        bezierPath.addCurve(to: CGPoint(x: (width * 1.0201), y: (width * 0.2546)), controlPoint1: CGPoint(x: (width * 1.0334), y: (width * 0.2979)), controlPoint2: CGPoint(x: (width * 1.0287), y: (width * 0.2736)))
        bezierPath.close()
        shape.path = bezierPath.cgPath
        shape.fillColor = whiteColor.cgColor
        cloudLayer = shape
        
        //// Oval Drawing
        let ovalShape = CAShapeLayer()
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: (width * 0.1289), y: (width * 0.6914), width: (width * 0.1376), height: (width * 0.1376)))
        ovalShape.path = ovalPath.cgPath
        ovalShape.fillColor = blackColor.cgColor
        
        
        //// Oval 2 Drawing
        let oval2Shape = CAShapeLayer()
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.1553), y: (width * 0.7213), width: (width * 0.0991), height: (width * 0.0991)))
        oval2Shape.path = oval2Path.cgPath
        oval2Shape.fillColor = whiteColor.cgColor
        
        
        //// Oval 3 Drawing
        let oval3Shape = CAShapeLayer()
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2026), y: (width * 0.8491), width: (width * 0.0981), height: (width * 0.0981)))
        oval3Shape.path = oval3Path.cgPath
        oval3Shape.fillColor = blackColor.cgColor
        
        
        //// Oval 4 Drawing
        let oval4Shape = CAShapeLayer()
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2241), y: (width * 0.8591), width: (width * 0.0606), height: (width * 0.0606)))
        oval4Shape.path = oval4Path.cgPath
        oval4Shape.fillColor = whiteColor.cgColor
        
        
        //// Oval 5 Drawing
        let oval5Shape = CAShapeLayer()
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2876), y: (width * 0.9477), width: (width * 0.0534), height: (width * 0.0534)))
        oval5Shape.path = oval5Path.cgPath
        oval5Shape.fillColor = blackColor.cgColor
        
        //// Oval 6 Drawing
        let oval6Shape = CAShapeLayer()
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.3009), y: (width * 0.9625), width: (width * 0.0323), height: (width * 0.0323)))
        oval6Shape.path = oval6Path.cgPath
        oval6Shape.fillColor = whiteColor.cgColor
        
        return [shape, shape2, ovalShape, oval2Shape, oval3Shape, oval4Shape, oval5Shape, oval6Shape]
    }

}
