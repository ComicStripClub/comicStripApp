//
//  MainViewController.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/20/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit
import AVFoundation
import GPUImage

class MainViewController: UIViewController {
    let supportedFilters: [String: () -> ImageProcessingOperation] = [
        "Cartoon" : {
            return SmoothToonFilter()
//            let toonFilter = SmoothToonFilter()
//            toonFilter.blurRadiusInPixels = 5.0
//            toonFilter.threshold = 0.2
//            toonFilter.quantizationLevels = 10.0
//            return toonFilter
        },
        "Sketch" : {
            let sketchFilter = SketchFilter()
            sketchFilter.edgeStrength = 3.0
            return sketchFilter
        },
        "Pixelate" : { return Pixellate() },
        "Pop art" : { return PolkaDot() },
        "Cross hatch" : { return Crosshatch()}
    ]
    
    override var shouldAutorotate: Bool {
        get { return false }
    }
    var currentFrameCount = -1;
    @IBOutlet weak var comicStripContainer: ComicStripContainer!
    @IBOutlet weak var comicStylingToolbar: ComicStylingToolbar!
    var currentComicFrame: ComicFrame? { get { return comicStripContainer.selectedFrame } }
    var imagePickerTargetFrame: ComicFrame?
    var comicStrip: ComicStrip!
    var comicStripFactory: (() -> ComicStrip)!

    var camera: Camera!
    var cameraLocation: PhysicalCameraLocation = .backFacing
    var nextPicture: PictureOutput!
    
    var currentFilter: (key: String, value: () -> ImageProcessingOperation)? {
        didSet {
            comicStripContainer.currentFilter = currentFilter?.value
        }
    }
    
    var currentCameraFilter: ImageProcessingOperation?
    
    let imagePicker = UIImagePickerController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comicStrip = comicStripFactory()
        comicStripContainer.comicStrip = comicStrip
        for comicFrame in comicStrip.comicFrames {
            comicFrame.delegate = self
        }

        comicStripContainer.delegate = self
        
        comicStylingToolbar.delegate = self
        updateToolbar()

        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        currentFilter = (key: "Cartoon", value: supportedFilters["Cartoon"]!)

        if (isCameraAvailable()){
            initializeCamera()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let firstResponder = view.currentFirstResponder as? UIView {
                let focusRect = firstResponder.convert(firstResponder.bounds, to: nil)
                if (focusRect.intersects(keyboardFrame)){
                    let shift = keyboardFrame.minY - focusRect.maxY
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.view.transform = CGAffineTransform(translationX: 0, y: shift)
                    })
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @objc private func didTapView(_ tapGestureRecognizer: UITapGestureRecognizer){
       view.endEditing(true)
    }
    
    private func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func initializeCamera(){
        if let comicFrame = currentComicFrame {
            guard (isCameraAvailable()) else {
                return
            }
            do {
                camera = try Camera(sessionPreset: AVCaptureSessionPreset640x480, cameraDevice: nil, location: cameraLocation, captureAsYUV: true)
                let filter = currentFilter!.value()
                currentCameraFilter = filter
                camera.addTarget(filter)
                filter.addTarget(comicFrame.renderView)
                if (cameraLocation == .backFacing) {
                    comicFrame.renderView.orientation = .portrait
                    comicFrame.renderView.transform = CGAffineTransform.identity
                } else {
                    comicFrame.renderView.orientation = .portraitUpsideDown
                    comicFrame.renderView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
                camera.startCapture()
                comicFrame.isCapturing = true
            } catch {
                fatalError("Could not initialize rendering pipeline: \(error)")
            }
        }
    }
    
    func deinitializeCamera(){
        if let cam = camera {
            cam.stopCapture()
            cam.removeAllTargets()
            if let filter = currentCameraFilter {
                filter.removeAllTargets()
            }
            if let comicFrame = currentComicFrame {
                comicFrame.renderView.removeSourceAtIndex(0)
                comicFrame.isCapturing = false
            }
        }
        camera = nil
    }
    
    func updateToolbar() {
        if let comicFrame = currentComicFrame {
            comicStylingToolbar.mode = comicFrame.hasPhoto ? .editing : .capture
        } else {
            comicStylingToolbar.mode = .noActiveFrame
        }
    }
    
}

extension MainViewController: ComicFrameDelegate {

    func didTapCameraButton(_ sender: ComicFrame) {
        comicStripContainer.selectComicFrame(sender)
        initializeCamera()
    }
    
    func didTapGalleryButton(_ sender: ComicFrame) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        imagePickerTargetFrame = sender
        self.present(self.imagePicker, animated: true, completion: nil)
    }

        
        //        comicFrame.onClickShareCallback = {
        //            let image = self.comicFrame.asImage()
        //            let imageToShare = [ image ]
        //            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        //            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        //            getTopViewController()?.present(activityViewController, animated: true, completion: nil)
        //        }
        //
        
//    func getTopViewController() -> UIViewController?{
//        if var topController = UIApplication.shared.keyWindow?.rootViewController
//        {
//            while (topController.presentedViewController != nil)
//            {
//                topController = topController.presentedViewController!
//            }
//            return topController
//        }
//        return nil
//    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard (imagePickerTargetFrame != nil) else {
            fatalError("image was selected, but no comic frame is active")
        }

        var pickedImage: UIImage?
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            pickedImage = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            pickedImage = image
        } else{
            print("Could not load image")
        }
        
        if let pickedImage = pickedImage {
            imagePickerTargetFrame!.selectedPhoto = pickedImage
        }
        self.dismiss(animated: true) { 
            self.comicStripContainer.selectComicFrame(self.imagePickerTargetFrame)
            self.imagePickerTargetFrame = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerTargetFrame = nil
    }
}

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

protocol ComicStripContainerDelegate {
    func comicFrameBecameActive(_ comicFrame: ComicFrame)
    func comicFrameBecameInactive(_ comicFrame: ComicFrame)
}

extension MainViewController: ComicStripContainerDelegate {
    func comicFrameBecameActive(_ comicFrame: ComicFrame) {
        updateToolbar()
    }
    
    func comicFrameBecameInactive(_ comicFrame: ComicFrame) {
        
    }
}

class ComicStripContainer: UIView {
    var delegate: ComicStripContainerDelegate!
    var currentFilter: (() -> ImageProcessingOperation)? {
        didSet {
            selectedFrame?.currentFilter = currentFilter
        }
    }
    
    private var _selectedFrame: ComicFrame?
    var selectedFrame: ComicFrame? {
        get { return _selectedFrame }
    }
    
    var comicStrip: ComicStrip! {
        didSet {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            addSubview(comicStrip)
            // comicStrip.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapComicStrip))
        self.addGestureRecognizer(tapRecognizer)
        
//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanComicStrip))
//        self.addGestureRecognizer(panRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let myBounds = bounds
        comicStrip.frame = bounds
        if (selectedFrame != nil) {
            selectComicFrame(at: selectedFrame!.center)
        }
    }
    
    @objc private func didTapComicStrip(_ gestureRecognizer: UITapGestureRecognizer){
        selectComicFrame(at: gestureRecognizer.location(in: comicStrip))
        endEditing(true)
    }
    
    private var originalTransform: CGAffineTransform!
    @objc private func didPanComicStrip(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            originalTransform = comicStrip.transform
            break
        case .changed:
            let translation = gestureRecognizer.translation(in: self)
            comicStrip.transform = originalTransform.translatedBy(x: translation.x, y: translation.y)
            break
        case .ended:
            let comicFrame = comicStrip.comicFrames.min(by: { (f1, f2) -> Bool in
                let f1Center = convert(f1.center.applying(comicStrip.transform), to: self)
                let f2Center = convert(f2.center.applying(comicStrip.transform), to: self)
                return f1Center.distanceToPoint(p: center) < f2Center.distanceToPoint(p: center)
            })
            selectComicFrame(comicFrame)
            break
        default:
            // Handle cancellation or failure
            break
        }

    }
    
    func selectComicFrame(at point: CGPoint) {
        let comicFrame = comicStrip.getComicFrame(at: point)
        selectComicFrame(comicFrame)
    }
    
    func selectComicFrame(_ comicFrame: ComicFrame?) {
        guard (comicFrame != _selectedFrame) else {
            return
        }
        
        if let oldFrame = _selectedFrame {
            oldFrame.isActive = false
            delegate.comicFrameBecameInactive(oldFrame)
        }
        
        _selectedFrame = comicFrame
        _selectedFrame?.currentFilter = currentFilter
        
        if let comicFrame = comicFrame {
            comicFrame.isActive = true
            delegate.comicFrameBecameActive(comicFrame)
            var focusFrameTransform: CGAffineTransform
            let adjustedFrame = convert(comicFrame.frame, to: self)
            if (abs(adjustedFrame.width - bounds.width) < 1) {
                focusFrameTransform = CGAffineTransform.identity
            } else {
                let xRatio = adjustedFrame.width / (bounds.width - 20)
                let yRatio = adjustedFrame.height / (bounds.height - 20)
                let scale = xRatio > yRatio ? 1 / xRatio : 1 / yRatio
                let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
                let delta = CGPoint(x: center.x - adjustedFrame.midX, y: center.y - adjustedFrame.midY)
                focusFrameTransform = CGAffineTransform(scaleX: scale, y: scale).translatedBy(x: delta.x, y: delta.y)
            }
            UIView.animate(withDuration: 0.250, delay: 0, options: [.curveEaseOut], animations: { 
                self.comicStrip.transform = focusFrameTransform
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.250, delay: 0, options: [.curveEaseOut], animations: {
                self.comicStrip.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}

class FilterElement: ComicFrameElement {
    var actions: [UIBarButtonItem]? = nil
    lazy var effectFunc: (ComicFrame) -> Void = { (comicFrame) in
        comicFrame.currentFilter = self.factory
    }
    var icon: UIImage
    var type: ComicElementType = .style
    var view: UIView!
    var name: String?
    var factory: () -> ImageProcessingOperation
    init(name: String, filterIcon: UIImage, filterFactory: @escaping () -> ImageProcessingOperation) {
        self.factory = filterFactory
        self.icon = filterIcon
        self.name = name
    }
}

extension MainViewController: ComicStripToolbarDelegate {
  
    func didTapCaptureButton() {
        self.nextPicture = PictureOutput()
        nextPicture.imageAvailableCallback = { (image) in
            self.currentComicFrame!.selectedPhoto = image
            self.updateToolbar()
            self.camera.stopCapture()
            self.nextPicture = nil
        }
        self.camera.addTarget(nextPicture)
    }
    
    func didTapSwitchCameraButton() {
        deinitializeCamera()
        cameraLocation = (cameraLocation == .backFacing) ? .frontFacing : .backFacing
        initializeCamera()
    }
    
    func didTapSpeechBubbleButton() {
        let speechBubbles: [ComicFrameElement] = [
            ThoughtBubbleElement(),
            ClassicSpeechBubbleElement()]
        presentSelectionController(withElements: speechBubbles)
    }
    
    func didTapSoundEffectsButton() {
        let soundEffects: [ComicFrameElement] = [
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "wham")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "kaboom"))]
        presentSelectionController(withElements: soundEffects)
    }
    
    func didTapStyleButton() {
        var filterElements: [ComicFrameElement] = []
        for filter in supportedFilters {
            filterElements.append(FilterElement(name: filter.key, filterIcon: #imageLiteral(resourceName: "style_color"), filterFactory: filter.value))
        }
        presentSelectionController(withElements: filterElements)
    }
    
    func didTapGoToCaptureMode() {
        self.camera.startCapture()
        self.comicStylingToolbar.mode = .capture
    }
    
    func presentSelectionController(withElements elements: [ComicFrameElement]){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionNavController = storyboard.instantiateViewController(withIdentifier: "ComicElementSelectionNavController") as! UINavigationController
        let selectionViewController = selectionNavController.topViewController as! ComicElementSelectionViewController
        selectionViewController.comicFrameElements = elements
        selectionViewController.delegate = self
        present(selectionNavController, animated: true, completion: nil)
    }
}

extension MainViewController: ComicElementSelectionDelegate {
    
    func didCancel() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func didChooseComicElement(_ element: ComicFrameElement) {
        guard (currentComicFrame != nil) else {
            return
        }
        element.effectFunc(currentComicFrame!)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
