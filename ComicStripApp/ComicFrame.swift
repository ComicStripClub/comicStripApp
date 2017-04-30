//
//  ComicFrame.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/29/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class ComicFrame: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var renderView: RenderView!

    private var elements: [ComicFrameElement] = []
    private var currentGestureStartTransform: CGAffineTransform!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "ComicFrame", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func addElement(_ element: ComicFrameElement, size: CGSize? = nil) {
        var finalSize: CGSize
        if (size == nil){
            let minFrameSideLength = min(bounds.width, bounds.height)
            finalSize = CGSize(width: minFrameSideLength / 2, height: minFrameSideLength / 2)
        } else {
            finalSize = size!
        }
        let elementView = element.view
        let topOffset = (bounds.height - finalSize.height) / 2
        let leftOffset = (bounds.width - finalSize.width) / 2
        elementView.frame = CGRect(origin: CGPoint(x: leftOffset, y: topOffset), size: finalSize)
        contentView.addSubview(elementView)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanElement))
        elementView.addGestureRecognizer(panRecognizer)
        
        elements.append(element)
    }
    
    @objc private func didPanElement(_ panGestureRecognizer: UIPanGestureRecognizer){
        let pannedElement = panGestureRecognizer.view!
        switch panGestureRecognizer.state {
        case .began:
            currentGestureStartTransform = pannedElement.transform
            break
        case .changed:
            let translation = panGestureRecognizer.translation(in: self)
            pannedElement.transform = currentGestureStartTransform.concatenating(CGAffineTransform(translationX: translation.x, y: translation.y))
//            let start = currentPanningOperationStartPoint!
//            let x = min(max(start.x + translation.x, -20), bounds.width - pannedElement.bounds.width + 20)
//            let y = min(max(start.y + translation.y, -20), bounds.height - pannedElement.bounds.height + 20)
//            pannedElement.frame.origin = CGPoint(x: x, y: y)
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
}
