//
//  ComicFrame.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/29/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class ComicFrame: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var renderView: RenderView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    private func initSubviews() {
        let nib = UINib(nibName: "ComicFrame", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
    }
    
    func addElement(_ element: ComicFrameElement, size: CGSize) {
        let elementView = element.view
        let topOffset = (bounds.height - size.height) / 2
        let leftOffset = (bounds.width - size.width) / 2
        elementView.frame = CGRect(origin: CGPoint(x: leftOffset, y: topOffset), size: size)
        addSubview(elementView)
    }
}
