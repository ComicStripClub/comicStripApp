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

class MainViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let supportedFilters: [String: () -> ImageProcessingOperation] = [
        "Cartoon" : {
            return SmoothToonFilter()
        },
        "Sketch" : {
            let sketchFilter = SketchFilter()
            sketchFilter.edgeStrength = 5.0
            return sketchFilter
        },
        "Pixelate" : { return Pixellate() },
        "Pop art" : { return PolkaDot() },
        "Cross hatch" : { return Crosshatch()},
        "Halftone" : { return Halftone() }
    ]
    
    override var shouldAutorotate: Bool {
        get { return false }
    }
    var currentFrameCount = -1;
    @IBOutlet weak var comicElementSelectionPane: ComicElementSelectionPane!
    @IBOutlet weak var comicElementSelectionPaneTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var comicStripContainer: ComicStripContainer!
    @IBOutlet weak var comicStylingToolbar: ComicStylingToolbar!
    
    @IBOutlet weak var comicElementSelectionPaneContainer: UIView!
    
    var currentComicFrame: ComicFrame? { get { return comicStripContainer.selectedFrame } }
    var imagePickerTargetFrame: ComicFrame?
    var comicStrip: ComicStrip!
    var comicStripFactory: (() -> ComicStrip)!
    var savedComicImage: UIImage?
    var camera: Camera!
    var cameraLocation: PhysicalCameraLocation = .backFacing
    var nextPicture: PictureOutput!
    let customPresentAnimationController = ViewControllerAnimator()
    
    var currentFilter: (key: String, value: () -> ImageProcessingOperation)? {
        didSet {
            comicStripContainer.currentFilter = currentFilter
        }
    }
    
    var currentCameraFilter: ImageProcessingOperation?
    
    let imagePicker = UIImagePickerController()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicStripContainer.delegate = self
        comicStylingToolbar.delegate = self
        comicElementSelectionPane.delegate = self
        imagePicker.delegate = self

        handleNavigationBarItem()
        comicStrip = comicStripFactory()
        comicStripContainer.comicStrip = comicStrip
        for comicFrame in comicStrip.comicFrames {
            comicFrame.delegate = self
        }

        comicStylingToolbar.transform = CGAffineTransform(translationX: 0, y: comicStylingToolbar.bounds.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        //currentFilter = (key: "Cartoon", value: supportedFilters["Cartoon"]!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "savesegue"){
            let detailViewNavController = segue.destination as! UINavigationController
            let detailViewController = detailViewNavController.topViewController as! SavedComicViewController
            segue.destination.transitioningDelegate = self
            detailViewController.savedComicImage = self.savedComicImage
        }
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customPresentAnimationController
    }
    
    
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @objc private func didTapView(_ tapGestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
        comicStripContainer.selectComicFrame(nil)
        hideComicElementSelectionPane()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!touches.contains(where: { (touch) -> Bool in
            return touch.view?.isDescendant(of: self.comicElementSelectionPane) ?? false
        })){
            hideComicElementSelectionPane()
        }
    }
    
    func handleNavigationBarItem (){
        // Changing the navigation controller's title colour
        self.navigationItem.title = ""
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Start over", style: .plain, target: self, action: nil)

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
                if let filter = currentFilter?.value() {
                    currentCameraFilter = filter
                    camera.addTarget(filter)
                    filter.addTarget(comicFrame.renderView)
                } else {
                    camera.addTarget(comicFrame.renderView)
                }
                if (cameraLocation == .backFacing) {
                    comicFrame.renderView.orientation = .portrait
                    comicFrame.renderView.transform = CGAffineTransform.identity
                } else {
                    comicFrame.renderView.orientation = .portrait
                    comicFrame.renderView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
                }
                camera.startCapture()
                comicFrame.isCapturing = true
                updateToolbar()
            } catch {
                fatalError("Could not initialize rendering pipeline: \(error)")
            }
        }
    }
    
    // Only show the save button if all the frames in the comic
    // strip have background photos.  I.e. no empty frames allowed
    // in final output
    func updateSaveButton(){
        var allFramesFull = true
        for comicFrame in comicStrip.comicFrames {
            if (!comicFrame.hasPhoto){
                allFramesFull = false
                break
            }
        }
        
        if (allFramesFull) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSaveButton))
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
        var mode = ComicStylingToolbar.ComicStylingToolbarMode.noActiveFrame
        if let comicFrame = currentComicFrame {
            if (comicFrame.isCapturing) {
                mode = .capture
            } else if (comicFrame.hasPhoto) {
                mode = .editing
            }
        }

        if (mode == comicStylingToolbar.mode){
            return
        }
        
        if (comicStylingToolbar.mode == .noActiveFrame){
            // animate in
            UIView.animate(withDuration: 0.333, delay: 0, options: .curveEaseOut, animations: {
                self.comicStylingToolbar.transform = CGAffineTransform.identity
                self.comicStripContainer.needsUpdateConstraints()
            }, completion: nil)
        } else if (mode == .noActiveFrame){
            UIView.animate(withDuration: 0.333, delay: 0, options: .curveEaseOut, animations: {
                self.comicStylingToolbar.transform = CGAffineTransform(translationX: 0, y: self.comicStylingToolbar.bounds.height)
                self.comicStripContainer.needsUpdateConstraints()
            }, completion: nil)
        }
        comicStylingToolbar.mode = mode
    }
    
    public func showComicElementSelectionPane(withElements comicFrameElements: [ComicFrameElement], collectionName: String){
        self.comicElementSelectionPane.setComicFrameElements(collectionName: collectionName, elementCollection: comicFrameElements)
        UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: .curveEaseOut, animations: {
            self.comicElementSelectionPaneContainer.transform = CGAffineTransform(translationX: 0, y: -(self.comicElementSelectionPane.bounds.height + self.comicStylingToolbar.bounds.height))
        }, completion: nil)
    }
    
    public func hideComicElementSelectionPane(){
        self.comicStylingToolbar.selectButton(button: nil)
        UIView.animate(withDuration: 0.300, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.comicElementSelectionPaneContainer.transform = CGAffineTransform.identity
        }, completion: nil)

    }
}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.comicElementSelectionPane) ?? false){
            return false
        }
        return true
    }
}

extension MainViewController: ComicFrameDelegate {

    func didTapAddPhotoToFrame(_ sender: ComicFrame) {
        if (comicStripContainer.selectedFrame != nil && sender != comicStripContainer.selectedFrame){
            comicStripContainer.selectComicFrame(sender)
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Use camera", style: .default) { (action) in
            self.didTapCameraButton(sender)
        }
        let galleryAction = UIAlertAction(title: "Use existing photo", style: .default) { (action) in
            self.didTapGalleryButton(sender)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func didTapCameraButton(_ sender: ComicFrame) {
        comicStripContainer.selectComicFrame(sender)
        initializeCamera()
        updateToolbar()
    }
    
    func didTapGalleryButton(_ sender: ComicFrame) {
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        imagePickerTargetFrame = sender
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func didChangeCurrentFilter(_ sender: ComicFrame) {
        if (sender.isCapturing){
            currentFilter = sender.currentFilter
            deinitializeCamera()
            initializeCamera()
        }
    }
    
    func frameStateChanged(_ sender: ComicFrame) {
        if (sender == currentComicFrame){
            updateToolbar()
        }
    }
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
            self.updateToolbar()
            self.updateSaveButton()
            self.imagePickerTargetFrame = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerTargetFrame = nil
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
        updateToolbar()
    }
}
extension MainViewController: ComicStripToolbarDelegate {
  
    func didTapCaptureButton() {
        self.nextPicture = PictureOutput()
        nextPicture.imageAvailableCallback = { (image) in
            DispatchQueue.main.async {
                var newImage = image //.fixedOrientation()
                if (self.cameraLocation == .frontFacing) {
                    newImage = image.fixedOrientation()
                }
                self.currentComicFrame!.selectedPhoto = newImage
                self.updateToolbar()
                self.updateSaveButton()
                self.deinitializeCamera()
                self.nextPicture = nil
            }
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
            HandDrawnBubble1Element(),
            ThoughtBubbleElement(),
            ClassicSpeechBubbleElement(),
            HandDrawnBubble2Element(),
            HandDrawnBubble3Element(),
            HandDrawnBubble5Element(),
            HandDrawnBubble4Element()]
        showComicElementSelectionPane(withElements: speechBubbles, collectionName: "Speech bubbles")
        //presentSelectionController(withElements: speechBubbles)
    }
    
    func didTapSoundEffectsButton() {
        let soundEffects: [ComicFrameElement] = [
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "wham")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "kaboom")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "bam")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "bang")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "bloodyFist")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "bomb")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "boom")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "boom2")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "booomm")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "booooom")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "crash")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "explosion")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "kabooom")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "krunch")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "no_no_no")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "questionMark")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "redExplosion")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "redSpikeyCloud")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "screeeaaawr")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "smokeExplosion")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "splash")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "whooshSmoke")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "wow")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "zaaap")),
            SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "zap")),
            ]
        showComicElementSelectionPane(withElements: soundEffects, collectionName: "Sound effects")
        //presentSelectionController(withElements: soundEffects)
    }
    
    func didTapStyleButton() {
        var filterElements: [ComicFrameElement] = []
        var i = 1
        for filter in supportedFilters {
            filterElements.append(FilterElement(filterIconName: "filter"+String(i) , filter: filter))
            i += 1
        }
        showComicElementSelectionPane(withElements: filterElements, collectionName: "Filters")
        //presentSelectionController(withElements: filterElements)
    }
    
    func didTapGoToCaptureMode() {
        currentComicFrame!.selectedPhoto = nil
        self.didTapAddPhotoToFrame(currentComicFrame!)
    }
    
    func didTapSaveButton() {
        view.endEditing(true)
        for cf in comicStrip.comicFrames {
            cf.isActive = false
        }
        // TODO: Fix bug where toolbar for active ComicFrameElement shows up in the saved output
        let image = self.comicStrip.asImage()
        ComicStripPhotoAlbum.sharedInstance.save(image: image) { (isSaved) in
            if isSaved{
                self.savedComicImage = image
                self.performSegue(withIdentifier: "savesegue", sender: self)
            }else{
                print("Error is saving comic")
            }
        }
    }
    
    func didTapShareButton() {
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

        let image = self.comicStrip.asImage()
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        getTopViewController()?.present(activityViewController, animated: true, completion: nil)

    
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
