//
//  File.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

// Represents a complete 'comic strip' containing one or more frames.
// Handles the creation and positioning of each of the frames (ComicFrame)
// within the strip
class ComicStrip: UIView {
    var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2Small1Big"), size: CGSize(width: 707, height: 1115))
        }
    }
        // (image: #imageLiteral(resourceName: "ComicStripFrame_SinglePortrait"), size: CGSize(width: 707, height: 1115))
    var numberOfFrames: Int { get { return 3 } }
    var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 13, y: 11, width: 326, height: 407),
                CGRect(x: 367, y: 13, width: 331, height: 405),
                CGRect(x: 15, y: 438, width: 683, height: 665)]
        }
    }
        // [CGRect(x: 13, y:11, width: 682, height: 1092)]
    var comicFrames: [ComicFrame]
    var frameLayoutImageView: UIImageView!
    var selectedFrameIndex: Int = 0 {
        didSet {
            // Move selected view into frame, hide inactive ones
        }
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
        
    required init?(_ coder: NSCoder? = nil) {
        self.comicFrames = []
        if (coder != nil){
            super.init(coder: coder!)
        } else {
            super.init(frame: CGRect.zero)
        }
        
        for _ in 0..<numberOfFrames {
            let comicFrame = ComicFrame()
            comicFrame.clipsToBounds = true
            comicFrames.append(comicFrame)
            addSubview(comicFrame)
        }
        
        frameLayoutImageView = UIImageView(image: frameLayoutBorders.image)
        addSubview(frameLayoutImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let myBounds = bounds
        for (i, comicFrame) in comicFrames.enumerated() {
            let coords = frameCoordinates[i]
            let scaleX = bounds.width / frameLayoutBorders.size.width
            let scaleY = bounds.height / frameLayoutBorders.size.height
            let newFrame = CGRect(x: scaleX * coords.minX, y: scaleY * coords.minY, width: scaleX * coords.width, height: scaleY * coords.height)
            comicFrame.frame = newFrame
        }
        frameLayoutImageView.frame = bounds
    }
    
    func getComicFrame(at point: CGPoint) -> ComicFrame? {
        // let transformedPoint = point.applying(transform)
        for comicFrame in comicFrames {
            if comicFrame.frame.contains(point) {
                return comicFrame
            }
        }
        return nil
    }
}
