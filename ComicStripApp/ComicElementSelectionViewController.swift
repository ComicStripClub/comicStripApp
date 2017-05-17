//
//  ComicElementSelectionViewController.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 4/29/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit
import GPUImage

enum ComicElementType: Int {
    case dialogBubble
    case soundEffect
    case style
}

protocol ComicElementSelectionDelegate {
    func didChooseComicElement(_ element: ComicFrameElement)
    func didCancel()
}

class ComicElementSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var delegate: ComicElementSelectionDelegate?
    
    var comicFrameElements: [ComicFrameElement]? {
        didSet {
            if (isViewLoaded) {
                collectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        delegate?.didCancel()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicFrameElements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicFrameElementCell", for: indexPath) as! ComicFrameElementCell
        cell.comicFrameElement = comicFrameElements![indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didChooseComicElement(comicFrameElements![indexPath.row])
    }

}

extension ComicElementSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let element = comicFrameElements![indexPath.row]
        let width = collectionView.bounds.width / 2 - 10
        //let itemAspectRatio = element.icon.size.width / element.icon.size.height
        return CGSize(width: width, height: width)
    }
}
