//
//  ComicToolbarButton.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicToolbarButton: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var commandNameLabel: UILabel!
    
    @IBInspectable var commandName: String? {
        didSet {
            commandNameLabel.text = commandName
        }
    }

    @IBInspectable var commandIcon: UIImage?
    {
        didSet {
            iconImageView.image = commandIcon
        }
    }
    
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
        let nib = UINib(nibName: "ComicToolbarButton", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundColor = UIColor.clear
    }

}
