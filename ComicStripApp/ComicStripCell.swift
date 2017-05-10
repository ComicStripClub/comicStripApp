//
//  ComicStripCell.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicStripCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var comicStrip: (image: UIImage, factory: () -> ComicStrip)! {
        didSet {
            imageView.image = comicStrip.image
        }
    }
    
}
