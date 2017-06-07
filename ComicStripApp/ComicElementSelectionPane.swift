//
//  ComicElementSelectionPane.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/31/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import Foundation
import UIKit

class ComicElementSelectionPane: UIView
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ComicElementSelectionDelegate?
    
    var comicFrameElements: [ComicFrameElement]? {
        didSet {
            updateCollectionViewScrollDirection()
            collectionView.reloadData()
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
        let nib = UINib(nibName: String(describing: ComicElementSelectionPane.self), bundle: nil)
        let contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.register(ComicFrameElementCell.self, forCellWithReuseIdentifier: "ComicFrameElementCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewScrollDirection()
    }
    
    private func updateCollectionViewScrollDirection(){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let w = collectionView.bounds.width
            let h = collectionView.bounds.height
            if (collectionView.bounds.width > collectionView.bounds.height) {
                layout.scrollDirection = .horizontal
            } else {
                layout.scrollDirection = .vertical
            }
        }
    }
}

extension ComicElementSelectionPane: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicFrameElements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.isSelected = false
        delegate?.didChooseComicElement(comicFrameElements![indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicFrameElementCell", for: indexPath) as! ComicFrameElementCell
        cell.comicFrameElement = comicFrameElements![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isHorizontalScroll = (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .horizontal
        let element = comicFrameElements![indexPath.row]
        let aspectRatio = element.icon.size.width / element.icon.size.height;
        var cellSize = isHorizontalScroll
            ? CGSize(width: (bounds.height - 20) * aspectRatio, height: bounds.height - 20)
            : CGSize(width: bounds.width / 2 - 10, height: bounds.width / 2 - 10)
        return cellSize
    }
}
