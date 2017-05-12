//
//  ComicFrameElementCell.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/29/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicFrameElementCell: UICollectionViewCell {

    var comicFrameElement: ComicFrameElement? {
        didSet {
            image?.image = comicFrameElement?.icon
            if let name = comicFrameElement?.name {
                nameLabel.text = name
                nameLabel.isHidden = false
            } else {
                nameLabel.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        comicFrameElement = nil
    }
}
