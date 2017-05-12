//
//  MyCreationViewController.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class MyCreationViewController: UIViewController {

    @IBOutlet weak var comicCollectionView: UICollectionView!
    var comicAlbum = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        comicCollectionView.dataSource = self
        comicCollectionView.delegate = self
        self.comicAlbum = ComicStripPhotoAlbum.sharedInstance.getAllComicsFromAlbum()
        self.comicCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCreationCell", for: indexPath) as! MyCreationCell
        collectionCell.comicThumb.image = comicAlbum[indexPath.row]
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicAlbum.count
    }
}
