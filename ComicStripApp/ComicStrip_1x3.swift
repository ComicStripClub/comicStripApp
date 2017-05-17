//
//  ComicStrip_1x3.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit


class ComicStrip_1x3: ComicStrip {
    class var numberOfFrames: Int { get { return 3 } }
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_3x1"), size: CGSize(width: 707, height: 1115))
        }
    }
    class var icon: UIImage { get { return #imageLiteral(resourceName: "3x1") } }

    class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 5, y: 8, width: 691, height: 351),
                CGRect(x: 4, y: 382, width: 691, height: 352),
                CGRect(x: 3, y: 758, width: 691, height: 351)]
        }
    }
    
    required init?(_ coder: NSCoder? = nil) {
        super.init(coder)
    }
    override var frameLayoutBorders: (image: UIImage, size: CGSize) {
        return ComicStrip_1x3.frameLayoutBorders
    }
    override var numberOfFrames: Int {
        return ComicStrip_1x3.numberOfFrames
    }
    override var frameCoordinates: [CGRect] {
        return ComicStrip_1x3.frameCoordinates
    }
}
