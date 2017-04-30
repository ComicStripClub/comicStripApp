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
    private var currentPanningOperationStartPoint: CGPoint?
    
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
    
    func addElement(_ element: ComicFrameElement, size: CGSize) {
        let elementView = element.view
        let topOffset = (bounds.height - size.height) / 2
        let leftOffset = (bounds.width - size.width) / 2
        elementView.frame = CGRect(origin: CGPoint(x: leftOffset, y: topOffset), size: size)
        contentView.addSubview(elementView)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanElement))
        elementView.addGestureRecognizer(panRecognizer)
        
        elements.append(element)
    }
    
    @objc private func didPanElement(_ panGestureRecognizer: UIPanGestureRecognizer){
        let pannedElement = panGestureRecognizer.view!
        switch panGestureRecognizer.state {
        case .began:
            currentPanningOperationStartPoint = pannedElement.frame.origin
            break
        case .changed:
            let start = currentPanningOperationStartPoint!
            let translation = panGestureRecognizer.translation(in: self)
            let x = min(max(start.x + translation.x, -20), bounds.width - pannedElement.bounds.width + 20)
            let y = min(max(start.y + translation.y, -20), bounds.height - pannedElement.bounds.height + 20)
            pannedElement.frame.origin = CGPoint(x: x, y: y)
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
}
