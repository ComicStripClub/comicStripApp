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
}

@IBDesignable class ComicStylingToolbar: UIView {

    var delegate: ComicStripToolbarDelegate?
    @IBOutlet weak var stylingModeToolbar: UIView!
    @IBOutlet weak var cameraModeToolbar: UIView!
    @IBOutlet weak var captureIconView: UIView!
    
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
        contentView.frame = bounds
        addSubview(contentView)
        
        drawCaptureIcon()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawCaptureIcon()
    }
    
    private func drawCaptureIcon() {
        for sub in captureIconView.subviews {
            sub.removeFromSuperview()
        }
        let outerCircleSide: CGFloat = captureIconView.bounds.width - 8
        let centerPoint = convert(captureIconView.center, to: captureIconView)
        let outerCircle = UIView.createCircle(diameter: outerCircleSide, centeredAt: centerPoint)
        outerCircle.layer.borderColor = UIColor.white.cgColor
        outerCircle.layer.borderWidth = 4
        captureIconView.addSubview(outerCircle)
        let innerCircle = UIView.createCircle(diameter: outerCircleSide - 15, centeredAt: centerPoint)
        innerCircle.layer.backgroundColor = UIColor.white.cgColor
        captureIconView.addSubview(innerCircle)
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
