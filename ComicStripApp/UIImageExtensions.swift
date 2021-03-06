//
//  UIImageExtensions.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/7/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    class func imageFromSystemBarButton(_ systemItem: UIBarButtonSystemItem, renderingMode:UIImageRenderingMode = .automatic)-> UIImage {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        UIToolbar().setItems([tempItem], animated: false)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return UIImage()
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
    
    func scaleImageToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        return image
    }
    
    func scaleImageToFitSize(size: CGSize, onlyScaleDown: Bool = false) -> UIImage {
        if (onlyScaleDown && (self.size.width < size.width || self.size.height < size.height)) {
            return self
        }
        let aspect = self.size.width / self.size.height
        if size.width / aspect <= size.height {
            return scaleImageToSize(size: CGSize(width: size.width, height: size.width / aspect))
        } else {
            return scaleImageToSize(size: CGSize(width: size.height * aspect, height: size.height))
        }
    }

    
    func fixedOrientation(currentOrientation: UIImageOrientation? = nil) -> UIImage {
        let currentOrientation: UIImageOrientation = currentOrientation ?? imageOrientation
        if currentOrientation == .up { return self }
        
        var transform:CGAffineTransform = .identity
        switch currentOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height).rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
        default: break
        }
        
        switch currentOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0).scaledBy(x: -1, y: 1)
        default: break
        }
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                            bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                            space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        
        switch currentOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height,height: size.width))
        default:
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width,height: size.height))
        }
        return UIImage(cgImage: ctx.makeImage()!)
    }
}

import GPUImage
extension ImageOrientation {
    static func fromOrientation(_ orientation: UIImageOrientation) -> ImageOrientation {
        switch orientation {
        case .upMirrored:
            fallthrough
        case .down:
            return .portraitUpsideDown
        case .left:
            fallthrough
        case .leftMirrored:
            return .landscapeRight
        case .right:
            fallthrough
        case .rightMirrored:
            return .landscapeLeft
        case .downMirrored:
            fallthrough
        default:
            return .portrait
        }
    }
}
