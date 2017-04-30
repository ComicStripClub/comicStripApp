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
        // initializeCamera()
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
        let speechBubbles: [ComicFrameElement] =
            [ThoughtBubbleElement()]
        presentSelectionController(withElements: speechBubbles)
    }
    
    func didTapSoundEffectsButton() {
        let soundEffects: [ComicFrameElement] =
            [SoundEffectElement(soundEffectImg: #imageLiteral(resourceName: "wham"))]
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
