//
//  ComicStylingToolbar.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/26/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

@IBDesignable class ComicStylingToolbar: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubViews()
    }
    
    private func initializeSubViews(){
        let nib = UINib(nibName: String(describing: ComicStylingToolbar.self), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    @IBAction func didTapSpeechBubbleButton(_ sender: Any) {
    }
    
    @IBAction func didTapSoundEffectsButton(_ sender: Any) {
    }
    
    @IBAction func didTapStyleButton(_ sender: Any) {
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
