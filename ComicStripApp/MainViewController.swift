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

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let supportedFilters: [String: () -> ImageProcessingOperation] = [
        "SmoothToonFilter" : {
            let toonFilter = SmoothToonFilter()
            toonFilter.blurRadiusInPixels = 5.0
            toonFilter.threshold = 0.2
            toonFilter.quantizationLevels = 10.0
            return toonFilter
        },
        "Posterize" : { return Posterize() },
        "Pixelate" : { return Pixellate() }
    ]
    
    override var shouldAutorotate: Bool {
        get { return false }
    }
    var currentFrameCount = -1;
    @IBOutlet weak var comicFrame: ComicFrame!
    @IBOutlet weak var comicStylingToolbar: ComicStylingToolbar!
    private var currentComicFrame: ComicFrame?
    
    var camera: Camera!
    var cameraLocation: PhysicalCameraLocation = .backFacing
    
    var currentFilter: (key: String, value: () -> ImageProcessingOperation)?
    var currentCameraFilter: ImageProcessingOperation?
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        comicStylingToolbar.delegate = self
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        currentFilter = supportedFilters.first

        if (isCameraAvailable()){
            initializeCamera()
        }
        
        handleComicFrameEvents()
    }
    
    private func handleComicFrameEvents(){
        comicFrame.onClickGalleryCallback = {
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        comicFrame.onClickShareCallback = {
            if self.comicFrame.framePhoto.image == nil{
                print("No photo is selected")
                return
            }
            let image = self.comicFrame.framePhoto.image
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            getTopViewController()?.present(activityViewController, animated: true, completion: nil)
        }
        
        
        func getTopViewController() -> UIViewController?{
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while (topController.presentedViewController != nil)
                {
                    topController = topController.presentedViewController!
                }
                return topController
            }
            return nil
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
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
    }
    
    func deinitializeCamera(){
        if let cam = camera {
            cam.stopCapture()
            cam.removeAllTargets()
            if let filter = currentCameraFilter {
                filter.removeAllTargets()
            }
            comicFrame.renderView.removeSourceAtIndex(0)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
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
            if let filter = currentFilter?.value() {
                deinitializeCamera()
                let input = PictureInput(image: pickedImage/*, smoothlyScaleOutput: true, orientation: ImageOrientation.fromOrientation(pickedImage.imageOrientation)*/)
                input.addTarget(filter)
                let renderView = comicFrame.addProcessedFramePhoto()
                renderView.orientation = ImageOrientation.fromOrientation(pickedImage.imageOrientation)
                filter.addTarget(renderView)
                input.processImage()
            }
        }
        self.dismiss(animated: true, completion: nil)
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
extension MainViewController: ComicStripToolbarDelegate {
  
    func didTapCaptureButton() {
        self.camera.stopCapture()
        self.comicStylingToolbar.mode = .editing
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
        element.effectFunc(comicFrame)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}
