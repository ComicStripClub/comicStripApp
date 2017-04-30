//
//  SoundEffect.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/30/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class SoundEffectElement: ComicFrameElement {
    var icon: UIImage
    var type: ComicElementType = .soundEffect
    var view: UIView
    lazy var effectFunc: (ComicFrame) -> Void = {(comicFrame) in
        comicFrame.addElement(self)
    }			
    init(soundEffectImg: UIImage) {
        icon = soundEffectImg
        let soundEffectImageView = SoundEffectImage()!
        soundEffectImageView.image = icon
        view = soundEffectImageView
    }
}

class SoundEffectImage: UIImageView {
    private var currentGestureStartTransform: CGAffineTransform!
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }
    
    init?(_ coder: NSCoder? = nil) {
        if let coder = coder {
            super.init(coder: coder)
        }
        else {
            super.init(frame: CGRect.zero)
        }
        
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinchImage))
        addGestureRecognizer(pinchRecognizer)
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(didRotateImage))
        addGestureRecognizer(rotationRecognizer)
    }
    
    @objc private func didPinchImage(_ pinchGestureRecognizer: UIPinchGestureRecognizer){
        switch pinchGestureRecognizer.state {
        case .began:
            currentGestureStartTransform = self.transform
            break
        case .changed:
            let scale = pinchGestureRecognizer.scale // * currentPinchGestureStartScale
            transform = currentGestureStartTransform.scaledBy(x: scale, y: scale) // CGAffineTransform(scaleX: scale, y: scale)
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
    
    @objc private func didRotateImage(_ rotationGestureRecognizer: UIRotationGestureRecognizer){
        switch rotationGestureRecognizer.state {
        case .began:
            currentGestureStartTransform = self.transform
            //currentRotationGestureStartValue = atan2f(t.b, t.a)
            break
        case .changed:
            transform = currentGestureStartTransform.rotated(by: rotationGestureRecognizer.rotation)
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
}
