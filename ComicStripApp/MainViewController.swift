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

    @IBOutlet weak var comicStripPanel: RenderView!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession: AVCaptureSession!
    // If we find a device we'll store it here for later use
    var captureDevices : [AVCaptureDevice]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCamera()
    }

    private func initializeCamera(){
        do {
            let camera = try Camera(sessionPreset:AVCaptureSessionPreset640x480)
            let filter = SmoothToonFilter()
            camera --> filter --> comicStripPanel
            camera.startCapture()
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
    }

    var currentOrientation: UIDeviceOrientation = .unknown
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let newOrientation = UIDevice.current.orientation
        if (newOrientation != currentOrientation){
            currentOrientation = newOrientation
            comicStripPanel.fillMode = .preserveAspectRatioAndFill
            comicStripPanel.orientation = getImageOrientation(UIDevice.current.orientation)
        }
    }
    
    private func getImageOrientation(_ orientation: UIDeviceOrientation) -> ImageOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .portrait:
            fallthrough
        default:
            return .portrait
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
