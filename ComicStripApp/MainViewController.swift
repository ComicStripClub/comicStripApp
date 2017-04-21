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

    @IBOutlet weak var comicStripPanel: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession: AVCaptureSession!
    // If we find a device we'll store it here for later use
    var captureDevices : [AVCaptureDevice]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCamera()
    }

    private func initializeCamera(){
        captureSession = AVCaptureSession()
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let deviceDiscovery = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        
        // Loop through all the capture devices on this phone
        captureDevices = deviceDiscovery?.devices ?? []
        if (captureDevices.count > 0){
            let captureDevice = captureDevices[0]
            do {
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
            } catch {
                print("Failed to initialize camera")
            }            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.frame = comicStripPanel.bounds
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            comicStripPanel.layer.addSublayer(previewLayer!)
            
            captureSession.startRunning()
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        if let videoPreviewLayer = previewLayer {
            let bounds = comicStripPanel.layer.bounds;
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            videoPreviewLayer.bounds = bounds;
            videoPreviewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY);
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let connection =  self.previewLayer?.connection  {
            let currentDevice: UIDevice = UIDevice.current
            let orientation: UIDeviceOrientation = currentDevice.orientation
            let previewLayerConnection : AVCaptureConnection = connection
            if previewLayerConnection.isVideoOrientationSupported {
                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
                    break
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
                    break
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
                    break
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
                    break
                }
            }
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
