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

protocol ComicFrameDelegate {
    func didTapCameraButton(_ sender: ComicFrame)
    func didTapGalleryButton(_ sender: ComicFrame)
}

class ComicFrame: UIView {
    var delegate: ComicFrameDelegate?
    @IBOutlet weak var cameraButtonView: UIStackView!
    @IBOutlet weak var galleryButtonView: UIStackView!
    @IBOutlet weak var framePhoto: UIImageView!
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var renderView: RenderView!
    let imagePicker = UIImagePickerController()
    private var elements: [ComicFrameElement] = []
    private var currentGestureStartTransform: CGAffineTransform!
    private var elementToolbar: ISHHoverBar!
    private var commonActions: [UIBarButtonItem]!
    
    private var processedFramePhoto: RenderView?
    
    private var selectedElement: ComicFrameElement? {
        didSet {
            if selectedElement?.view != nil {
                elementToolbar.isHidden = false
                var items = commonActions!
                if let contextualActions = selectedElement!.actions {
                    items.append(contentsOf: contextualActions)
                }
                elementToolbar.items = items
                updateToolbarPosition()
            } else {
                elementToolbar.isHidden = true
            }
        }
    }
    
    var isActive: Bool = true {
        didSet {
            alpha = isActive ? 1.0 : 0.5
        }
    }
    
    
    func addProcessedFramePhoto() -> RenderView {
        if let currentPhoto = processedFramePhoto {
            currentPhoto.removeFromSuperview()
        }
        let newRenderView = RenderView(frame: contentView.bounds)
        newRenderView.fillMode = .preserveAspectRatioAndFill
        contentView.insertSubview(newRenderView, aboveSubview: renderView)
        processedFramePhoto = newRenderView
        return processedFramePhoto!
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
        
        renderView.fillMode = .preserveAspectRatioAndFill
        renderView.orientation = .portrait
        
        elementToolbar = ISHHoverBar()
        let deleteButton = UIBarButtonItem(image: UIImage.imageFromSystemBarButton(.trash), style: .plain, target: self, action: #selector(didDeleteElement))
        commonActions = [deleteButton]
        elementToolbar.items = commonActions
        elementToolbar.orientation = .vertical
        elementToolbar.isHidden = true
        addSubview(elementToolbar)
        
        let cameraTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        cameraButtonView.addGestureRecognizer(cameraTapRecognizer)
        let galleryTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapGalleryButton))
        galleryButtonView.addGestureRecognizer(galleryTapRecognizer)
        
    }
    
    @objc func didDeleteElement(_: UIBarButtonItem){
        removeElement(selectedElement!)
        selectedElement = nil
    }
    
    @objc private func didTapCameraButton(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.didTapCameraButton(self)
    }
    
    @objc private func didTapGalleryButton(_ tapRecognizer: UITapGestureRecognizer) {
        delegate?.didTapGalleryButton(self)
    }
    
    func addElement(_ element: ComicFrameElement, size: CGSize? = nil) {
        var finalSize: CGSize
        if (size == nil){
            let minFrameSideLength = min(bounds.width, bounds.height)
            finalSize = CGSize(width: minFrameSideLength / 3, height: minFrameSideLength / 3)
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
    
    // When point(inside:withEvent:) is called, use it to determine which ComicFrameElement
    // is under the tap/touch, and mark it as selected
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
                
                if (!elementToolbar.point(inside: convert(point, to: elementToolbar), with: event)){
                    selectedElement = candidate
                }
            }
        }
        return super.point(inside: point, with: event)
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
            updateToolbarPosition()
            break
        case .ended:
            break
        default:
            // Handle cancellation or failure
            break
        }
    }
    
    // Ensure the toolbar that appears for the selected ComicFrameElement stays
    // anchored to the top-right of the element.  If there's not enough space, 
    // move it to the left side of the element.
    private func updateToolbarPosition() {
        if let selectedView = selectedElement?.view {
            var x = selectedView.frame.maxX
            if (x + elementToolbar.intrinsicContentSize.width > contentView.frame.maxX) {
                x = max(contentView.frame.minX, selectedView.frame.minX - elementToolbar.intrinsicContentSize.width)
            }
            let y = min(max(0, selectedView.frame.origin.y), contentView.frame.maxY - elementToolbar.intrinsicContentSize.height)
            elementToolbar.frame = CGRect(
                origin: CGPoint(x: x, y: y),
                size: elementToolbar.intrinsicContentSize)
        }
    }
}
