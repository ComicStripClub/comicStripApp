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
    override var shouldAutorotate: Bool {
        get { return false }
    }

    @IBOutlet weak var comicFrame: ComicFrame!
    @IBOutlet weak var comicStylingToolbar: ComicStylingToolbar!
    private var currentComicFrame: ComicFrame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comicStylingToolbar.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
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
