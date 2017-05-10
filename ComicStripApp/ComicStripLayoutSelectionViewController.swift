//
//  ComicStripLayoutSelectionViewController.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/10/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicStripLayoutSelectionViewController: UIViewController {

    let comicStrips : [(image: UIImage, factory: (_ aCoder: NSCoder) -> ComicStrip)] = [
        (
            image: ComicStrip_2Small1Big.frameLayoutBorders.image,
            factory: {(aCoder) in return ComicStrip_2Small1Big(coder: aCoder)!}
        ),
        (
            image: ComicStrip_1x3.frameLayoutBorders.image,
            factory: {(aCoder) in return ComicStrip_1x3(coder: aCoder)!}
        )]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ComicStripLayoutSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicStrips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
