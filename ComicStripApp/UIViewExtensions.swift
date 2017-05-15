//
//  UIViewExtensions.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/30/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    class func createCircle(diameter: CGFloat, centeredAt point: CGPoint) -> UIView
    {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = true
        circle.frame.size = CGSize(width: diameter, height: diameter)
        circle.layer.cornerRadius = diameter / 2.0
        circle.center = point
        return circle
    }
    
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            self.drawHierarchy(in: bounds, afterScreenUpdates: false)
        }
    }
    
    var currentFirstResponder: UIResponder? {
        get {
            if self.isFirstResponder {
                return self
            }
            
            for view in self.subviews {
                if let responder = view.currentFirstResponder {
                    return responder
                }
            }
            
            return nil
        }
    }
    
    func startRotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = NSNumber(value: Double.pi*3)
        rotation.duration = 2
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}

extension CGPoint {
    func distanceToPoint(p:CGPoint) -> CGFloat {
        return sqrt(pow((p.x - x), 2) + pow((p.y - y), 2))
    }
}
