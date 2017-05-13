//
//  ComicStrip_1Big.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_1Big: ComicStrip {
    class var numberOfFrames: Int { get { return 1 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripFrame_SinglePortrait"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    class var frameCoordinates: [CGRect] {
        get {
            return [CGRect(x: 14, y: 11, width: 683, height: 1091)]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_1Big.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_1Big.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_1Big.frameCoordinates
    }
}
