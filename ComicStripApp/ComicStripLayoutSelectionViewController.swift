//
//  ComicStripLayoutSelectionViewController.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicStripLayoutSelectionViewController: UIViewController {

    let comicStrips : [(image: UIImage, factory: () -> ComicStrip)] = [
        (
            image: ComicStrip_1Big.icon,
            factory: { return ComicStrip_1Big()!}
        ),
        (
            image: ComicStrip_2Big.icon,
            factory: { return ComicStrip_2Big()!}
        ),
        (
            image: ComicStrip_2Small1Big.icon,
            factory: { return ComicStrip_2Small1Big()!}
        ),
        (
            image: ComicStrip_1x3.icon,
            factory: { return ComicStrip_1x3()!}
        ),
        (
            image: ComicStrip_2x2.icon,
            factory: { return ComicStrip_2x2()!}
        ),
        (
            image: ComicStrip_1Big1Small.icon,
            factory: { return ComicStrip_1Big1Small()!}
        )]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Start over", style: .plain, target: nil, action: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainView = segue.destination as! MainViewController
        let comicStripCell = sender as! ComicStripCell
        let comicStrip = comicStripCell.comicStrip
        mainView.comicStripFactory = comicStrip!.factory
    }
}

extension ComicStripLayoutSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicStrips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicStripCell", for: indexPath) as! ComicStripCell
        cell.comicStrip = comicStrips[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.midX - 40;
        return CGSize(width: side, height: side * 1.6)
    }
}
