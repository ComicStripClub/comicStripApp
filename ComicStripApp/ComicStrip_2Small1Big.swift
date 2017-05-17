//
//  ComicStrip_2Small1Big.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_2Small1Big: ComicStrip {
    class var numberOfFrames: Int { get { return 3 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2sm_1b"), size: CGSize(width: 707, height: 1115))
        }
    }
    class var icon: UIImage { get { return #imageLiteral(resourceName: "2sm_1b") } }

    class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 13, y: 11, width: 326, height: 407),
                CGRect(x: 367, y: 13, width: 331, height: 405),
                CGRect(x: 15, y: 438, width: 683, height: 665)]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_2Small1Big.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_2Small1Big.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_2Small1Big.frameCoordinates
    }
}
