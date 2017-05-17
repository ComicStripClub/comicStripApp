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
    func didTapAddPhotoToFrame(_ sender: ComicFrame)
}

class ComicFrame: UIView {
    var delegate: ComicFrameDelegate?
    @IBOutlet weak var addImageButton: UIButton!
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
            if let oldElement = oldValue {
                oldElement.view.layer.removeObserver(self, forKeyPath: "position")
            }
            if let selectedElementView = selectedElement?.view {
                elementToolbar.isHidden = false
                selectedElementView.layer.addObserver(self, forKeyPath: "position", options: .new, context: nil)
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
    
    var isActive: Bool = false {
        didSet {
            isUserInteractionEnabled = isActive
            updateAddImageButtonVisibility()
            if (!isActive) {
                selectedElement = nil
            }
        }
    }
    
    var hasPhoto: Bool { get { return selectedPhoto != nil || processedFramePhoto != nil } }
    
    var isCapturing: Bool = false {
        didSet {
            if (isCapturing){
                if let currentPhoto = processedFramePhoto {
                    currentPhoto.removeFromSuperview()
                }
            }
            updateAddImageButtonVisibility()
        }
    }
    
    private func updateAddImageButtonVisibility() {
        addImageButton.isHidden = (hasPhoto || isCapturing)
    }
    
    
    private var _currentFilter: (key: String, value: () -> ImageProcessingOperation)?
    var currentFilter: (key: String, value: () -> ImageProcessingOperation)? {
        get { return _currentFilter }
        set(newFilter) {
            if (newFilter?.key != _currentFilter?.key){
                _currentFilter = newFilter
                updateImageWithCurrentFilter()
            }
        }
    }
    
    var selectedPhoto: UIImage? {
        didSet {
            updateImageWithCurrentFilter()
            updateAddImageButtonVisibility()
        }
    }
    
    private var pictureInput: PictureInput!
    private func updateImageWithCurrentFilter() {
        if let filter = currentFilter?.value(), let photo = selectedPhoto {
            pictureInput = PictureInput(image: photo/*, smoothlyScaleOutput: true, orientation: ImageOrientation.fromOrientation(pickedImage.imageOrientation)*/)
            pictureInput.addTarget(filter)
            let renderView = addProcessedFramePhoto()
            renderView.orientation = ImageOrientation.fromOrientation(photo.imageOrientation)
            filter.addTarget(renderView)
            pictureInput.processImage(synchronously: false)
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
        addSubview(contentView)
        contentView.frame = bounds
        
        renderView.fillMode = .preserveAspectRatioAndFill
        renderView.orientation = .portrait
        
        elementToolbar = ISHHoverBar()
        let deleteButton = UIBarButtonItem(image: UIImage.imageFromSystemBarButton(.trash), style: .plain, target: self, action: #selector(didDeleteElement))
        commonActions = [deleteButton]
        elementToolbar.items = commonActions
        elementToolbar.orientation = .vertical
        elementToolbar.isHidden = true
        addSubview(elementToolbar)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userDidTapComicFrame))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func userDidTapComicFrame(_ sender: Any){
        if (!addImageButton.isHidden){
            delegate?.didTapAddPhotoToFrame(self)
        } else {
            endEditing(true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "position" && (object as AnyObject).isEqual(selectedElement?.view.layer) == true) {
            updateToolbarPosition()
        }
    }

    @objc func didDeleteElement(_: UIBarButtonItem){
        removeElement(selectedElement!)
        selectedElement = nil
    }
    
    @IBAction func didTapAddPhotoButton(_ sender: Any) {
        delegate?.didTapAddPhotoToFrame(self)
    }
    
    func addElement(_ element: ComicFrameElement, aspectRatio: CGFloat = 1.0) {
        var finalSize: CGSize
        let minFrameSideLength = min(bounds.width, bounds.height)
        let width = minFrameSideLength * 0.6
        finalSize = CGSize(width: width, height: width / aspectRatio)

        let elementView = element.view!
        elementView.isUserInteractionEnabled = true
        elementView.translatesAutoresizingMaskIntoConstraints = true
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
            let superviewTransform = superview!.transform
            let rect = CGRect(
                origin: CGPoint(x: x, y: y),
                size: elementToolbar.intrinsicContentSize.applying(superviewTransform.inverted())).applying(transform)
            elementToolbar.frame = rect
            elementToolbar.transform = superviewTransform.inverted()
        }
    }
}
