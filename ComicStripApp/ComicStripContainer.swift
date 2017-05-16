//
//  ComicStripContainer.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class ComicStripContainer: UIView {
    var delegate: ComicStripContainerDelegate!
    var currentFilter: (key: String, value: () -> ImageProcessingOperation)? {
        didSet {
            selectedFrame?.currentFilter = currentFilter
        }
    }
    
    private var _selectedFrame: ComicFrame?
    var selectedFrame: ComicFrame? {
        get { return _selectedFrame }
    }
    
    var comicStrip: ComicStrip! {
        didSet {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            addSubview(comicStrip)
            if (comicStrip.comicFrames.count == 1){
                selectComicFrame(comicStrip.comicFrames[0])
            }
            // comicStrip.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapComicStrip))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        comicStrip.frame = bounds
        //comicStrip.bounds.size = CGSize(width: bounds.width - 32, height: bounds.height)
        //comicStrip.center = CGPoint(x: bounds.midX, y: bounds.midY)
        if (selectedFrame != nil) {
            selectComicFrame(at: selectedFrame!.center)
        }
    }
    
    @objc private func didTapComicStrip(_ gestureRecognizer: UITapGestureRecognizer){
        selectComicFrame(at: gestureRecognizer.location(in: comicStrip))
        endEditing(true)
    }
    
    func selectComicFrame(at point: CGPoint) {
        let comicFrame = comicStrip.getComicFrame(at: point)
        selectComicFrame(comicFrame)
    }
    
    func selectComicFrame(_ comicFrame: ComicFrame?) {
        guard (comicFrame != _selectedFrame) else {
            return
        }
        
        let oldFrame = _selectedFrame
        
        _selectedFrame = comicFrame
        _selectedFrame?.currentFilter = currentFilter
        
        if let oldFrame = oldFrame {
            oldFrame.isActive = false
            delegate.comicFrameBecameInactive(oldFrame)
        }
        
        if let comicFrame = comicFrame {
            comicFrame.isActive = true
            delegate.comicFrameBecameActive(comicFrame)
            var focusFrameTransform: CGAffineTransform
            let adjustedFrame = convert(comicFrame.frame, to: self)
            if (abs(adjustedFrame.width - bounds.width) < 1) {
                focusFrameTransform = CGAffineTransform.identity
            } else {
                let xRatio = adjustedFrame.width / (bounds.width - 20)
                let yRatio = adjustedFrame.height / (bounds.height - 20)
                let scale = xRatio > yRatio ? 1 / xRatio : 1 / yRatio
                let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                let delta = CGPoint(x: center.x - adjustedFrame.midX, y: center.y - adjustedFrame.midY)
                focusFrameTransform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: delta.x, y: delta.y)
            }
            UIView.animate(withDuration: 1.00, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -5, options: [.curveEaseIn], animations: {
                self.comicStrip.transform = focusFrameTransform
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 1.00, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: -5, options: [.curveEaseIn], animations: {
                self.comicStrip.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
