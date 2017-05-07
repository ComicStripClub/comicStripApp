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
import ISHHoverBar

class ComicFrame: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var renderView: RenderView!

    private var elements: [ComicFrameElement] = []
    private var currentGestureStartTransform: CGAffineTransform!
    private var elementToolbar: ISHHoverBar!
    private var commonActions: [UIBarButtonItem]!
    
    private var selectedElement: ComicFrameElement? {
        didSet {
            if let selectedView = selectedElement?.view {
                elementToolbar.isHidden = false
                var items = commonActions!
                if let contextualActions = selectedElement!.actions {
                    items.append(contentsOf: contextualActions)
                }
                elementToolbar.items = items
                elementToolbar.frame = CGRect(
                    origin: CGPoint(x: selectedView.frame.maxX, y: selectedView.frame.origin.y),
                    size: elementToolbar.intrinsicContentSize)
            } else {
                elementToolbar.isHidden = true
            }
        }
    }
    
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
        
        elementToolbar = ISHHoverBar()
        let deleteButton = UIBarButtonItem(image: UIImage.imageFromSystemBarButton(.trash), style: .plain, target: self, action: #selector(didDeleteElement))
        commonActions = [deleteButton]
        elementToolbar.items = commonActions
        elementToolbar.orientation = .vertical
        elementToolbar.isHidden = true
        addSubview(elementToolbar)
        
    }
    
    @objc func didDeleteElement(_: UIBarButtonItem){
        removeElement(selectedElement!)
        selectedElement = nil
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
        elementView.isUserInteractionEnabled = true
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanElement))
        elementView.addGestureRecognizer(panRecognizer)
        elements.append(element)
    }
    
    private func removeElement(_ element: ComicFrameElement){
        for (i, el) in elements.enumerated() {
            if (el.view.isEqual(element.view)){
                elements.remove(at: i)
                element.view.removeFromSuperview()
                break
            }
        }
    }
    
    private func elementFromView(_ view: UIView) -> ComicFrameElement? {
        for e in elements {
            if (view.isEqual(e.view)){
                return e
            }
        }
        return nil
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let eventType = event?.type {
            if (eventType == .touches) {
                var candidate: ComicFrameElement?
                for element in elements {
                    let elPoint = convert(point, to: element.view)
                    if (element.view.point(inside: elPoint, with: event)){
                        candidate = element
                        break
                    }
                }
                selectedElement = candidate
            }
        }
        return super.point(inside: point, with: event)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        var candidate: ComicFrameElement?
//        for touch in touches {
//            let touchPoint = touch.location(in: self)
//            for element in elements {
//                if (element.view.frame.contains(touchPoint)){
//                    if (candidate == nil){
//                        candidate = element
//                    } else if (!candidate!.view.isEqual(element.view)){
//                        candidate = nil
//                        break
//                    }
//                }
//            }
//        }
//        selectedElement = candidate
//    }
    
    @objc private func didPanElement(_ panGestureRecognizer: UIPanGestureRecognizer){
        let pannedElement = panGestureRecognizer.view!
        switch panGestureRecognizer.state {
        case .began:
            currentGestureStartTransform = pannedElement.transform
            break
        case .changed:
            let translation = panGestureRecognizer.translation(in: self)
            pannedElement.transform = currentGestureStartTransform.concatenating(CGAffineTransform(translationX: translation.x, y: translation.y))
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
}
