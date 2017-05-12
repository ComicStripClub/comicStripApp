//
//  ComicStylingToolbar.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/26/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

protocol ComicStripToolbarDelegate {
    func didTapSpeechBubbleButton()
    func didTapSoundEffectsButton()
    func didTapStyleButton()
    func didTapCaptureButton()
    func didTapSwitchCameraButton()
    func didTapGoToCaptureMode()
    func didTapShareButton()
    func didTapSaveButton()
}

@IBDesignable class ComicStylingToolbar: UIView {

    enum ComicStylingToolbarMode {
        case noActiveFrame
        case capture
        case editing
    }
    
    var delegate: ComicStripToolbarDelegate?
    @IBOutlet weak var cameraModeToolbar: UIView!
    @IBOutlet weak var editingModeToolbar: UIView!
    
    @IBOutlet weak var noFramesActiveModeToolbar: UIView!
    
    var mode: ComicStylingToolbarMode = .noActiveFrame {
        didSet {
            cameraModeToolbar.isHidden = (mode != .capture)
            editingModeToolbar.isHidden = (mode != .editing)
            noFramesActiveModeToolbar.isHidden = (mode != .noActiveFrame)
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
        
        let buttons = [shareButton, saveButton]
        for button in buttons {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
            button!.addGestureRecognizer(tapRecognizer)
        }
    }
    @objc private func didTapButton(_ sender: UITapGestureRecognizer){
        if (sender.view!.isEqual(shareButton)){
            delegate?.didTapShareButton()
        } else if (sender.view!.isEqual(saveButton)){
            delegate?.didTapSaveButton()
        }
    }
    
    @IBAction func didTapCaptureButton(_ sender: Any) {
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
    }
    
    @IBAction func didTapSoundEffectsButton(_ sender: Any) {
        delegate?.didTapSoundEffectsButton()
    }
    
    @IBAction func didTapStyleButton(_ sender: Any) {
        delegate?.didTapStyleButton()
    }
    
    @IBOutlet weak var shareButton: ComicToolbarButton!
    @IBOutlet weak var saveButton: ComicToolbarButton!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
