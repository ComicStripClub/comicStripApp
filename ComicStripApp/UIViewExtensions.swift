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
}

extension UIView {
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
}