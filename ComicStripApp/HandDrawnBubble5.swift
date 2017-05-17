//
//  HandDrawnBubble5.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/15/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class HandDrawnBubble5Element: ComicFrameElement {
    var name: String?
    var icon: UIImage = #imageLiteral(resourceName: "handDrawnBox")
    var type: ComicElementType = .dialogBubble
    lazy var view: UIView! = HandDrawnBubble5(nil)!
    lazy var effectFunc: (ComicFrame) -> Void = {(comicFrame) in
        comicFrame.addElement(self, aspectRatio: HandDrawnBubble5.aspectRatio)
    }
    var actions: [UIBarButtonItem]? { get { return (view as! BaseDialogBubble).actions } }
}

class HandDrawnBubble5: BaseDialogBubble {
    class var aspectRatio: CGFloat { get { return 2.204 } }
    
    override init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    
    override func drawBackgroundShapes(width: CGFloat, height: CGFloat) -> (shapes: [CAShapeLayer], mainBubblePath: UIBezierPath) {
        //// Color Declarations
        let fillColor2 = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)
        
        //// layer1
        //// path3654 Drawing
        let shapeLayer = CAShapeLayer()
        let path3654Path = UIBezierPath()
        path3654Path.move(to: CGPoint(x: (width * 0.0044), y: (height * 0.2622)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0059), y: (height * 0.1356)), controlPoint1: CGPoint(x: (width * 0.0051), y: (height * 0.2492)), controlPoint2: CGPoint(x: (width * 0.0058), y: (height * 0.1923)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0073), y: (height * 0.0257)), controlPoint1: CGPoint(x: (width * 0.0060), y: (height * 0.0788)), controlPoint2: CGPoint(x: (width * 0.0067), y: (height * 0.0294)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0175), y: (height * 0.0095)), controlPoint1: CGPoint(x: (width * 0.0079), y: (height * 0.0220)), controlPoint2: CGPoint(x: (width * 0.0125), y: (height * 0.0147)))
        path3654Path.addLine(to: CGPoint(x: (width * 0.0265), y: (height * 0.0000)))
        path3654Path.addLine(to: CGPoint(x: (width * 0.2984), y: (height * 0.0002)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.7089), y: (height * 0.0099)), controlPoint1: CGPoint(x: (width * 0.5792), y: (height * 0.0004)), controlPoint2: CGPoint(x: (width * 0.6443), y: (height * 0.0020)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9809), y: (height * 0.0084)), controlPoint1: CGPoint(x: (width * 0.7491), y: (height * 0.0148)), controlPoint2: CGPoint(x: (width * 0.9707), y: (height * 0.0136)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9909), y: (height * 0.0133)), controlPoint1: CGPoint(x: (width * 0.9852), y: (height * 0.0062)), controlPoint2: CGPoint(x: (width * 0.9879), y: (height * 0.0075)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9963), y: (height * 0.0958)), controlPoint1: CGPoint(x: (width * 0.9948), y: (height * 0.0205)), controlPoint2: CGPoint(x: (width * 0.9952), y: (height * 0.0263)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9995), y: (height * 0.2238)), controlPoint1: CGPoint(x: (width * 0.9969), y: (height * 0.1368)), controlPoint2: CGPoint(x: (width * 0.9983), y: (height * 0.1944)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9982), y: (height * 0.6462)), controlPoint1: CGPoint(x: (width * 1.00), y: (height * 0.2729)), controlPoint2: CGPoint(x: (width * 1.00), y: (height * 0.3303)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9964), y: (height * 0.8462)), controlPoint1: CGPoint(x: (width * 0.9979), y: (height * 0.6849)), controlPoint2: CGPoint(x: (width * 0.9970), y: (height * 0.7749)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9934), y: (height * 0.9832)), controlPoint1: CGPoint(x: (width * 0.9957), y: (height * 0.9175)), controlPoint2: CGPoint(x: (width * 0.9944), y: (height * 0.9792)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9621), y: (height * 0.9940)), controlPoint1: CGPoint(x: (width * 0.9920), y: (height * 0.9893)), controlPoint2: CGPoint(x: (width * 0.9869), y: (height * 0.9910)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.8124), y: (height * 0.9950)), controlPoint1: CGPoint(x: (width * 0.9220), y: (height * 0.9988)), controlPoint2: CGPoint(x: (width * 0.8639), y: (height * 0.9992)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.7253), y: (height * 0.9952)), controlPoint1: CGPoint(x: (width * 0.7890), y: (height * 0.9931)), controlPoint2: CGPoint(x: (width * 0.7498), y: (height * 0.9932)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.6450), y: (height * 0.9953)), controlPoint1: CGPoint(x: (width * 0.7008), y: (height * 0.9972)), controlPoint2: CGPoint(x: (width * 0.6647), y: (height * 0.9973)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.4978), y: (height * 0.9898)), controlPoint1: CGPoint(x: (width * 0.6253), y: (height * 0.9934)), controlPoint2: CGPoint(x: (width * 0.5591), y: (height * 0.9909)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.3333), y: (height * 0.9869)), controlPoint1: CGPoint(x: (width * 0.4366), y: (height * 0.9888)), controlPoint2: CGPoint(x: (width * 0.3626), y: (height * 0.9875)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.1459), y: (height * 0.9966)), controlPoint1: CGPoint(x: (width * 0.2707), y: (height * 0.9858)), controlPoint2: CGPoint(x: (width * 0.1850), y: (height * 0.9902)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.1154), y: (height * 0.9958)), controlPoint1: CGPoint(x: (width * 0.1243), y: (height * 1.00)), controlPoint2: CGPoint(x: (width * 0.1176), y: (height * 0.9999)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0575), y: (height * 0.9912)), controlPoint1: CGPoint(x: (width * 0.1132), y: (height * 0.9918)), controlPoint2: CGPoint(x: (width * 0.0989), y: (height * 0.9906)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0011), y: (height * 0.9866)), controlPoint1: CGPoint(x: (width * 0.0153), y: (height * 0.9918)), controlPoint2: CGPoint(x: (width * 0.0022), y: (height * 0.9907)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0024), y: (height * 0.8650)), controlPoint1: CGPoint(x: -0.53, y: (height * 0.9794)), controlPoint2: CGPoint(x: (width * 0.0002), y: (height * 0.8780)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0039), y: (height * 0.2984)), controlPoint1: CGPoint(x: (width * 0.0043), y: (height * 0.8541)), controlPoint2: CGPoint(x: (width * 0.0057), y: (height * 0.3025)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0044), y: (height * 0.2622)), controlPoint1: CGPoint(x: (width * 0.0090), y: (height * 0.3028)), controlPoint2: CGPoint(x: (width * 0.0037), y: (height * 0.2742)))
        path3654Path.close()
        path3654Path.move(to: CGPoint(x: (width * 0.1358), y: (height * 0.9700)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.2452), y: (height * 0.9656)), controlPoint1: CGPoint(x: (width * 0.1864), y: (height * 0.9699)), controlPoint2: CGPoint(x: (width * 0.2356), y: (height * 0.9679)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.3178), y: (height * 0.9620)), controlPoint1: CGPoint(x: (width * 0.2548), y: (height * 0.9632)), controlPoint2: CGPoint(x: (width * 0.2875), y: (height * 0.9616)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.4049), y: (height * 0.9626)), controlPoint1: CGPoint(x: (width * 0.3481), y: (height * 0.9625)), controlPoint2: CGPoint(x: (width * 0.3874), y: (height * 0.9627)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.5017), y: (height * 0.9664)), controlPoint1: CGPoint(x: (width * 0.4225), y: (height * 0.9625)), controlPoint2: CGPoint(x: (width * 0.4660), y: (height * 0.9642)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9378), y: (height * 0.9720)), controlPoint1: CGPoint(x: (width * 0.5892), y: (height * 0.9717)), controlPoint2: CGPoint(x: (width * 0.8854), y: (height * 0.9756)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9823), y: (height * 0.9602)), controlPoint1: CGPoint(x: (width * 0.9780), y: (height * 0.9693)), controlPoint2: CGPoint(x: (width * 0.9801), y: (height * 0.9688)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9863), y: (height * 0.1373)), controlPoint1: CGPoint(x: (width * 0.9866), y: (height * 0.9433)), controlPoint2: CGPoint(x: (width * 0.9892), y: (height * 0.4034)))
        path3654Path.addLine(to: CGPoint(x: (width * 0.9852), y: (height * 0.0316)))
        path3654Path.addLine(to: CGPoint(x: (width * 0.9588), y: (height * 0.0324)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9283), y: (height * 0.0365)), controlPoint1: CGPoint(x: (width * 0.9443), y: (height * 0.0329)), controlPoint2: CGPoint(x: (width * 0.9306), y: (height * 0.0347)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.9087), y: (height * 0.0364)), controlPoint1: CGPoint(x: (width * 0.9260), y: (height * 0.0383)), controlPoint2: CGPoint(x: (width * 0.9172), y: (height * 0.0382)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.8838), y: (height * 0.0362)), controlPoint1: CGPoint(x: (width * 0.9002), y: (height * 0.0345)), controlPoint2: CGPoint(x: (width * 0.8890), y: (height * 0.0344)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.8657), y: (height * 0.0354)), controlPoint1: CGPoint(x: (width * 0.8785), y: (height * 0.0381)), controlPoint2: CGPoint(x: (width * 0.8705), y: (height * 0.0377)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.7954), y: (height * 0.0354)), controlPoint1: CGPoint(x: (width * 0.8554), y: (height * 0.0304)), controlPoint2: CGPoint(x: (width * 0.8322), y: (height * 0.0304)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.7422), y: (height * 0.0357)), controlPoint1: CGPoint(x: (width * 0.7808), y: (height * 0.0374)), controlPoint2: CGPoint(x: (width * 0.7568), y: (height * 0.0375)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.5056), y: (height * 0.0249)), controlPoint1: CGPoint(x: (width * 0.6818), y: (height * 0.0283)), controlPoint2: CGPoint(x: (width * 0.6468), y: (height * 0.0267)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.2113), y: (height * 0.0251)), controlPoint1: CGPoint(x: (width * 0.2726), y: (height * 0.0220)), controlPoint2: CGPoint(x: (width * 0.2351), y: (height * 0.0220)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.1591), y: (height * 0.0268)), controlPoint1: CGPoint(x: (width * 0.1991), y: (height * 0.0267)), controlPoint2: CGPoint(x: (width * 0.1756), y: (height * 0.0275)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0203), y: (height * 0.0289)), controlPoint1: CGPoint(x: (width * 0.0958), y: (height * 0.0244)), controlPoint2: CGPoint(x: (width * 0.0219), y: (height * 0.0255)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0161), y: (height * 0.3112)), controlPoint1: CGPoint(x: (width * 0.0187), y: (height * 0.0325)), controlPoint2: CGPoint(x: (width * 0.0154), y: (height * 0.2556)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0149), y: (height * 0.8836)), controlPoint1: CGPoint(x: (width * 0.0172), y: (height * 0.3901)), controlPoint2: CGPoint(x: (width * 0.0163), y: (height * 0.8076)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.0323), y: (height * 0.9721)), controlPoint1: CGPoint(x: (width * 0.0131), y: (height * 0.9824)), controlPoint2: CGPoint(x: (width * 0.0118), y: (height * 0.9756)))
        path3654Path.addCurve(to: CGPoint(x: (width * 0.1358), y: (height * 0.9700)), controlPoint1: CGPoint(x: (width * 0.0387), y: (height * 0.9710)), controlPoint2: CGPoint(x: (width * 0.0853), y: (height * 0.9700)))
        path3654Path.close()
        shapeLayer.path = path3654Path.cgPath
        shapeLayer.fillColor = UIColor.black.cgColor
        
        
        
        
        //// layer
        //// path Drawing
        let whiteBackground = CAShapeLayer()
        let pathPath = UIBezierPath()
        pathPath.move(to: CGPoint(x: (width * 0.1358), y: (height * 0.9700)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.2452), y: (height * 0.9656)), controlPoint1: CGPoint(x: (width * 0.1864), y: (height * 0.9699)), controlPoint2: CGPoint(x: (width * 0.2356), y: (height * 0.9679)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.3178), y: (height * 0.9620)), controlPoint1: CGPoint(x: (width * 0.2548), y: (height * 0.9632)), controlPoint2: CGPoint(x: (width * 0.2875), y: (height * 0.9616)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.4049), y: (height * 0.9626)), controlPoint1: CGPoint(x: (width * 0.3481), y: (height * 0.9625)), controlPoint2: CGPoint(x: (width * 0.3874), y: (height * 0.9627)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.5017), y: (height * 0.9664)), controlPoint1: CGPoint(x: (width * 0.4225), y: (height * 0.9625)), controlPoint2: CGPoint(x: (width * 0.4660), y: (height * 0.9642)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.9378), y: (height * 0.9720)), controlPoint1: CGPoint(x: (width * 0.5892), y: (height * 0.9717)), controlPoint2: CGPoint(x: (width * 0.8854), y: (height * 0.9756)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.9823), y: (height * 0.9602)), controlPoint1: CGPoint(x: (width * 0.9780), y: (height * 0.9693)), controlPoint2: CGPoint(x: (width * 0.9801), y: (height * 0.9688)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.9863), y: (height * 0.1373)), controlPoint1: CGPoint(x: (width * 0.9866), y: (height * 0.9433)), controlPoint2: CGPoint(x: (width * 0.9892), y: (height * 0.4034)))
        pathPath.addLine(to: CGPoint(x: (width * 0.9852), y: (height * 0.0316)))
        pathPath.addLine(to: CGPoint(x: (width * 0.9588), y: (height * 0.0324)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.9283), y: (height * 0.0365)), controlPoint1: CGPoint(x: (width * 0.9443), y: (height * 0.0329)), controlPoint2: CGPoint(x: (width * 0.9306), y: (height * 0.0347)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.9087), y: (height * 0.0364)), controlPoint1: CGPoint(x: (width * 0.9260), y: (height * 0.0383)), controlPoint2: CGPoint(x: (width * 0.9172), y: (height * 0.0382)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.8838), y: (height * 0.0362)), controlPoint1: CGPoint(x: (width * 0.9002), y: (height * 0.0345)), controlPoint2: CGPoint(x: (width * 0.8890), y: (height * 0.0344)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.8657), y: (height * 0.0354)), controlPoint1: CGPoint(x: (width * 0.8785), y: (height * 0.0381)), controlPoint2: CGPoint(x: (width * 0.8705), y: (height * 0.0377)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.7954), y: (height * 0.0354)), controlPoint1: CGPoint(x: (width * 0.8554), y: (height * 0.0304)), controlPoint2: CGPoint(x: (width * 0.8322), y: (height * 0.0304)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.7422), y: (height * 0.0357)), controlPoint1: CGPoint(x: (width * 0.7808), y: (height * 0.0374)), controlPoint2: CGPoint(x: (width * 0.7568), y: (height * 0.0375)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.5056), y: (height * 0.0249)), controlPoint1: CGPoint(x: (width * 0.6818), y: (height * 0.0283)), controlPoint2: CGPoint(x: (width * 0.6468), y: (height * 0.0267)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.2113), y: (height * 0.0251)), controlPoint1: CGPoint(x: (width * 0.2726), y: (height * 0.0220)), controlPoint2: CGPoint(x: (width * 0.2351), y: (height * 0.0220)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.1591), y: (height * 0.0268)), controlPoint1: CGPoint(x: (width * 0.1991), y: (height * 0.0267)), controlPoint2: CGPoint(x: (width * 0.1756), y: (height * 0.0275)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.0203), y: (height * 0.0289)), controlPoint1: CGPoint(x: (width * 0.0958), y: (height * 0.0244)), controlPoint2: CGPoint(x: (width * 0.0219), y: (height * 0.0255)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.0161), y: (height * 0.3112)), controlPoint1: CGPoint(x: (width * 0.0187), y: (height * 0.0325)), controlPoint2: CGPoint(x: (width * 0.0154), y: (height * 0.2556)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.0149), y: (height * 0.8836)), controlPoint1: CGPoint(x: (width * 0.0172), y: (height * 0.3901)), controlPoint2: CGPoint(x: (width * 0.0163), y: (height * 0.8076)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.0323), y: (height * 0.9721)), controlPoint1: CGPoint(x: (width * 0.0131), y: (height * 0.9824)), controlPoint2: CGPoint(x: (width * 0.0118), y: (height * 0.9756)))
        pathPath.addCurve(to: CGPoint(x: (width * 0.1358), y: (height * 0.9700)), controlPoint1: CGPoint(x: (width * 0.0387), y: (height * 0.9710)), controlPoint2: CGPoint(x: (width * 0.0853), y: (height * 0.9700)))
        pathPath.close()
        whiteBackground.path = pathPath.cgPath
        whiteBackground.fillColor = UIColor.white.withAlphaComponent(0.9).cgColor
        
        return (shapes: [whiteBackground, shapeLayer], mainBubblePath: pathPath)

    }
}
