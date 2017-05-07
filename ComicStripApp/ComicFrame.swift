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
    
    private var selectedElement: ComicFrameElement? {
        didSet {
            if let selectedView = selectedElement?.view {
                elementToolbar.isHidden = false
                elementToolbar.frame.origin = CGPoint(x: selectedView.frame.maxX, y: selectedView.frame.origin.y)
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
        elementToolbar.items = [deleteButton]
        elementToolbar.orientation = .vertical
        addSubview(elementToolbar)
        elementToolbar.frame.size = elementToolbar.intrinsicContentSize
        elementToolbar.isHidden = true
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
    
    @objc private func didPanElement(_ panGestureRecognizer: UIPanGestureRecognizer){
        let pannedElement = panGestureRecognizer.view!
        switch panGestureRecognizer.state {
        case .began:
            currentGestureStartTransform = pannedElement.transform
            selectedElement = elementFromView(pannedElement)
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
