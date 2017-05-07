//
//  ComicElementToolbar.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/7/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicElementToolbar: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "ComicElementToolbar", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let s = toolbar.sizeThatFits(CGSize(width: 100000, height: 35))
        return s
    }
}
