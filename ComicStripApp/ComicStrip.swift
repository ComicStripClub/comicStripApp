//
//  File.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicStrip_1x3: ComicStrip {
    override class var numberOfFrames: Int { get { return 3 } }
    override class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_3LanscapeStacked"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    override class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 13, y: 11, width: 326, height: 407),
                CGRect(x: 367, y: 13, width: 331, height: 405),
                CGRect(x: 15, y: 438, width: 683, height: 665)]
        }
    }
}

class ComicStrip_2Small1Big: ComicStrip {
    override class var numberOfFrames: Int { get { return 3 } }
    override class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2Small1Big"), size: CGSize(width: 707, height: 1115))
        }
    }
    
    override class var frameCoordinates: [CGRect] {
        get {
            return [
                CGRect(x: 13, y: 11, width: 326, height: 407),
                CGRect(x: 367, y: 13, width: 331, height: 405),
                CGRect(x: 15, y: 438, width: 683, height: 665)]
        }
    }
}

class ComicStrip: UIView {
    class var frameLayoutBorders: (image: UIImage, size: CGSize) {
        get {
            return (image: #imageLiteral(resourceName: "ComicStripLayout_2Small1Big"), size: CGSize(width: 707, height: 1115))
        }
    }
        // (image: #imageLiteral(resourceName: "ComicStripFrame_SinglePortrait"), size: CGSize(width: 707, height: 1115))
    class var numberOfFrames: Int { get { return 3 } }
    class var frameCoordinates: [CGRect] {
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
    
    required init?(coder aDecoder: NSCoder) {
        self.comicFrames = []
        for _ in 0..<numberOfFrames {
            let comicFrame = ComicFrame(coder: aDecoder)!
            comicFrame.translatesAutoresizingMaskIntoConstraints = false
            comicFrames.append(comicFrame)
        }
        super.init(coder: aDecoder)
        for comicFrame in comicFrames {
            addSubview(comicFrame)
        }
        
        frameLayoutImageView = UIImageView(image: frameLayoutBorders.image)
        addSubview(frameLayoutImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (i, comicFrame) in comicFrames.enumerated() {
            let coords = frameCoordinates[i]
            let scaleX = bounds.width / frameLayoutBorders.size.width
            let scaleY = bounds.height / frameLayoutBorders.size.height
            comicFrame.frame = CGRect(x: scaleX * coords.minX, y: scaleY * coords.minY, width: scaleX * coords.width, height: scaleY * coords.height)
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
