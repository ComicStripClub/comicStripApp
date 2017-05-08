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
    override var shouldAutorotate: Bool {
        get { return false }
    }
    var currentFrameCount = -1;
    @IBOutlet weak var comicFrame: ComicFrame!
    @IBOutlet weak var comicStylingToolbar: ComicStylingToolbar!
    private var currentComicFrame: ComicFrame?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicStylingToolbar.delegate = self
        imagePicker.delegate = self
        
        if (isCameraAvailable()){
            initializeCamera()
        }
        handleComicFrameEvents()
    }
    
    private func handleComicFrameEvents(){
        comicFrame.frameCountLabel.text = "Frame count \(currentFrameCount)"
        
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
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
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
    
    private func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    private func initializeCamera(){
        do {
            let camera = try Camera(sessionPreset:AVCaptureSessionPreset640x480)
            let filter = SmoothToonFilter()
            camera --> filter --> comicFrame.renderView
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            comicFrame.framePhoto.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            comicFrame.framePhoto.image = image
        } else{
            print("Could not load image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MainViewController: ComicStripToolbarDelegate {
    
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
