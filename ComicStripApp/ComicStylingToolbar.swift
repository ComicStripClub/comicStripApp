//
//  ComicStylingToolbar.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/26/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import AudioToolbox
import Foundation
import UIKit


protocol ComicStripToolbarDelegate {
    func didTapSpeechBubbleButton()
    func didTapSoundEffectsButton()
    func didTapStyleButton()
    func didTapCaptureButton()
    func didTapSwitchCameraButton()
    func didTapGoToCaptureMode()
}

@IBDesignable class ComicStylingToolbar: UIView {

    @IBOutlet weak var speechBubbleButton: UIButton!
    @IBOutlet weak var soundEffectsButton: UIButton!
    @IBOutlet weak var filtersButton: UIButton!
    
    enum ComicStylingToolbarMode {
        case noActiveFrame
        case capture
        case editing
    }
    
    var delegate: ComicStripToolbarDelegate?
    @IBOutlet weak var cameraModeToolbar: UIView!
    @IBOutlet weak var editingModeToolbar: UIView!
    
    var mode: ComicStylingToolbarMode = .noActiveFrame {
        didSet {
            cameraModeToolbar.isHidden = (mode != .capture)
            editingModeToolbar.isHidden = (mode != .editing)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubViews()
    }
    
    private func initializeSubViews(){
        let nib = UINib(nibName: String(describing: ComicStylingToolbar.self), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    @IBAction func didTapCaptureButton(_ sender: Any) {
        if #available(iOS 9.0, *) {
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1108), nil)
        } else {
            AudioServicesPlaySystemSound(1108)
        }
        delegate?.didTapCaptureButton()
    }
    
    @IBAction func didTapSwitchCameraButton(_ sender: Any) {
        delegate?.didTapSwitchCameraButton()
    }

    @IBAction func didTapGoToCaptureMode(_ sender: Any) {
        delegate?.didTapGoToCaptureMode()
    }
    
    @IBAction func didTapSpeechBubbleButton(_ sender: Any) {
        delegate?.didTapSpeechBubbleButton()
        selectButton(button: sender as? UIButton)
    }
    
    @IBAction func didTapSoundEffectsButton(_ sender: Any) {
        delegate?.didTapSoundEffectsButton()
        selectButton(button: sender as? UIButton)
    }
    
    @IBAction func didTapFilterButtonInCapture(_ sender: Any) {
        delegate?.didTapStyleButton()
    }
    
    @IBAction func didTapStyleButton(_ sender: Any) {
        delegate?.didTapStyleButton()
        selectButton(button: sender as? UIButton)
    }
    
    func selectButton(button: UIButton?){
        for btn in [speechBubbleButton, soundEffectsButton, filtersButton]{
            btn?.isSelected = false
        }
        if let btn = button {
            btn.isSelected = true
        }
    }
}
