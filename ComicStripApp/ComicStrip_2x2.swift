//
//  ComicStrip_1Big.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_2x2: ComicStrip {
    class var numberOfFrames: Int { get { return 1 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2x2"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    class var icon: UIImage { get { return #imageLiteral(resourceName: "2x2") } }
    
    class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 11, y: 14, width: 336, height: 533),
                CGRect(x: 362, y: 14, width: 336, height: 534),
                CGRect(x: 11, y: 564, width: 336, height: 533),
                CGRect(x: 361, y: 564, width: 336, height: 533),
            ]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_2x2.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_2x2.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_2x2.frameCoordinates
    }
}
