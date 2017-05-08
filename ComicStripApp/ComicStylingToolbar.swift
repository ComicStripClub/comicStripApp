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
}

@IBDesignable class ComicStylingToolbar: UIView {

    enum ComicStylingToolbarMode {
        case capture
        case editing
    }
    
    var delegate: ComicStripToolbarDelegate?
    @IBOutlet weak var cameraModeToolbar: UIView!
    @IBOutlet weak var editingModeToolbar: UIView!
    
    var mode: ComicStylingToolbarMode = .capture {
        didSet {
            cameraModeToolbar.isHidden = (mode == .editing)
            editingModeToolbar.isHidden = (mode == .capture)
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
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @IBAction func didTapCaptureButton(_ sender: Any) {
        delegate?.didTapCaptureButton()
    }
    
    @IBAction func didTapSwitchCameraButton(_ sender: Any) {
        delegate?.didTapSwitchCameraButton()
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
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
