//
//  ComicStrip_2Big.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_2Big: ComicStrip {
    class var numberOfFrames: Int { get { return 2 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2x1"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    class var icon: UIImage { get { return #imageLiteral(resourceName: "2x1") } }
   
    class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 7, y: 7, width: 688, height: 544),
                CGRect(x: 11, y: 568, width: 683, height: 541)]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_2Big.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_2Big.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_2Big.frameCoordinates
    }
}
