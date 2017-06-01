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
            self.image?.image = comicFrameElement?.icon

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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubViews()
    }
    
    private func initializeSubViews(){
        let nib = UINib(nibName: String(describing: ComicFrameElementCell.self), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    override func prepareForReuse() {
        comicFrameElement = nil
    }
}
