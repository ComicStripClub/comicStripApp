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
        comicFrame.addElement(self)
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
        
        delegate = self
        font = UIFont(name: "BackIssuesBB-Italic", size: 14.0)
        textAlignment = .center
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        adjustsFontForContentSizeCategory = true
        backgroundColor = UIColor.clear
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.widthTracksTextView = true
        contentOffset = CGPoint.zero
        clipsToBounds = false
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
        verticallyCenter()
    }
    
    override var contentSize: CGSize {
        didSet {
            verticallyCenter()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        verticallyCenter()
    }
    
    private func verticallyCenter(){
        let sizeOfText = sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
        if let cloudHeight = cloudLayer?.path?.boundingBox.height {
            let lineHeight = font?.lineHeight ?? 0
            var topCorrection = (cloudHeight - sizeOfText.height * zoomScale) / 2.0 - lineHeight / 2.0
            topCorrection = max(0, topCorrection)
            textContainer.exclusionPaths = [
                UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: topCorrection))),
                ThoughtBubble.getExclusionPath(width: bounds.width)
            ]
            if (bounds.height > bounds.width) {
                textContainer.exclusionPaths.append(UIBezierPath(rect: CGRect(x: 0, y: bounds.width, width: bounds.width, height: bounds.height - bounds.width)))
            }
        }
    }

    private class func getExclusionPath(width: CGFloat) -> UIBezierPath {
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: (width * 0.9668), y: (width * 0.2551)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9705), y: (width * 0.3087)), controlPoint1: CGPoint(x: (width * 0.9715), y: (width * 0.2716)), controlPoint2: CGPoint(x: (width * 0.9733), y: (width * 0.2899)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8705), y: (width * 0.3343)), controlPoint1: CGPoint(x: (width * 0.9679), y: (width * 0.3274)), controlPoint2: CGPoint(x: (width * 0.8706), y: (width * 0.3402)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8866), y: (width * 0.3912)), controlPoint1: CGPoint(x: (width * 0.8704), y: (width * 0.3314)), controlPoint2: CGPoint(x: (width * 0.8869), y: (width * 0.3887)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8838), y: (width * 0.4069)), controlPoint1: CGPoint(x: (width * 0.8858), y: (width * 0.3963)), controlPoint2: CGPoint(x: (width * 0.8852), y: (width * 0.4016)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8723), y: (width * 0.4401)), controlPoint1: CGPoint(x: (width * 0.8813), y: (width * 0.4177)), controlPoint2: CGPoint(x: (width * 0.8777), y: (width * 0.4289)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8525), y: (width * 0.4727)), controlPoint1: CGPoint(x: (width * 0.8671), y: (width * 0.4513)), controlPoint2: CGPoint(x: (width * 0.8605), y: (width * 0.4626)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8230), y: (width * 0.4998)), controlPoint1: CGPoint(x: (width * 0.8445), y: (width * 0.4827)), controlPoint2: CGPoint(x: (width * 0.8345), y: (width * 0.4918)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.7496), y: (width * 0.5322)), controlPoint1: CGPoint(x: (width * 0.8000), y: (width * 0.5157)), controlPoint2: CGPoint(x: (width * 0.7740), y: (width * 0.5261)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.7142), y: (width * 0.5389)), controlPoint1: CGPoint(x: (width * 0.7373), y: (width * 0.5353)), controlPoint2: CGPoint(x: (width * 0.7255), y: (width * 0.5375)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6832), y: (width * 0.5402)), controlPoint1: CGPoint(x: (width * 0.7029), y: (width * 0.5400)), controlPoint2: CGPoint(x: (width * 0.6923), y: (width * 0.5409)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6583), y: (width * 0.5348)), controlPoint1: CGPoint(x: (width * 0.6738), y: (width * 0.5394)), controlPoint2: CGPoint(x: (width * 0.6655), y: (width * 0.5373)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6485), y: (width * 0.5306)), controlPoint1: CGPoint(x: (width * 0.6548), y: (width * 0.5334)), controlPoint2: CGPoint(x: (width * 0.6514), y: (width * 0.5321)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6449), y: (width * 0.5286)), controlPoint1: CGPoint(x: (width * 0.6473), y: (width * 0.5299)), controlPoint2: CGPoint(x: (width * 0.6461), y: (width * 0.5293)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6431), y: (width * 0.4960)), controlPoint1: CGPoint(x: (width * 0.6460), y: (width * 0.5171)), controlPoint2: CGPoint(x: (width * 0.6451), y: (width * 0.5061)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6084), y: (width * 0.4518)), controlPoint1: CGPoint(x: (width * 0.6387), y: (width * 0.4749)), controlPoint2: CGPoint(x: (width * 0.6034), y: (width * 0.4384)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6193), y: (width * 0.4993)), controlPoint1: CGPoint(x: (width * 0.6135), y: (width * 0.4651)), controlPoint2: CGPoint(x: (width * 0.6181), y: (width * 0.4815)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.6086), y: (width * 0.5523)), controlPoint1: CGPoint(x: (width * 0.6204), y: (width * 0.5170)), controlPoint2: CGPoint(x: (width * 0.6181), y: (width * 0.5363)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5679), y: (width * 0.5865)), controlPoint1: CGPoint(x: (width * 0.5996), y: (width * 0.5686)), controlPoint2: CGPoint(x: (width * 0.5841), y: (width * 0.5794)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5555), y: (width * 0.5910)), controlPoint1: CGPoint(x: (width * 0.5638), y: (width * 0.5881)), controlPoint2: CGPoint(x: (width * 0.5597), y: (width * 0.5898)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5494), y: (width * 0.5931)), controlPoint1: CGPoint(x: (width * 0.5535), y: (width * 0.5917)), controlPoint2: CGPoint(x: (width * 0.5514), y: (width * 0.5924)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5435), y: (width * 0.5945)), controlPoint1: CGPoint(x: (width * 0.5474), y: (width * 0.5936)), controlPoint2: CGPoint(x: (width * 0.5455), y: (width * 0.5940)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5377), y: (width * 0.5958)), controlPoint1: CGPoint(x: (width * 0.5416), y: (width * 0.5949)), controlPoint2: CGPoint(x: (width * 0.5396), y: (width * 0.5956)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5322), y: (width * 0.5967)), controlPoint1: CGPoint(x: (width * 0.5358), y: (width * 0.5961)), controlPoint2: CGPoint(x: (width * 0.5340), y: (width * 0.5964)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.5216), y: (width * 0.5973)), controlPoint1: CGPoint(x: (width * 0.5285), y: (width * 0.5974)), controlPoint2: CGPoint(x: (width * 0.5250), y: (width * 0.5971)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.4895), y: (width * 0.5898)), controlPoint1: CGPoint(x: (width * 0.5080), y: (width * 0.5973)), controlPoint2: CGPoint(x: (width * 0.4970), y: (width * 0.5930)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.4852), y: (width * 0.5876)), controlPoint1: CGPoint(x: (width * 0.4879), y: (width * 0.5890)), controlPoint2: CGPoint(x: (width * 0.4865), y: (width * 0.5883)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.4904), y: (width * 0.5696)), controlPoint1: CGPoint(x: (width * 0.4876), y: (width * 0.5814)), controlPoint2: CGPoint(x: (width * 0.4893), y: (width * 0.5754)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.4767), y: (width * 0.5656)), controlPoint1: CGPoint(x: (width * 0.4849), y: (width * 0.5030)), controlPoint2: CGPoint(x: (width * 0.4820), y: (width * 0.5535)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.3581), y: (width * 0.5769)), controlPoint1: CGPoint(x: (width * 0.4711), y: (width * 0.5777)), controlPoint2: CGPoint(x: (width * 0.3608), y: (width * 0.5748)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1355), y: (width * 0.5783)), controlPoint1: CGPoint(x: (width * 0.3554), y: (width * 0.5790)), controlPoint2: CGPoint(x: (width * 0.1355), y: (width * 0.5783)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1031), y: (width * 0.5095)), controlPoint1: CGPoint(x: (width * 0.1117), y: (width * 0.5567)), controlPoint2: CGPoint(x: (width * 0.1063), y: (width * 0.5363)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1023), y: (width * 0.4995)), controlPoint1: CGPoint(x: (width * 0.1029), y: (width * 0.5061)), controlPoint2: CGPoint(x: (width * 0.1022), y: (width * 0.5027)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1026), y: (width * 0.4896)), controlPoint1: CGPoint(x: (width * 0.1024), y: (width * 0.4961)), controlPoint2: CGPoint(x: (width * 0.1025), y: (width * 0.4929)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1040), y: (width * 0.4802)), controlPoint1: CGPoint(x: (width * 0.1028), y: (width * 0.4864)), controlPoint2: CGPoint(x: (width * 0.1036), y: (width * 0.4833)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1048), y: (width * 0.4755)), controlPoint1: CGPoint(x: (width * 0.1043), y: (width * 0.4786)), controlPoint2: CGPoint(x: (width * 0.1044), y: (width * 0.4770)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1060), y: (width * 0.4707)), controlPoint1: CGPoint(x: (width * 0.1052), y: (width * 0.4739)), controlPoint2: CGPoint(x: (width * 0.1056), y: (width * 0.4723)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1355), y: (width * 0.3916)), controlPoint1: CGPoint(x: (width * 0.1090), y: (width * 0.4581)), controlPoint2: CGPoint(x: (width * 0.1314), y: (width * 0.4020)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0446), y: (width * 0.3887)), controlPoint1: CGPoint(x: (width * 0.1353), y: (width * 0.3920)), controlPoint2: CGPoint(x: (width * 0.0452), y: (width * 0.3886)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0289), y: (width * 0.3351)), controlPoint1: CGPoint(x: (width * 0.0370), y: (width * 0.3730)), controlPoint2: CGPoint(x: (width * 0.0310), y: (width * 0.3543)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0338), y: (width * 0.2799)), controlPoint1: CGPoint(x: (width * 0.0269), y: (width * 0.3157)), controlPoint2: CGPoint(x: (width * 0.0291), y: (width * 0.2964)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0833), y: (width * 0.2502)), controlPoint1: CGPoint(x: (width * 0.0387), y: (width * 0.2635)), controlPoint2: CGPoint(x: (width * 0.0827), y: (width * 0.2477)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0841), y: (width * 0.2539)), controlPoint1: CGPoint(x: (width * 0.0838), y: (width * 0.2527)), controlPoint2: CGPoint(x: (width * 0.0841), y: (width * 0.2539)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0845), y: (width * 0.2501)), controlPoint1: CGPoint(x: (width * 0.0841), y: (width * 0.2539)), controlPoint2: CGPoint(x: (width * 0.0842), y: (width * 0.2526)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0857), y: (width * 0.2391)), controlPoint1: CGPoint(x: (width * 0.0847), y: (width * 0.2476)), controlPoint2: CGPoint(x: (width * 0.0850), y: (width * 0.2438)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0908), y: (width * 0.2129)), controlPoint1: CGPoint(x: (width * 0.0866), y: (width * 0.2323)), controlPoint2: CGPoint(x: (width * 0.0881), y: (width * 0.2233)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0910), y: (width * 0.2127)), controlPoint1: CGPoint(x: (width * 0.0909), y: (width * 0.2128)), controlPoint2: CGPoint(x: (width * 0.0910), y: (width * 0.2127)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0908), y: (width * 0.2128)), controlPoint1: CGPoint(x: (width * 0.0910), y: (width * 0.2127)), controlPoint2: CGPoint(x: (width * 0.0909), y: (width * 0.2128)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.0945), y: (width * 0.2003)), controlPoint1: CGPoint(x: (width * 0.0918), y: (width * 0.2088)), controlPoint2: CGPoint(x: (width * 0.0930), y: (width * 0.2046)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.1201), y: (width * 0.1500)), controlPoint1: CGPoint(x: (width * 0.0995), y: (width * 0.1846)), controlPoint2: CGPoint(x: (width * 0.1078), y: (width * 0.1668)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.2620), y: (width * 0.1627)), controlPoint1: CGPoint(x: (width * 0.1205), y: (width * 0.1506)), controlPoint2: CGPoint(x: (width * 0.2620), y: (width * 0.1627)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.2922), y: (width * 0.1084)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.8404), y: (width * 0.1114)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8702), y: (width * 0.1311)), controlPoint1: CGPoint(x: (width * 0.8506), y: (width * 0.1173)), controlPoint2: CGPoint(x: (width * 0.8615), y: (width * 0.1239)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8827), y: (width * 0.1423)), controlPoint1: CGPoint(x: (width * 0.8745), y: (width * 0.1348)), controlPoint2: CGPoint(x: (width * 0.8788), y: (width * 0.1385)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.8856), y: (width * 0.1452)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8882), y: (width * 0.1479)), controlPoint1: CGPoint(x: (width * 0.8866), y: (width * 0.1461)), controlPoint2: CGPoint(x: (width * 0.8873), y: (width * 0.1470)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.8931), y: (width * 0.1537)), controlPoint1: CGPoint(x: (width * 0.8899), y: (width * 0.1497)), controlPoint2: CGPoint(x: (width * 0.8915), y: (width * 0.1517)))
        bezier3Path.addCurve(to: CGPoint(x: (width * 0.9668), y: (width * 0.2551)), controlPoint1: CGPoint(x: (width * 0.9057), y: (width * 0.1698)), controlPoint2: CGPoint(x: (width * 0.9624), y: (width * 0.2385)))
        bezier3Path.close()
        
        bezier3Path.move(to: CGPoint(x: (width * 1.0000), y: (width * 0.00)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 0.00)))
        bezier3Path.addLine(to: CGPoint(x: (width * 0.0000), y: (width * 1.00)))
        bezier3Path.addLine(to: CGPoint(x: (width * 1.0000), y: (width * 1.00)))
        bezier3Path.addLine(to: CGPoint(x: (width * 1.0000), y: (width * 0.00)))
        
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
        bezier2Path.move(to: CGPoint(x: (width * 0.9668), y: (width * 0.2551)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9705), y: (width * 0.3087)), controlPoint1: CGPoint(x: (width * 0.9715), y: (width * 0.2716)), controlPoint2: CGPoint(x: (width * 0.9733), y: (width * 0.2899)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9517), y: (width * 0.3597)), controlPoint1: CGPoint(x: (width * 0.9679), y: (width * 0.3274)), controlPoint2: CGPoint(x: (width * 0.9605), y: (width * 0.3445)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9241), y: (width * 0.3987)), controlPoint1: CGPoint(x: (width * 0.9429), y: (width * 0.3748)), controlPoint2: CGPoint(x: (width * 0.9329), y: (width * 0.3878)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9023), y: (width * 0.4240)), controlPoint1: CGPoint(x: (width * 0.9153), y: (width * 0.4095)), controlPoint2: CGPoint(x: (width * 0.9077), y: (width * 0.4180)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9008), y: (width * 0.4257)), controlPoint1: CGPoint(x: (width * 0.9018), y: (width * 0.4246)), controlPoint2: CGPoint(x: (width * 0.9013), y: (width * 0.4252)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9030), y: (width * 0.4098)), controlPoint1: CGPoint(x: (width * 0.9018), y: (width * 0.4203)), controlPoint2: CGPoint(x: (width * 0.9026), y: (width * 0.4150)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9034), y: (width * 0.3916)), controlPoint1: CGPoint(x: (width * 0.9037), y: (width * 0.4036)), controlPoint2: CGPoint(x: (width * 0.9035), y: (width * 0.3974)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9026), y: (width * 0.3830)), controlPoint1: CGPoint(x: (width * 0.9033), y: (width * 0.3887)), controlPoint2: CGPoint(x: (width * 0.9029), y: (width * 0.3858)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9013), y: (width * 0.3749)), controlPoint1: CGPoint(x: (width * 0.9023), y: (width * 0.3802)), controlPoint2: CGPoint(x: (width * 0.9020), y: (width * 0.3775)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8995), y: (width * 0.3673)), controlPoint1: CGPoint(x: (width * 0.9007), y: (width * 0.3723)), controlPoint2: CGPoint(x: (width * 0.9001), y: (width * 0.3697)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8971), y: (width * 0.3602)), controlPoint1: CGPoint(x: (width * 0.8988), y: (width * 0.3648)), controlPoint2: CGPoint(x: (width * 0.8979), y: (width * 0.3624)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8914), y: (width * 0.3479)), controlPoint1: CGPoint(x: (width * 0.8957), y: (width * 0.3556)), controlPoint2: CGPoint(x: (width * 0.8933), y: (width * 0.3516)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8899), y: (width * 0.3452)), controlPoint1: CGPoint(x: (width * 0.8909), y: (width * 0.3470)), controlPoint2: CGPoint(x: (width * 0.8904), y: (width * 0.3461)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8882), y: (width * 0.3427)), controlPoint1: CGPoint(x: (width * 0.8894), y: (width * 0.3443)), controlPoint2: CGPoint(x: (width * 0.8887), y: (width * 0.3435)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8848), y: (width * 0.3382)), controlPoint1: CGPoint(x: (width * 0.8870), y: (width * 0.3411)), controlPoint2: CGPoint(x: (width * 0.8859), y: (width * 0.3396)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8783), y: (width * 0.3310)), controlPoint1: CGPoint(x: (width * 0.8829), y: (width * 0.3352)), controlPoint2: CGPoint(x: (width * 0.8803), y: (width * 0.3331)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8680), y: (width * 0.3227)), controlPoint1: CGPoint(x: (width * 0.8743), y: (width * 0.3267)), controlPoint2: CGPoint(x: (width * 0.8704), y: (width * 0.3245)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8642), y: (width * 0.3202)), controlPoint1: CGPoint(x: (width * 0.8655), y: (width * 0.3211)), controlPoint2: CGPoint(x: (width * 0.8642), y: (width * 0.3202)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8672), y: (width * 0.3237)), controlPoint1: CGPoint(x: (width * 0.8642), y: (width * 0.3202)), controlPoint2: CGPoint(x: (width * 0.8652), y: (width * 0.3214)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8748), y: (width * 0.3338)), controlPoint1: CGPoint(x: (width * 0.8690), y: (width * 0.3260)), controlPoint2: CGPoint(x: (width * 0.8721), y: (width * 0.3290)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8872), y: (width * 0.3766)), controlPoint1: CGPoint(x: (width * 0.8809), y: (width * 0.3429)), controlPoint2: CGPoint(x: (width * 0.8868), y: (width * 0.3578)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8871), y: (width * 0.3837)), controlPoint1: CGPoint(x: (width * 0.8874), y: (width * 0.3789)), controlPoint2: CGPoint(x: (width * 0.8873), y: (width * 0.3813)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8866), y: (width * 0.3912)), controlPoint1: CGPoint(x: (width * 0.8869), y: (width * 0.3862)), controlPoint2: CGPoint(x: (width * 0.8869), y: (width * 0.3887)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8838), y: (width * 0.4069)), controlPoint1: CGPoint(x: (width * 0.8858), y: (width * 0.3963)), controlPoint2: CGPoint(x: (width * 0.8852), y: (width * 0.4016)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8723), y: (width * 0.4401)), controlPoint1: CGPoint(x: (width * 0.8813), y: (width * 0.4177)), controlPoint2: CGPoint(x: (width * 0.8777), y: (width * 0.4289)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8525), y: (width * 0.4727)), controlPoint1: CGPoint(x: (width * 0.8671), y: (width * 0.4513)), controlPoint2: CGPoint(x: (width * 0.8605), y: (width * 0.4626)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8230), y: (width * 0.4998)), controlPoint1: CGPoint(x: (width * 0.8445), y: (width * 0.4827)), controlPoint2: CGPoint(x: (width * 0.8345), y: (width * 0.4918)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7496), y: (width * 0.5322)), controlPoint1: CGPoint(x: (width * 0.8000), y: (width * 0.5157)), controlPoint2: CGPoint(x: (width * 0.7740), y: (width * 0.5261)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7142), y: (width * 0.5389)), controlPoint1: CGPoint(x: (width * 0.7373), y: (width * 0.5353)), controlPoint2: CGPoint(x: (width * 0.7255), y: (width * 0.5375)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6832), y: (width * 0.5402)), controlPoint1: CGPoint(x: (width * 0.7029), y: (width * 0.5400)), controlPoint2: CGPoint(x: (width * 0.6923), y: (width * 0.5409)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6583), y: (width * 0.5348)), controlPoint1: CGPoint(x: (width * 0.6738), y: (width * 0.5394)), controlPoint2: CGPoint(x: (width * 0.6655), y: (width * 0.5373)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6485), y: (width * 0.5306)), controlPoint1: CGPoint(x: (width * 0.6548), y: (width * 0.5334)), controlPoint2: CGPoint(x: (width * 0.6514), y: (width * 0.5321)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6449), y: (width * 0.5286)), controlPoint1: CGPoint(x: (width * 0.6473), y: (width * 0.5299)), controlPoint2: CGPoint(x: (width * 0.6461), y: (width * 0.5293)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6084), y: (width * 0.4488)), controlPoint1: CGPoint(x: (width * 0.6446), y: (width * 0.4819)), controlPoint2: CGPoint(x: (width * 0.6084), y: (width * 0.4488)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6193), y: (width * 0.4993)), controlPoint1: CGPoint(x: (width * 0.6135), y: (width * 0.4621)), controlPoint2: CGPoint(x: (width * 0.6181), y: (width * 0.4815)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6086), y: (width * 0.5523)), controlPoint1: CGPoint(x: (width * 0.6204), y: (width * 0.5170)), controlPoint2: CGPoint(x: (width * 0.6181), y: (width * 0.5363)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5679), y: (width * 0.5865)), controlPoint1: CGPoint(x: (width * 0.5996), y: (width * 0.5686)), controlPoint2: CGPoint(x: (width * 0.5841), y: (width * 0.5794)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5555), y: (width * 0.5910)), controlPoint1: CGPoint(x: (width * 0.5638), y: (width * 0.5881)), controlPoint2: CGPoint(x: (width * 0.5597), y: (width * 0.5898)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5494), y: (width * 0.5931)), controlPoint1: CGPoint(x: (width * 0.5535), y: (width * 0.5917)), controlPoint2: CGPoint(x: (width * 0.5514), y: (width * 0.5924)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5435), y: (width * 0.5945)), controlPoint1: CGPoint(x: (width * 0.5474), y: (width * 0.5936)), controlPoint2: CGPoint(x: (width * 0.5455), y: (width * 0.5940)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5377), y: (width * 0.5958)), controlPoint1: CGPoint(x: (width * 0.5416), y: (width * 0.5949)), controlPoint2: CGPoint(x: (width * 0.5396), y: (width * 0.5956)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5322), y: (width * 0.5967)), controlPoint1: CGPoint(x: (width * 0.5358), y: (width * 0.5961)), controlPoint2: CGPoint(x: (width * 0.5340), y: (width * 0.5964)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5216), y: (width * 0.5973)), controlPoint1: CGPoint(x: (width * 0.5285), y: (width * 0.5974)), controlPoint2: CGPoint(x: (width * 0.5250), y: (width * 0.5971)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4895), y: (width * 0.5898)), controlPoint1: CGPoint(x: (width * 0.5080), y: (width * 0.5973)), controlPoint2: CGPoint(x: (width * 0.4970), y: (width * 0.5930)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4852), y: (width * 0.5876)), controlPoint1: CGPoint(x: (width * 0.4879), y: (width * 0.5890)), controlPoint2: CGPoint(x: (width * 0.4865), y: (width * 0.5883)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4904), y: (width * 0.5696)), controlPoint1: CGPoint(x: (width * 0.4876), y: (width * 0.5814)), controlPoint2: CGPoint(x: (width * 0.4893), y: (width * 0.5754)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4875), y: (width * 0.5336)), controlPoint1: CGPoint(x: (width * 0.4930), y: (width * 0.5541)), controlPoint2: CGPoint(x: (width * 0.4908), y: (width * 0.5414)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4866), y: (width * 0.5308)), controlPoint1: CGPoint(x: (width * 0.4872), y: (width * 0.5326)), controlPoint2: CGPoint(x: (width * 0.4869), y: (width * 0.5317)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4854), y: (width * 0.5285)), controlPoint1: CGPoint(x: (width * 0.4861), y: (width * 0.5300)), controlPoint2: CGPoint(x: (width * 0.4857), y: (width * 0.5292)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4835), y: (width * 0.5249)), controlPoint1: CGPoint(x: (width * 0.4846), y: (width * 0.5271)), controlPoint2: CGPoint(x: (width * 0.4840), y: (width * 0.5259)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4819), y: (width * 0.5221)), controlPoint1: CGPoint(x: (width * 0.4824), y: (width * 0.5231)), controlPoint2: CGPoint(x: (width * 0.4819), y: (width * 0.5221)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4823), y: (width * 0.5254)), controlPoint1: CGPoint(x: (width * 0.4819), y: (width * 0.5221)), controlPoint2: CGPoint(x: (width * 0.4820), y: (width * 0.5232)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4828), y: (width * 0.5292)), controlPoint1: CGPoint(x: (width * 0.4824), y: (width * 0.5264)), controlPoint2: CGPoint(x: (width * 0.4826), y: (width * 0.5277)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4832), y: (width * 0.5317)), controlPoint1: CGPoint(x: (width * 0.4830), y: (width * 0.5300)), controlPoint2: CGPoint(x: (width * 0.4830), y: (width * 0.5308)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4832), y: (width * 0.5345)), controlPoint1: CGPoint(x: (width * 0.4832), y: (width * 0.5325)), controlPoint2: CGPoint(x: (width * 0.4832), y: (width * 0.5335)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4767), y: (width * 0.5656)), controlPoint1: CGPoint(x: (width * 0.4837), y: (width * 0.5423)), controlPoint2: CGPoint(x: (width * 0.4820), y: (width * 0.5535)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4493), y: (width * 0.6029)), controlPoint1: CGPoint(x: (width * 0.4711), y: (width * 0.5777)), controlPoint2: CGPoint(x: (width * 0.4620), y: (width * 0.5907)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4283), y: (width * 0.6205)), controlPoint1: CGPoint(x: (width * 0.4431), y: (width * 0.6091)), controlPoint2: CGPoint(x: (width * 0.4359), y: (width * 0.6149)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4163), y: (width * 0.6285)), controlPoint1: CGPoint(x: (width * 0.4245), y: (width * 0.6234)), controlPoint2: CGPoint(x: (width * 0.4204), y: (width * 0.6259)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4101), y: (width * 0.6321)), controlPoint1: CGPoint(x: (width * 0.4142), y: (width * 0.6297)), controlPoint2: CGPoint(x: (width * 0.4122), y: (width * 0.6309)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4033), y: (width * 0.6356)), controlPoint1: CGPoint(x: (width * 0.4078), y: (width * 0.6333)), controlPoint2: CGPoint(x: (width * 0.4056), y: (width * 0.6345)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3498), y: (width * 0.6541)), controlPoint1: CGPoint(x: (width * 0.3852), y: (width * 0.6448)), controlPoint2: CGPoint(x: (width * 0.3670), y: (width * 0.6511)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3032), y: (width * 0.6547)), controlPoint1: CGPoint(x: (width * 0.3326), y: (width * 0.6574)), controlPoint2: CGPoint(x: (width * 0.3166), y: (width * 0.6569)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2717), y: (width * 0.6453)), controlPoint1: CGPoint(x: (width * 0.2897), y: (width * 0.6524)), controlPoint2: CGPoint(x: (width * 0.2790), y: (width * 0.6485)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2663), y: (width * 0.6427)), controlPoint1: CGPoint(x: (width * 0.2695), y: (width * 0.6444)), controlPoint2: CGPoint(x: (width * 0.2678), y: (width * 0.6435)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2702), y: (width * 0.6415)), controlPoint1: CGPoint(x: (width * 0.2676), y: (width * 0.6423)), controlPoint2: CGPoint(x: (width * 0.2689), y: (width * 0.6420)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3062), y: (width * 0.6248)), controlPoint1: CGPoint(x: (width * 0.2841), y: (width * 0.6372)), controlPoint2: CGPoint(x: (width * 0.2960), y: (width * 0.6311)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3491), y: (width * 0.5890)), controlPoint1: CGPoint(x: (width * 0.3266), y: (width * 0.6120)), controlPoint2: CGPoint(x: (width * 0.3401), y: (width * 0.5985)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3590), y: (width * 0.5777)), controlPoint1: CGPoint(x: (width * 0.3535), y: (width * 0.5842)), controlPoint2: CGPoint(x: (width * 0.3568), y: (width * 0.5804)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3623), y: (width * 0.5737)), controlPoint1: CGPoint(x: (width * 0.3611), y: (width * 0.5751)), controlPoint2: CGPoint(x: (width * 0.3623), y: (width * 0.5737)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3581), y: (width * 0.5769)), controlPoint1: CGPoint(x: (width * 0.3623), y: (width * 0.5737)), controlPoint2: CGPoint(x: (width * 0.3608), y: (width * 0.5748)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3461), y: (width * 0.5857)), controlPoint1: CGPoint(x: (width * 0.3554), y: (width * 0.5790)), controlPoint2: CGPoint(x: (width * 0.3514), y: (width * 0.5820)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2996), y: (width * 0.6123)), controlPoint1: CGPoint(x: (width * 0.3356), y: (width * 0.5930)), controlPoint2: CGPoint(x: (width * 0.3201), y: (width * 0.6034)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2258), y: (width * 0.6239)), controlPoint1: CGPoint(x: (width * 0.2792), y: (width * 0.6209)), controlPoint2: CGPoint(x: (width * 0.2535), y: (width * 0.6275)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1455), y: (width * 0.5856)), controlPoint1: CGPoint(x: (width * 0.1984), y: (width * 0.6204)), controlPoint2: CGPoint(x: (width * 0.1693), y: (width * 0.6072)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1031), y: (width * 0.5095)), controlPoint1: CGPoint(x: (width * 0.1217), y: (width * 0.5640)), controlPoint2: CGPoint(x: (width * 0.1063), y: (width * 0.5363)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1023), y: (width * 0.4995)), controlPoint1: CGPoint(x: (width * 0.1029), y: (width * 0.5061)), controlPoint2: CGPoint(x: (width * 0.1022), y: (width * 0.5027)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1026), y: (width * 0.4896)), controlPoint1: CGPoint(x: (width * 0.1024), y: (width * 0.4961)), controlPoint2: CGPoint(x: (width * 0.1025), y: (width * 0.4929)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1040), y: (width * 0.4802)), controlPoint1: CGPoint(x: (width * 0.1028), y: (width * 0.4864)), controlPoint2: CGPoint(x: (width * 0.1036), y: (width * 0.4833)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1048), y: (width * 0.4755)), controlPoint1: CGPoint(x: (width * 0.1043), y: (width * 0.4786)), controlPoint2: CGPoint(x: (width * 0.1044), y: (width * 0.4770)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1060), y: (width * 0.4707)), controlPoint1: CGPoint(x: (width * 0.1052), y: (width * 0.4739)), controlPoint2: CGPoint(x: (width * 0.1056), y: (width * 0.4723)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1177), y: (width * 0.4363)), controlPoint1: CGPoint(x: (width * 0.1090), y: (width * 0.4581)), controlPoint2: CGPoint(x: (width * 0.1135), y: (width * 0.4467)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1446), y: (width * 0.3902)), controlPoint1: CGPoint(x: (width * 0.1265), y: (width * 0.4157)), controlPoint2: CGPoint(x: (width * 0.1366), y: (width * 0.4002)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1542), y: (width * 0.3789)), controlPoint1: CGPoint(x: (width * 0.1483), y: (width * 0.3850)), controlPoint2: CGPoint(x: (width * 0.1520), y: (width * 0.3816)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1577), y: (width * 0.3751)), controlPoint1: CGPoint(x: (width * 0.1565), y: (width * 0.3764)), controlPoint2: CGPoint(x: (width * 0.1577), y: (width * 0.3751)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1534), y: (width * 0.3780)), controlPoint1: CGPoint(x: (width * 0.1577), y: (width * 0.3751)), controlPoint2: CGPoint(x: (width * 0.1562), y: (width * 0.3761)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1414), y: (width * 0.3871)), controlPoint1: CGPoint(x: (width * 0.1507), y: (width * 0.3801)), controlPoint2: CGPoint(x: (width * 0.1462), y: (width * 0.3827)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1051), y: (width * 0.4297)), controlPoint1: CGPoint(x: (width * 0.1313), y: (width * 0.3955)), controlPoint2: CGPoint(x: (width * 0.1178), y: (width * 0.4094)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0964), y: (width * 0.4451)), controlPoint1: CGPoint(x: (width * 0.1022), y: (width * 0.4345)), controlPoint2: CGPoint(x: (width * 0.0993), y: (width * 0.4396)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0712), y: (width * 0.4271)), controlPoint1: CGPoint(x: (width * 0.0893), y: (width * 0.4419)), controlPoint2: CGPoint(x: (width * 0.0802), y: (width * 0.4360)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0446), y: (width * 0.3887)), controlPoint1: CGPoint(x: (width * 0.0616), y: (width * 0.4177)), controlPoint2: CGPoint(x: (width * 0.0521), y: (width * 0.4046)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0289), y: (width * 0.3351)), controlPoint1: CGPoint(x: (width * 0.0370), y: (width * 0.3730)), controlPoint2: CGPoint(x: (width * 0.0310), y: (width * 0.3543)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0338), y: (width * 0.2799)), controlPoint1: CGPoint(x: (width * 0.0269), y: (width * 0.3157)), controlPoint2: CGPoint(x: (width * 0.0291), y: (width * 0.2964)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0550), y: (width * 0.2393)), controlPoint1: CGPoint(x: (width * 0.0387), y: (width * 0.2635)), controlPoint2: CGPoint(x: (width * 0.0462), y: (width * 0.2494)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0796), y: (width * 0.2187)), controlPoint1: CGPoint(x: (width * 0.0636), y: (width * 0.2293)), controlPoint2: CGPoint(x: (width * 0.0727), y: (width * 0.2226)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0813), y: (width * 0.2391)), controlPoint1: CGPoint(x: (width * 0.0798), y: (width * 0.2268)), controlPoint2: CGPoint(x: (width * 0.0805), y: (width * 0.2337)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0833), y: (width * 0.2502)), controlPoint1: CGPoint(x: (width * 0.0819), y: (width * 0.2439)), controlPoint2: CGPoint(x: (width * 0.0827), y: (width * 0.2477)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0841), y: (width * 0.2539)), controlPoint1: CGPoint(x: (width * 0.0838), y: (width * 0.2527)), controlPoint2: CGPoint(x: (width * 0.0841), y: (width * 0.2539)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0845), y: (width * 0.2501)), controlPoint1: CGPoint(x: (width * 0.0841), y: (width * 0.2539)), controlPoint2: CGPoint(x: (width * 0.0842), y: (width * 0.2526)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0857), y: (width * 0.2391)), controlPoint1: CGPoint(x: (width * 0.0847), y: (width * 0.2476)), controlPoint2: CGPoint(x: (width * 0.0850), y: (width * 0.2438)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0908), y: (width * 0.2129)), controlPoint1: CGPoint(x: (width * 0.0866), y: (width * 0.2323)), controlPoint2: CGPoint(x: (width * 0.0881), y: (width * 0.2233)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0910), y: (width * 0.2127)), controlPoint1: CGPoint(x: (width * 0.0909), y: (width * 0.2128)), controlPoint2: CGPoint(x: (width * 0.0910), y: (width * 0.2127)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0908), y: (width * 0.2128)), controlPoint1: CGPoint(x: (width * 0.0910), y: (width * 0.2127)), controlPoint2: CGPoint(x: (width * 0.0909), y: (width * 0.2128)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0945), y: (width * 0.2003)), controlPoint1: CGPoint(x: (width * 0.0918), y: (width * 0.2088)), controlPoint2: CGPoint(x: (width * 0.0930), y: (width * 0.2046)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1201), y: (width * 0.1500)), controlPoint1: CGPoint(x: (width * 0.0995), y: (width * 0.1846)), controlPoint2: CGPoint(x: (width * 0.1078), y: (width * 0.1668)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1703), y: (width * 0.1073)), controlPoint1: CGPoint(x: (width * 0.1325), y: (width * 0.1332)), controlPoint2: CGPoint(x: (width * 0.1495), y: (width * 0.1177)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2345), y: (width * 0.0932)), controlPoint1: CGPoint(x: (width * 0.1911), y: (width * 0.0969)), controlPoint2: CGPoint(x: (width * 0.2136), y: (width * 0.0928)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2645), y: (width * 0.0963)), controlPoint1: CGPoint(x: (width * 0.2450), y: (width * 0.0935)), controlPoint2: CGPoint(x: (width * 0.2551), y: (width * 0.0944)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2784), y: (width * 0.0992)), controlPoint1: CGPoint(x: (width * 0.2692), y: (width * 0.0970)), controlPoint2: CGPoint(x: (width * 0.2739), y: (width * 0.0983)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2792), y: (width * 0.0994)), controlPoint1: CGPoint(x: (width * 0.2786), y: (width * 0.0993)), controlPoint2: CGPoint(x: (width * 0.2789), y: (width * 0.0993)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2713), y: (width * 0.1179)), controlPoint1: CGPoint(x: (width * 0.2760), y: (width * 0.1059)), controlPoint2: CGPoint(x: (width * 0.2734), y: (width * 0.1121)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2624), y: (width * 0.1498)), controlPoint1: CGPoint(x: (width * 0.2664), y: (width * 0.1311)), controlPoint2: CGPoint(x: (width * 0.2638), y: (width * 0.1421)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2606), y: (width * 0.1617)), controlPoint1: CGPoint(x: (width * 0.2610), y: (width * 0.1574)), controlPoint2: CGPoint(x: (width * 0.2606), y: (width * 0.1617)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2666), y: (width * 0.1513)), controlPoint1: CGPoint(x: (width * 0.2606), y: (width * 0.1617)), controlPoint2: CGPoint(x: (width * 0.2627), y: (width * 0.1580)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2839), y: (width * 0.1244)), controlPoint1: CGPoint(x: (width * 0.2704), y: (width * 0.1447)), controlPoint2: CGPoint(x: (width * 0.2762), y: (width * 0.1353)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3324), y: (width * 0.0720)), controlPoint1: CGPoint(x: (width * 0.2973), y: (width * 0.1052)), controlPoint2: CGPoint(x: (width * 0.3134), y: (width * 0.0860)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3552), y: (width * 0.0582)), controlPoint1: CGPoint(x: (width * 0.3395), y: (width * 0.0668)), controlPoint2: CGPoint(x: (width * 0.3471), y: (width * 0.0621)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3674), y: (width * 0.0534)), controlPoint1: CGPoint(x: (width * 0.3594), y: (width * 0.0565)), controlPoint2: CGPoint(x: (width * 0.3634), y: (width * 0.0545)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3798), y: (width * 0.0505)), controlPoint1: CGPoint(x: (width * 0.3714), y: (width * 0.0522)), controlPoint2: CGPoint(x: (width * 0.3756), y: (width * 0.0512)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4049), y: (width * 0.0489)), controlPoint1: CGPoint(x: (width * 0.3883), y: (width * 0.0491)), controlPoint2: CGPoint(x: (width * 0.3969), y: (width * 0.0486)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4461), y: (width * 0.0590)), controlPoint1: CGPoint(x: (width * 0.4212), y: (width * 0.0493)), controlPoint2: CGPoint(x: (width * 0.4356), y: (width * 0.0530)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4661), y: (width * 0.0802)), controlPoint1: CGPoint(x: (width * 0.4567), y: (width * 0.0649)), controlPoint2: CGPoint(x: (width * 0.4631), y: (width * 0.0734)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4680), y: (width * 0.0847)), controlPoint1: CGPoint(x: (width * 0.4669), y: (width * 0.0818)), controlPoint2: CGPoint(x: (width * 0.4675), y: (width * 0.0833)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4691), y: (width * 0.0882)), controlPoint1: CGPoint(x: (width * 0.4685), y: (width * 0.0861)), controlPoint2: CGPoint(x: (width * 0.4689), y: (width * 0.0873)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4699), y: (width * 0.0912)), controlPoint1: CGPoint(x: (width * 0.4697), y: (width * 0.0902)), controlPoint2: CGPoint(x: (width * 0.4699), y: (width * 0.0912)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4703), y: (width * 0.0881)), controlPoint1: CGPoint(x: (width * 0.4699), y: (width * 0.0912)), controlPoint2: CGPoint(x: (width * 0.4701), y: (width * 0.0902)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4705), y: (width * 0.0843)), controlPoint1: CGPoint(x: (width * 0.4705), y: (width * 0.0871)), controlPoint2: CGPoint(x: (width * 0.4706), y: (width * 0.0858)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4704), y: (width * 0.0790)), controlPoint1: CGPoint(x: (width * 0.4706), y: (width * 0.0828)), controlPoint2: CGPoint(x: (width * 0.4706), y: (width * 0.0810)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4664), y: (width * 0.0642)), controlPoint1: CGPoint(x: (width * 0.4701), y: (width * 0.0750)), controlPoint2: CGPoint(x: (width * 0.4689), y: (width * 0.0698)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4711), y: (width * 0.0592)), controlPoint1: CGPoint(x: (width * 0.4677), y: (width * 0.0628)), controlPoint2: CGPoint(x: (width * 0.4692), y: (width * 0.0611)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4981), y: (width * 0.0405)), controlPoint1: CGPoint(x: (width * 0.4768), y: (width * 0.0537)), controlPoint2: CGPoint(x: (width * 0.4860), y: (width * 0.0471)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5181), y: (width * 0.0314)), controlPoint1: CGPoint(x: (width * 0.5044), y: (width * 0.0371)), controlPoint2: CGPoint(x: (width * 0.5108), y: (width * 0.0339)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5415), y: (width * 0.0264)), controlPoint1: CGPoint(x: (width * 0.5253), y: (width * 0.0290)), controlPoint2: CGPoint(x: (width * 0.5332), y: (width * 0.0272)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5947), y: (width * 0.0350)), controlPoint1: CGPoint(x: (width * 0.5582), y: (width * 0.0248)), controlPoint2: CGPoint(x: (width * 0.5766), y: (width * 0.0278)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6414), y: (width * 0.0647)), controlPoint1: CGPoint(x: (width * 0.6128), y: (width * 0.0422)), controlPoint2: CGPoint(x: (width * 0.6287), y: (width * 0.0529)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6580), y: (width * 0.0830)), controlPoint1: CGPoint(x: (width * 0.6477), y: (width * 0.0705)), controlPoint2: CGPoint(x: (width * 0.6533), y: (width * 0.0767)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6697), y: (width * 0.1015)), controlPoint1: CGPoint(x: (width * 0.6627), y: (width * 0.0892)), controlPoint2: CGPoint(x: (width * 0.6667), y: (width * 0.0955)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6809), y: (width * 0.1323)), controlPoint1: CGPoint(x: (width * 0.6745), y: (width * 0.1110)), controlPoint2: CGPoint(x: (width * 0.6786), y: (width * 0.1214)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6825), y: (width * 0.1414)), controlPoint1: CGPoint(x: (width * 0.6818), y: (width * 0.1362)), controlPoint2: CGPoint(x: (width * 0.6821), y: (width * 0.1393)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6830), y: (width * 0.1446)), controlPoint1: CGPoint(x: (width * 0.6828), y: (width * 0.1435)), controlPoint2: CGPoint(x: (width * 0.6830), y: (width * 0.1446)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6837), y: (width * 0.1414)), controlPoint1: CGPoint(x: (width * 0.6830), y: (width * 0.1446)), controlPoint2: CGPoint(x: (width * 0.6833), y: (width * 0.1436)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6853), y: (width * 0.1321)), controlPoint1: CGPoint(x: (width * 0.6842), y: (width * 0.1393)), controlPoint2: CGPoint(x: (width * 0.6849), y: (width * 0.1362)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6852), y: (width * 0.1082)), controlPoint1: CGPoint(x: (width * 0.6861), y: (width * 0.1261)), controlPoint2: CGPoint(x: (width * 0.6864), y: (width * 0.1180)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6867), y: (width * 0.1073)), controlPoint1: CGPoint(x: (width * 0.6857), y: (width * 0.1079)), controlPoint2: CGPoint(x: (width * 0.6862), y: (width * 0.1076)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7227), y: (width * 0.0930)), controlPoint1: CGPoint(x: (width * 0.6951), y: (width * 0.1030)), controlPoint2: CGPoint(x: (width * 0.7073), y: (width * 0.0962)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7350), y: (width * 0.0912)), controlPoint1: CGPoint(x: (width * 0.7265), y: (width * 0.0920)), controlPoint2: CGPoint(x: (width * 0.7307), y: (width * 0.0917)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7489), y: (width * 0.0899)), controlPoint1: CGPoint(x: (width * 0.7395), y: (width * 0.0908)), controlPoint2: CGPoint(x: (width * 0.7442), y: (width * 0.0901)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7787), y: (width * 0.0907)), controlPoint1: CGPoint(x: (width * 0.7583), y: (width * 0.0893)), controlPoint2: CGPoint(x: (width * 0.7683), y: (width * 0.0897)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8417), y: (width * 0.1114)), controlPoint1: CGPoint(x: (width * 0.7993), y: (width * 0.0932)), controlPoint2: CGPoint(x: (width * 0.8211), y: (width * 0.0995)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8702), y: (width * 0.1311)), controlPoint1: CGPoint(x: (width * 0.8520), y: (width * 0.1172)), controlPoint2: CGPoint(x: (width * 0.8615), y: (width * 0.1239)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8827), y: (width * 0.1423)), controlPoint1: CGPoint(x: (width * 0.8745), y: (width * 0.1348)), controlPoint2: CGPoint(x: (width * 0.8788), y: (width * 0.1385)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.8856), y: (width * 0.1452)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8882), y: (width * 0.1479)), controlPoint1: CGPoint(x: (width * 0.8866), y: (width * 0.1461)), controlPoint2: CGPoint(x: (width * 0.8873), y: (width * 0.1470)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8931), y: (width * 0.1537)), controlPoint1: CGPoint(x: (width * 0.8899), y: (width * 0.1497)), controlPoint2: CGPoint(x: (width * 0.8915), y: (width * 0.1517)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9203), y: (width * 0.2028)), controlPoint1: CGPoint(x: (width * 0.9057), y: (width * 0.1698)), controlPoint2: CGPoint(x: (width * 0.9143), y: (width * 0.1877)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9299), y: (width * 0.2406)), controlPoint1: CGPoint(x: (width * 0.9261), y: (width * 0.2181)), controlPoint2: CGPoint(x: (width * 0.9291), y: (width * 0.2313)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9303), y: (width * 0.2514)), controlPoint1: CGPoint(x: (width * 0.9302), y: (width * 0.2453)), controlPoint2: CGPoint(x: (width * 0.9305), y: (width * 0.2490)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9302), y: (width * 0.2553)), controlPoint1: CGPoint(x: (width * 0.9302), y: (width * 0.2540)), controlPoint2: CGPoint(x: (width * 0.9302), y: (width * 0.2553)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9315), y: (width * 0.2517)), controlPoint1: CGPoint(x: (width * 0.9302), y: (width * 0.2553)), controlPoint2: CGPoint(x: (width * 0.9306), y: (width * 0.2540)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9344), y: (width * 0.2408)), controlPoint1: CGPoint(x: (width * 0.9325), y: (width * 0.2493)), controlPoint2: CGPoint(x: (width * 0.9333), y: (width * 0.2456)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9340), y: (width * 0.1992)), controlPoint1: CGPoint(x: (width * 0.9362), y: (width * 0.2312)), controlPoint2: CGPoint(x: (width * 0.9367), y: (width * 0.2167)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9316), y: (width * 0.1874)), controlPoint1: CGPoint(x: (width * 0.9334), y: (width * 0.1954)), controlPoint2: CGPoint(x: (width * 0.9326), y: (width * 0.1914)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9483), y: (width * 0.2123)), controlPoint1: CGPoint(x: (width * 0.9363), y: (width * 0.1935)), controlPoint2: CGPoint(x: (width * 0.9422), y: (width * 0.2019)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9668), y: (width * 0.2551)), controlPoint1: CGPoint(x: (width * 0.9551), y: (width * 0.2241)), controlPoint2: CGPoint(x: (width * 0.9624), y: (width * 0.2385)))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: (width * 0.9894), y: (width * 0.2469)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9595), y: (width * 0.2036)), controlPoint1: CGPoint(x: (width * 0.9813), y: (width * 0.2282)), controlPoint2: CGPoint(x: (width * 0.9698), y: (width * 0.2141)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9328), y: (width * 0.1817)), controlPoint1: CGPoint(x: (width * 0.9491), y: (width * 0.1931)), controlPoint2: CGPoint(x: (width * 0.9395), y: (width * 0.1861)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9297), y: (width * 0.1797)), controlPoint1: CGPoint(x: (width * 0.9317), y: (width * 0.1809)), controlPoint2: CGPoint(x: (width * 0.9306), y: (width * 0.1803)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9128), y: (width * 0.1401)), controlPoint1: CGPoint(x: (width * 0.9262), y: (width * 0.1672)), controlPoint2: CGPoint(x: (width * 0.9210), y: (width * 0.1537)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9076), y: (width * 0.1322)), controlPoint1: CGPoint(x: (width * 0.9112), y: (width * 0.1375)), controlPoint2: CGPoint(x: (width * 0.9096), y: (width * 0.1348)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9046), y: (width * 0.1283)), controlPoint1: CGPoint(x: (width * 0.9066), y: (width * 0.1309)), controlPoint2: CGPoint(x: (width * 0.9056), y: (width * 0.1295)))
        bezier2Path.addLine(to: CGPoint(x: (width * 0.9015), y: (width * 0.1248)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8883), y: (width * 0.1108)), controlPoint1: CGPoint(x: (width * 0.8975), y: (width * 0.1199)), controlPoint2: CGPoint(x: (width * 0.8930), y: (width * 0.1154)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8556), y: (width * 0.0866)), controlPoint1: CGPoint(x: (width * 0.8788), y: (width * 0.1019)), controlPoint2: CGPoint(x: (width * 0.8679), y: (width * 0.0936)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7799), y: (width * 0.0667)), controlPoint1: CGPoint(x: (width * 0.8312), y: (width * 0.0725)), controlPoint2: CGPoint(x: (width * 0.8039), y: (width * 0.0667)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7461), y: (width * 0.0707)), controlPoint1: CGPoint(x: (width * 0.7678), y: (width * 0.0670)), controlPoint2: CGPoint(x: (width * 0.7564), y: (width * 0.0683)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7317), y: (width * 0.0746)), controlPoint1: CGPoint(x: (width * 0.7410), y: (width * 0.0718)), controlPoint2: CGPoint(x: (width * 0.7363), y: (width * 0.0733)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7182), y: (width * 0.0795)), controlPoint1: CGPoint(x: (width * 0.7269), y: (width * 0.0761)), controlPoint2: CGPoint(x: (width * 0.7224), y: (width * 0.0774)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6975), y: (width * 0.0921)), controlPoint1: CGPoint(x: (width * 0.7098), y: (width * 0.0832)), controlPoint2: CGPoint(x: (width * 0.7030), y: (width * 0.0879)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6845), y: (width * 0.1034)), controlPoint1: CGPoint(x: (width * 0.6921), y: (width * 0.0962)), controlPoint2: CGPoint(x: (width * 0.6879), y: (width * 0.1001)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6831), y: (width * 0.0967)), controlPoint1: CGPoint(x: (width * 0.6841), y: (width * 0.1012)), controlPoint2: CGPoint(x: (width * 0.6836), y: (width * 0.0990)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6746), y: (width * 0.0730)), controlPoint1: CGPoint(x: (width * 0.6814), y: (width * 0.0892)), controlPoint2: CGPoint(x: (width * 0.6786), y: (width * 0.0812)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6590), y: (width * 0.0484)), controlPoint1: CGPoint(x: (width * 0.6707), y: (width * 0.0648)), controlPoint2: CGPoint(x: (width * 0.6655), y: (width * 0.0564)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6052), y: (width * 0.0086)), controlPoint1: CGPoint(x: (width * 0.6461), y: (width * 0.0324)), controlPoint2: CGPoint(x: (width * 0.6278), y: (width * 0.0175)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5375), y: (width * 0.0028)), controlPoint1: CGPoint(x: (width * 0.5827), y: -0.16), controlPoint2: CGPoint(x: (width * 0.5582), y: -0.76))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5098), y: (width * 0.0138)), controlPoint1: CGPoint(x: (width * 0.5272), y: (width * 0.0052)), controlPoint2: CGPoint(x: (width * 0.5179), y: (width * 0.0092)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4898), y: (width * 0.0289)), controlPoint1: CGPoint(x: (width * 0.5018), y: (width * 0.0186)), controlPoint2: CGPoint(x: (width * 0.4952), y: (width * 0.0240)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4676), y: (width * 0.0566)), controlPoint1: CGPoint(x: (width * 0.4787), y: (width * 0.0392)), controlPoint2: CGPoint(x: (width * 0.4714), y: (width * 0.0491)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4652), y: (width * 0.0618)), controlPoint1: CGPoint(x: (width * 0.4666), y: (width * 0.0586)), controlPoint2: CGPoint(x: (width * 0.4658), y: (width * 0.0603)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4549), y: (width * 0.0478)), controlPoint1: CGPoint(x: (width * 0.4628), y: (width * 0.0571)), controlPoint2: CGPoint(x: (width * 0.4595), y: (width * 0.0523)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4077), y: (width * 0.0250)), controlPoint1: CGPoint(x: (width * 0.4440), y: (width * 0.0370)), controlPoint2: CGPoint(x: (width * 0.4272), y: (width * 0.0285)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3765), y: (width * 0.0235)), controlPoint1: CGPoint(x: (width * 0.3980), y: (width * 0.0232)), controlPoint2: CGPoint(x: (width * 0.3875), y: (width * 0.0226)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3598), y: (width * 0.0264)), controlPoint1: CGPoint(x: (width * 0.3711), y: (width * 0.0240)), controlPoint2: CGPoint(x: (width * 0.3655), y: (width * 0.0249)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3432), y: (width * 0.0324)), controlPoint1: CGPoint(x: (width * 0.3539), y: (width * 0.0278)), controlPoint2: CGPoint(x: (width * 0.3486), y: (width * 0.0302)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3151), y: (width * 0.0510)), controlPoint1: CGPoint(x: (width * 0.3326), y: (width * 0.0375)), controlPoint2: CGPoint(x: (width * 0.3233), y: (width * 0.0440)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2947), y: (width * 0.0736)), controlPoint1: CGPoint(x: (width * 0.3071), y: (width * 0.0582)), controlPoint2: CGPoint(x: (width * 0.3004), y: (width * 0.0659)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2872), y: (width * 0.0847)), controlPoint1: CGPoint(x: (width * 0.2920), y: (width * 0.0773)), controlPoint2: CGPoint(x: (width * 0.2895), y: (width * 0.0811)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2836), y: (width * 0.0832)), controlPoint1: CGPoint(x: (width * 0.2860), y: (width * 0.0842)), controlPoint2: CGPoint(x: (width * 0.2848), y: (width * 0.0837)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2696), y: (width * 0.0775)), controlPoint1: CGPoint(x: (width * 0.2791), y: (width * 0.0814)), controlPoint2: CGPoint(x: (width * 0.2747), y: (width * 0.0792)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2364), y: (width * 0.0693)), controlPoint1: CGPoint(x: (width * 0.2597), y: (width * 0.0738)), controlPoint2: CGPoint(x: (width * 0.2485), y: (width * 0.0710)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1577), y: (width * 0.0819)), controlPoint1: CGPoint(x: (width * 0.2123), y: (width * 0.0659)), controlPoint2: CGPoint(x: (width * 0.1837), y: (width * 0.0688)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1000), y: (width * 0.1369)), controlPoint1: CGPoint(x: (width * 0.1315), y: (width * 0.0948)), controlPoint2: CGPoint(x: (width * 0.1120), y: (width * 0.1157)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0806), y: (width * 0.1973)), controlPoint1: CGPoint(x: (width * 0.0879), y: (width * 0.1583)), controlPoint2: CGPoint(x: (width * 0.0824), y: (width * 0.1796)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0796), y: (width * 0.2141)), controlPoint1: CGPoint(x: (width * 0.0799), y: (width * 0.2034)), controlPoint2: CGPoint(x: (width * 0.0796), y: (width * 0.2089)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0783), y: (width * 0.2144)), controlPoint1: CGPoint(x: (width * 0.0792), y: (width * 0.2142)), controlPoint2: CGPoint(x: (width * 0.0787), y: (width * 0.2142)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0454), y: (width * 0.2288)), controlPoint1: CGPoint(x: (width * 0.0701), y: (width * 0.2159)), controlPoint2: CGPoint(x: (width * 0.0582), y: (width * 0.2198)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0113), y: (width * 0.2715)), controlPoint1: CGPoint(x: (width * 0.0326), y: (width * 0.2377)), controlPoint2: CGPoint(x: (width * 0.0200), y: (width * 0.2525)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0007), y: (width * 0.3380)), controlPoint1: CGPoint(x: (width * 0.0029), y: (width * 0.2906)), controlPoint2: CGPoint(x: -0.61, y: (width * 0.3136)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0239), y: (width * 0.4007)), controlPoint1: CGPoint(x: (width * 0.0033), y: (width * 0.3624)), controlPoint2: CGPoint(x: (width * 0.0125), y: (width * 0.3837)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0626), y: (width * 0.4384)), controlPoint1: CGPoint(x: (width * 0.0352), y: (width * 0.4179)), controlPoint2: CGPoint(x: (width * 0.0492), y: (width * 0.4306)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0941), y: (width * 0.4497)), controlPoint1: CGPoint(x: (width * 0.0748), y: (width * 0.4455)), controlPoint2: CGPoint(x: (width * 0.0859), y: (width * 0.4488)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0876), y: (width * 0.4647)), controlPoint1: CGPoint(x: (width * 0.0918), y: (width * 0.4545)), controlPoint2: CGPoint(x: (width * 0.0895), y: (width * 0.4594)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0856), y: (width * 0.4697)), controlPoint1: CGPoint(x: (width * 0.0869), y: (width * 0.4664)), controlPoint2: CGPoint(x: (width * 0.0862), y: (width * 0.4680)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0839), y: (width * 0.4752)), controlPoint1: CGPoint(x: (width * 0.0849), y: (width * 0.4714)), controlPoint2: CGPoint(x: (width * 0.0845), y: (width * 0.4733)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0810), y: (width * 0.4865)), controlPoint1: CGPoint(x: (width * 0.0830), y: (width * 0.4789)), controlPoint2: CGPoint(x: (width * 0.0817), y: (width * 0.4826)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0794), y: (width * 0.4986)), controlPoint1: CGPoint(x: (width * 0.0805), y: (width * 0.4905)), controlPoint2: CGPoint(x: (width * 0.0799), y: (width * 0.4945)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0792), y: (width * 0.5112)), controlPoint1: CGPoint(x: (width * 0.0789), y: (width * 0.5027)), controlPoint2: CGPoint(x: (width * 0.0792), y: (width * 0.5069)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.0924), y: (width * 0.5622)), controlPoint1: CGPoint(x: (width * 0.0797), y: (width * 0.5281)), controlPoint2: CGPoint(x: (width * 0.0843), y: (width * 0.5458)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.1264), y: (width * 0.6066)), controlPoint1: CGPoint(x: (width * 0.1006), y: (width * 0.5786)), controlPoint2: CGPoint(x: (width * 0.1122), y: (width * 0.5937)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2240), y: (width * 0.6478)), controlPoint1: CGPoint(x: (width * 0.1547), y: (width * 0.6324)), controlPoint2: CGPoint(x: (width * 0.1907), y: (width * 0.6466)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2637), y: (width * 0.6434)), controlPoint1: CGPoint(x: (width * 0.2381), y: (width * 0.6484)), controlPoint2: CGPoint(x: (width * 0.2515), y: (width * 0.6466)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2692), y: (width * 0.6490)), controlPoint1: CGPoint(x: (width * 0.2651), y: (width * 0.6449)), controlPoint2: CGPoint(x: (width * 0.2668), y: (width * 0.6468)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.2990), y: (width * 0.6683)), controlPoint1: CGPoint(x: (width * 0.2753), y: (width * 0.6545)), controlPoint2: CGPoint(x: (width * 0.2849), y: (width * 0.6621)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.3521), y: (width * 0.6780)), controlPoint1: CGPoint(x: (width * 0.3130), y: (width * 0.6744)), controlPoint2: CGPoint(x: (width * 0.3315), y: (width * 0.6789)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4161), y: (width * 0.6610)), controlPoint1: CGPoint(x: (width * 0.3728), y: (width * 0.6773)), controlPoint2: CGPoint(x: (width * 0.3952), y: (width * 0.6716)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4840), y: (width * 0.5904)), controlPoint1: CGPoint(x: (width * 0.4498), y: (width * 0.6440)), controlPoint2: CGPoint(x: (width * 0.4730), y: (width * 0.6164)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.4870), y: (width * 0.5935)), controlPoint1: CGPoint(x: (width * 0.4849), y: (width * 0.5914)), controlPoint2: CGPoint(x: (width * 0.4859), y: (width * 0.5924)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5196), y: (width * 0.6114)), controlPoint1: CGPoint(x: (width * 0.4934), y: (width * 0.5990)), controlPoint2: CGPoint(x: (width * 0.5036), y: (width * 0.6073)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5322), y: (width * 0.6135)), controlPoint1: CGPoint(x: (width * 0.5236), y: (width * 0.6122)), controlPoint2: CGPoint(x: (width * 0.5278), y: (width * 0.6134)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5390), y: (width * 0.6139)), controlPoint1: CGPoint(x: (width * 0.5345), y: (width * 0.6136)), controlPoint2: CGPoint(x: (width * 0.5367), y: (width * 0.6138)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5460), y: (width * 0.6138)), controlPoint1: CGPoint(x: (width * 0.5414), y: (width * 0.6142)), controlPoint2: CGPoint(x: (width * 0.5436), y: (width * 0.6139)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5533), y: (width * 0.6134)), controlPoint1: CGPoint(x: (width * 0.5484), y: (width * 0.6136)), controlPoint2: CGPoint(x: (width * 0.5508), y: (width * 0.6135)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5605), y: (width * 0.6123)), controlPoint1: CGPoint(x: (width * 0.5557), y: (width * 0.6130)), controlPoint2: CGPoint(x: (width * 0.5581), y: (width * 0.6127)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.5757), y: (width * 0.6092)), controlPoint1: CGPoint(x: (width * 0.5655), y: (width * 0.6117)), controlPoint2: CGPoint(x: (width * 0.5705), y: (width * 0.6105)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6071), y: (width * 0.5947)), controlPoint1: CGPoint(x: (width * 0.5861), y: (width * 0.6062)), controlPoint2: CGPoint(x: (width * 0.5969), y: (width * 0.6017)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6333), y: (width * 0.5665)), controlPoint1: CGPoint(x: (width * 0.6173), y: (width * 0.5878)), controlPoint2: CGPoint(x: (width * 0.6267), y: (width * 0.5782)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6441), y: (width * 0.5354)), controlPoint1: CGPoint(x: (width * 0.6390), y: (width * 0.5566)), controlPoint2: CGPoint(x: (width * 0.6424), y: (width * 0.5459)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6448), y: (width * 0.5361)), controlPoint1: CGPoint(x: (width * 0.6443), y: (width * 0.5357)), controlPoint2: CGPoint(x: (width * 0.6446), y: (width * 0.5358)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6543), y: (width * 0.5429)), controlPoint1: CGPoint(x: (width * 0.6476), y: (width * 0.5384)), controlPoint2: CGPoint(x: (width * 0.6508), y: (width * 0.5405)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.6807), y: (width * 0.5542)), controlPoint1: CGPoint(x: (width * 0.6614), y: (width * 0.5472)), controlPoint2: CGPoint(x: (width * 0.6703), y: (width * 0.5514)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.7543), y: (width * 0.5557)), controlPoint1: CGPoint(x: (width * 0.7019), y: (width * 0.5591)), controlPoint2: CGPoint(x: (width * 0.7266), y: (width * 0.5597)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8393), y: (width * 0.5231)), controlPoint1: CGPoint(x: (width * 0.7817), y: (width * 0.5517)), controlPoint2: CGPoint(x: (width * 0.8119), y: (width * 0.5420)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8743), y: (width * 0.4890)), controlPoint1: CGPoint(x: (width * 0.8529), y: (width * 0.5136)), controlPoint2: CGPoint(x: (width * 0.8649), y: (width * 0.5021)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8946), y: (width * 0.4490)), controlPoint1: CGPoint(x: (width * 0.8835), y: (width * 0.4759)), controlPoint2: CGPoint(x: (width * 0.8898), y: (width * 0.4624)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.8999), y: (width * 0.4303)), controlPoint1: CGPoint(x: (width * 0.8968), y: (width * 0.4427)), controlPoint2: CGPoint(x: (width * 0.8986), y: (width * 0.4365)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9051), y: (width * 0.4274)), controlPoint1: CGPoint(x: (width * 0.9014), y: (width * 0.4295)), controlPoint2: CGPoint(x: (width * 0.9031), y: (width * 0.4286)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9339), y: (width * 0.4090)), controlPoint1: CGPoint(x: (width * 0.9121), y: (width * 0.4236)), controlPoint2: CGPoint(x: (width * 0.9222), y: (width * 0.4176)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9714), y: (width * 0.3733)), controlPoint1: CGPoint(x: (width * 0.9455), y: (width * 0.4003)), controlPoint2: CGPoint(x: (width * 0.9590), y: (width * 0.3889)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9883), y: (width * 0.3464)), controlPoint1: CGPoint(x: (width * 0.9777), y: (width * 0.3655)), controlPoint2: CGPoint(x: (width * 0.9835), y: (width * 0.3564)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9986), y: (width * 0.3129)), controlPoint1: CGPoint(x: (width * 0.9931), y: (width * 0.3363)), controlPoint2: CGPoint(x: (width * 0.9971), y: (width * 0.3248)))
        bezier2Path.addCurve(to: CGPoint(x: (width * 0.9894), y: (width * 0.2469)), controlPoint1: CGPoint(x: (width * 1.0023), y: (width * 0.2889)), controlPoint2: CGPoint(x: (width * 0.9977), y: (width * 0.2654)))
        bezier2Path.close()
        shape2.path = bezier2Path.cgPath
        shape2.fillColor = blackColor.cgColor
        
        //// Bezier Drawing
        let shape = CAShapeLayer()
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: (width * 0.9894), y: (width * 0.2469)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9595), y: (width * 0.2036)), controlPoint1: CGPoint(x: (width * 0.9813), y: (width * 0.2282)), controlPoint2: CGPoint(x: (width * 0.9698), y: (width * 0.2141)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9328), y: (width * 0.1817)), controlPoint1: CGPoint(x: (width * 0.9491), y: (width * 0.1931)), controlPoint2: CGPoint(x: (width * 0.9395), y: (width * 0.1861)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9297), y: (width * 0.1797)), controlPoint1: CGPoint(x: (width * 0.9317), y: (width * 0.1809)), controlPoint2: CGPoint(x: (width * 0.9306), y: (width * 0.1803)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9128), y: (width * 0.1401)), controlPoint1: CGPoint(x: (width * 0.9262), y: (width * 0.1672)), controlPoint2: CGPoint(x: (width * 0.9210), y: (width * 0.1537)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9076), y: (width * 0.1322)), controlPoint1: CGPoint(x: (width * 0.9112), y: (width * 0.1375)), controlPoint2: CGPoint(x: (width * 0.9096), y: (width * 0.1348)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9046), y: (width * 0.1283)), controlPoint1: CGPoint(x: (width * 0.9066), y: (width * 0.1309)), controlPoint2: CGPoint(x: (width * 0.9056), y: (width * 0.1295)))
        bezierPath.addLine(to: CGPoint(x: (width * 0.9015), y: (width * 0.1248)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8883), y: (width * 0.1108)), controlPoint1: CGPoint(x: (width * 0.8975), y: (width * 0.1199)), controlPoint2: CGPoint(x: (width * 0.8930), y: (width * 0.1154)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8556), y: (width * 0.0866)), controlPoint1: CGPoint(x: (width * 0.8788), y: (width * 0.1019)), controlPoint2: CGPoint(x: (width * 0.8679), y: (width * 0.0936)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7799), y: (width * 0.0667)), controlPoint1: CGPoint(x: (width * 0.8312), y: (width * 0.0725)), controlPoint2: CGPoint(x: (width * 0.8039), y: (width * 0.0667)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7461), y: (width * 0.0707)), controlPoint1: CGPoint(x: (width * 0.7678), y: (width * 0.0670)), controlPoint2: CGPoint(x: (width * 0.7564), y: (width * 0.0683)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7317), y: (width * 0.0746)), controlPoint1: CGPoint(x: (width * 0.7410), y: (width * 0.0718)), controlPoint2: CGPoint(x: (width * 0.7363), y: (width * 0.0733)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7182), y: (width * 0.0795)), controlPoint1: CGPoint(x: (width * 0.7269), y: (width * 0.0761)), controlPoint2: CGPoint(x: (width * 0.7224), y: (width * 0.0774)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6975), y: (width * 0.0921)), controlPoint1: CGPoint(x: (width * 0.7098), y: (width * 0.0832)), controlPoint2: CGPoint(x: (width * 0.7030), y: (width * 0.0879)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6844), y: (width * 0.1034)), controlPoint1: CGPoint(x: (width * 0.6921), y: (width * 0.0962)), controlPoint2: CGPoint(x: (width * 0.6879), y: (width * 0.1001)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6831), y: (width * 0.0967)), controlPoint1: CGPoint(x: (width * 0.6841), y: (width * 0.1012)), controlPoint2: CGPoint(x: (width * 0.6836), y: (width * 0.0990)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6746), y: (width * 0.0730)), controlPoint1: CGPoint(x: (width * 0.6814), y: (width * 0.0892)), controlPoint2: CGPoint(x: (width * 0.6786), y: (width * 0.0812)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6590), y: (width * 0.0484)), controlPoint1: CGPoint(x: (width * 0.6707), y: (width * 0.0648)), controlPoint2: CGPoint(x: (width * 0.6655), y: (width * 0.0564)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6052), y: (width * 0.0086)), controlPoint1: CGPoint(x: (width * 0.6461), y: (width * 0.0324)), controlPoint2: CGPoint(x: (width * 0.6278), y: (width * 0.0175)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5375), y: (width * 0.0028)), controlPoint1: CGPoint(x: (width * 0.5827), y: -0.16), controlPoint2: CGPoint(x: (width * 0.5582), y: -0.76))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5098), y: (width * 0.0138)), controlPoint1: CGPoint(x: (width * 0.5272), y: (width * 0.0052)), controlPoint2: CGPoint(x: (width * 0.5179), y: (width * 0.0092)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4898), y: (width * 0.0289)), controlPoint1: CGPoint(x: (width * 0.5018), y: (width * 0.0186)), controlPoint2: CGPoint(x: (width * 0.4952), y: (width * 0.0240)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4676), y: (width * 0.0566)), controlPoint1: CGPoint(x: (width * 0.4787), y: (width * 0.0392)), controlPoint2: CGPoint(x: (width * 0.4714), y: (width * 0.0491)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4652), y: (width * 0.0618)), controlPoint1: CGPoint(x: (width * 0.4666), y: (width * 0.0586)), controlPoint2: CGPoint(x: (width * 0.4658), y: (width * 0.0603)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4549), y: (width * 0.0478)), controlPoint1: CGPoint(x: (width * 0.4628), y: (width * 0.0571)), controlPoint2: CGPoint(x: (width * 0.4595), y: (width * 0.0523)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4077), y: (width * 0.0250)), controlPoint1: CGPoint(x: (width * 0.4440), y: (width * 0.0370)), controlPoint2: CGPoint(x: (width * 0.4272), y: (width * 0.0285)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3765), y: (width * 0.0235)), controlPoint1: CGPoint(x: (width * 0.3980), y: (width * 0.0232)), controlPoint2: CGPoint(x: (width * 0.3875), y: (width * 0.0226)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3598), y: (width * 0.0264)), controlPoint1: CGPoint(x: (width * 0.3711), y: (width * 0.0240)), controlPoint2: CGPoint(x: (width * 0.3655), y: (width * 0.0249)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3432), y: (width * 0.0324)), controlPoint1: CGPoint(x: (width * 0.3539), y: (width * 0.0278)), controlPoint2: CGPoint(x: (width * 0.3486), y: (width * 0.0302)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3151), y: (width * 0.0510)), controlPoint1: CGPoint(x: (width * 0.3326), y: (width * 0.0375)), controlPoint2: CGPoint(x: (width * 0.3233), y: (width * 0.0440)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2947), y: (width * 0.0736)), controlPoint1: CGPoint(x: (width * 0.3071), y: (width * 0.0582)), controlPoint2: CGPoint(x: (width * 0.3004), y: (width * 0.0659)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2872), y: (width * 0.0847)), controlPoint1: CGPoint(x: (width * 0.2920), y: (width * 0.0773)), controlPoint2: CGPoint(x: (width * 0.2895), y: (width * 0.0811)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2836), y: (width * 0.0832)), controlPoint1: CGPoint(x: (width * 0.2860), y: (width * 0.0842)), controlPoint2: CGPoint(x: (width * 0.2848), y: (width * 0.0837)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2696), y: (width * 0.0775)), controlPoint1: CGPoint(x: (width * 0.2791), y: (width * 0.0814)), controlPoint2: CGPoint(x: (width * 0.2747), y: (width * 0.0792)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2364), y: (width * 0.0693)), controlPoint1: CGPoint(x: (width * 0.2597), y: (width * 0.0738)), controlPoint2: CGPoint(x: (width * 0.2485), y: (width * 0.0710)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1577), y: (width * 0.0819)), controlPoint1: CGPoint(x: (width * 0.2123), y: (width * 0.0659)), controlPoint2: CGPoint(x: (width * 0.1837), y: (width * 0.0688)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1000), y: (width * 0.1369)), controlPoint1: CGPoint(x: (width * 0.1315), y: (width * 0.0948)), controlPoint2: CGPoint(x: (width * 0.1120), y: (width * 0.1157)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0806), y: (width * 0.1973)), controlPoint1: CGPoint(x: (width * 0.0879), y: (width * 0.1583)), controlPoint2: CGPoint(x: (width * 0.0824), y: (width * 0.1796)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0796), y: (width * 0.2141)), controlPoint1: CGPoint(x: (width * 0.0799), y: (width * 0.2034)), controlPoint2: CGPoint(x: (width * 0.0796), y: (width * 0.2089)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0783), y: (width * 0.2144)), controlPoint1: CGPoint(x: (width * 0.0792), y: (width * 0.2142)), controlPoint2: CGPoint(x: (width * 0.0787), y: (width * 0.2142)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0454), y: (width * 0.2288)), controlPoint1: CGPoint(x: (width * 0.0701), y: (width * 0.2159)), controlPoint2: CGPoint(x: (width * 0.0582), y: (width * 0.2198)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0113), y: (width * 0.2715)), controlPoint1: CGPoint(x: (width * 0.0326), y: (width * 0.2377)), controlPoint2: CGPoint(x: (width * 0.0200), y: (width * 0.2525)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0007), y: (width * 0.3380)), controlPoint1: CGPoint(x: (width * 0.0029), y: (width * 0.2906)), controlPoint2: CGPoint(x: -0.61, y: (width * 0.3136)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0239), y: (width * 0.4007)), controlPoint1: CGPoint(x: (width * 0.0033), y: (width * 0.3624)), controlPoint2: CGPoint(x: (width * 0.0125), y: (width * 0.3837)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0626), y: (width * 0.4384)), controlPoint1: CGPoint(x: (width * 0.0352), y: (width * 0.4179)), controlPoint2: CGPoint(x: (width * 0.0492), y: (width * 0.4306)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0941), y: (width * 0.4497)), controlPoint1: CGPoint(x: (width * 0.0747), y: (width * 0.4455)), controlPoint2: CGPoint(x: (width * 0.0859), y: (width * 0.4488)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0876), y: (width * 0.4647)), controlPoint1: CGPoint(x: (width * 0.0918), y: (width * 0.4545)), controlPoint2: CGPoint(x: (width * 0.0895), y: (width * 0.4594)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0856), y: (width * 0.4697)), controlPoint1: CGPoint(x: (width * 0.0869), y: (width * 0.4664)), controlPoint2: CGPoint(x: (width * 0.0862), y: (width * 0.4680)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0839), y: (width * 0.4752)), controlPoint1: CGPoint(x: (width * 0.0849), y: (width * 0.4714)), controlPoint2: CGPoint(x: (width * 0.0845), y: (width * 0.4733)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0810), y: (width * 0.4865)), controlPoint1: CGPoint(x: (width * 0.0830), y: (width * 0.4789)), controlPoint2: CGPoint(x: (width * 0.0817), y: (width * 0.4826)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0794), y: (width * 0.4986)), controlPoint1: CGPoint(x: (width * 0.0805), y: (width * 0.4905)), controlPoint2: CGPoint(x: (width * 0.0799), y: (width * 0.4945)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0792), y: (width * 0.5112)), controlPoint1: CGPoint(x: (width * 0.0789), y: (width * 0.5027)), controlPoint2: CGPoint(x: (width * 0.0792), y: (width * 0.5069)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.0924), y: (width * 0.5622)), controlPoint1: CGPoint(x: (width * 0.0797), y: (width * 0.5281)), controlPoint2: CGPoint(x: (width * 0.0843), y: (width * 0.5458)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.1264), y: (width * 0.6066)), controlPoint1: CGPoint(x: (width * 0.1006), y: (width * 0.5786)), controlPoint2: CGPoint(x: (width * 0.1122), y: (width * 0.5937)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2240), y: (width * 0.6478)), controlPoint1: CGPoint(x: (width * 0.1547), y: (width * 0.6324)), controlPoint2: CGPoint(x: (width * 0.1907), y: (width * 0.6466)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2637), y: (width * 0.6434)), controlPoint1: CGPoint(x: (width * 0.2381), y: (width * 0.6484)), controlPoint2: CGPoint(x: (width * 0.2515), y: (width * 0.6466)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2692), y: (width * 0.6490)), controlPoint1: CGPoint(x: (width * 0.2651), y: (width * 0.6449)), controlPoint2: CGPoint(x: (width * 0.2668), y: (width * 0.6468)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.2990), y: (width * 0.6683)), controlPoint1: CGPoint(x: (width * 0.2753), y: (width * 0.6545)), controlPoint2: CGPoint(x: (width * 0.2849), y: (width * 0.6621)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.3521), y: (width * 0.6780)), controlPoint1: CGPoint(x: (width * 0.3130), y: (width * 0.6744)), controlPoint2: CGPoint(x: (width * 0.3315), y: (width * 0.6789)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4161), y: (width * 0.6610)), controlPoint1: CGPoint(x: (width * 0.3728), y: (width * 0.6773)), controlPoint2: CGPoint(x: (width * 0.3952), y: (width * 0.6716)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4840), y: (width * 0.5904)), controlPoint1: CGPoint(x: (width * 0.4498), y: (width * 0.6440)), controlPoint2: CGPoint(x: (width * 0.4730), y: (width * 0.6164)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.4870), y: (width * 0.5935)), controlPoint1: CGPoint(x: (width * 0.4849), y: (width * 0.5914)), controlPoint2: CGPoint(x: (width * 0.4859), y: (width * 0.5924)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5196), y: (width * 0.6114)), controlPoint1: CGPoint(x: (width * 0.4934), y: (width * 0.5990)), controlPoint2: CGPoint(x: (width * 0.5036), y: (width * 0.6073)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5322), y: (width * 0.6135)), controlPoint1: CGPoint(x: (width * 0.5236), y: (width * 0.6122)), controlPoint2: CGPoint(x: (width * 0.5278), y: (width * 0.6134)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5390), y: (width * 0.6140)), controlPoint1: CGPoint(x: (width * 0.5345), y: (width * 0.6136)), controlPoint2: CGPoint(x: (width * 0.5367), y: (width * 0.6138)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5460), y: (width * 0.6138)), controlPoint1: CGPoint(x: (width * 0.5414), y: (width * 0.6142)), controlPoint2: CGPoint(x: (width * 0.5436), y: (width * 0.6139)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5533), y: (width * 0.6134)), controlPoint1: CGPoint(x: (width * 0.5484), y: (width * 0.6136)), controlPoint2: CGPoint(x: (width * 0.5508), y: (width * 0.6135)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5605), y: (width * 0.6123)), controlPoint1: CGPoint(x: (width * 0.5557), y: (width * 0.6130)), controlPoint2: CGPoint(x: (width * 0.5581), y: (width * 0.6127)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.5757), y: (width * 0.6092)), controlPoint1: CGPoint(x: (width * 0.5655), y: (width * 0.6117)), controlPoint2: CGPoint(x: (width * 0.5705), y: (width * 0.6105)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6071), y: (width * 0.5947)), controlPoint1: CGPoint(x: (width * 0.5861), y: (width * 0.6062)), controlPoint2: CGPoint(x: (width * 0.5969), y: (width * 0.6017)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6333), y: (width * 0.5665)), controlPoint1: CGPoint(x: (width * 0.6173), y: (width * 0.5878)), controlPoint2: CGPoint(x: (width * 0.6267), y: (width * 0.5782)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6441), y: (width * 0.5354)), controlPoint1: CGPoint(x: (width * 0.6390), y: (width * 0.5566)), controlPoint2: CGPoint(x: (width * 0.6424), y: (width * 0.5459)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6448), y: (width * 0.5361)), controlPoint1: CGPoint(x: (width * 0.6443), y: (width * 0.5357)), controlPoint2: CGPoint(x: (width * 0.6446), y: (width * 0.5358)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6543), y: (width * 0.5429)), controlPoint1: CGPoint(x: (width * 0.6476), y: (width * 0.5384)), controlPoint2: CGPoint(x: (width * 0.6508), y: (width * 0.5405)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.6807), y: (width * 0.5542)), controlPoint1: CGPoint(x: (width * 0.6614), y: (width * 0.5472)), controlPoint2: CGPoint(x: (width * 0.6703), y: (width * 0.5514)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.7543), y: (width * 0.5557)), controlPoint1: CGPoint(x: (width * 0.7019), y: (width * 0.5591)), controlPoint2: CGPoint(x: (width * 0.7266), y: (width * 0.5597)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8393), y: (width * 0.5231)), controlPoint1: CGPoint(x: (width * 0.7817), y: (width * 0.5517)), controlPoint2: CGPoint(x: (width * 0.8119), y: (width * 0.5420)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8743), y: (width * 0.4890)), controlPoint1: CGPoint(x: (width * 0.8529), y: (width * 0.5136)), controlPoint2: CGPoint(x: (width * 0.8649), y: (width * 0.5021)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8946), y: (width * 0.4490)), controlPoint1: CGPoint(x: (width * 0.8835), y: (width * 0.4759)), controlPoint2: CGPoint(x: (width * 0.8898), y: (width * 0.4624)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.8999), y: (width * 0.4303)), controlPoint1: CGPoint(x: (width * 0.8968), y: (width * 0.4427)), controlPoint2: CGPoint(x: (width * 0.8986), y: (width * 0.4365)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9051), y: (width * 0.4274)), controlPoint1: CGPoint(x: (width * 0.9014), y: (width * 0.4295)), controlPoint2: CGPoint(x: (width * 0.9031), y: (width * 0.4286)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9339), y: (width * 0.4090)), controlPoint1: CGPoint(x: (width * 0.9121), y: (width * 0.4236)), controlPoint2: CGPoint(x: (width * 0.9222), y: (width * 0.4176)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9714), y: (width * 0.3733)), controlPoint1: CGPoint(x: (width * 0.9455), y: (width * 0.4003)), controlPoint2: CGPoint(x: (width * 0.9590), y: (width * 0.3889)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9883), y: (width * 0.3464)), controlPoint1: CGPoint(x: (width * 0.9777), y: (width * 0.3655)), controlPoint2: CGPoint(x: (width * 0.9835), y: (width * 0.3564)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9986), y: (width * 0.3129)), controlPoint1: CGPoint(x: (width * 0.9931), y: (width * 0.3363)), controlPoint2: CGPoint(x: (width * 0.9971), y: (width * 0.3248)))
        bezierPath.addCurve(to: CGPoint(x: (width * 0.9894), y: (width * 0.2469)), controlPoint1: CGPoint(x: (width * 1.0023), y: (width * 0.2889)), controlPoint2: CGPoint(x: (width * 0.9977), y: (width * 0.2654)))
        bezierPath.close()
        shape.path = bezierPath.cgPath
        shape.fillColor = whiteColor.cgColor
        cloudLayer = shape
        
        //// Oval Drawing
        let ovalShape = CAShapeLayer()
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: (width * 0.1250), y: (width * 0.6705), width: (width * 0.1334), height: (width * 0.1334)))
        ovalShape.path = ovalPath.cgPath
        ovalShape.fillColor = blackColor.cgColor
        
        
        //// Oval 2 Drawing
        let oval2Shape = CAShapeLayer()
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.1506), y: (width * 0.6996), width: (width * 0.0961), height: (width * 0.0961)))
        oval2Shape.path = oval2Path.cgPath
        oval2Shape.fillColor = whiteColor.cgColor
        
        
        //// Oval 3 Drawing
        let oval3Shape = CAShapeLayer()
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.1965), y: (width * 0.8236), width: (width * 0.0952), height: (width * 0.0952)))
        oval3Shape.path = oval3Path.cgPath
        oval3Shape.fillColor = blackColor.cgColor
        
        
        //// Oval 4 Drawing
        let oval4Shape = CAShapeLayer()
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2173), y: (width * 0.8332), width: (width * 0.0587), height: (width * 0.0587)))
        oval4Shape.path = oval4Path.cgPath
        oval4Shape.fillColor = whiteColor.cgColor
        
        
        //// Oval 5 Drawing
        let oval5Shape = CAShapeLayer()
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2789), y: (width * 0.9192), width: (width * 0.0518), height: (width * 0.0518)))
        oval5Shape.path = oval5Path.cgPath
        oval5Shape.fillColor = blackColor.cgColor
        
        //// Oval 6 Drawing
        let oval6Shape = CAShapeLayer()
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: (width * 0.2919), y: (width * 0.9335), width: (width * 0.0313), height: (width * 0.0313)))
        oval6Shape.path = oval6Path.cgPath
        oval6Shape.fillColor = whiteColor.cgColor
        
        return [shape, shape2, ovalShape, oval2Shape, oval3Shape, oval4Shape, oval5Shape, oval6Shape]
    }

}
