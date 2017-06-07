//
//  ComicStrip_1Big.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_1Big1Small: ComicStrip {
    class var numberOfFrames: Int { get { return 2 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_1b_1sm"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    class var icon: UIImage { get { return #imageLiteral(resourceName: "1b_1sm") } }
    
    class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 14, y: 12, width: 687, height: 668),
                CGRect(x: 16, y: 703, width: 685, height: 402)
            ]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_1Big1Small.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_1Big1Small.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_1Big1Small.frameCoordinates
    }
}
