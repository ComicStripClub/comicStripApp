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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsegue"{
            let cell = sender as! MyCreationCell
            let comicDetailController = segue.destination as! ComicDetailViewController
            comicDetailController.comicImage = cell.comicThumb.image!
        }
    }

}

extension MyCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCreationCell", for: indexPath) as! MyCreationCell
        collectionCell.comicThumb.image = comicAlbum[indexPath.row]
        
        collectionCell.layer.shadowColor = UIColor.black.cgColor
        collectionCell.layer.shadowOpacity = 0.4
        collectionCell.layer.shadowOffset = CGSize.zero
        collectionCell.layer.shadowRadius = 5
        //collectionCell.comicThumb.layer.cornerRadius = 5.0
        //collectionCell.comicThumb.layer.borderWidth = 0.5
        //collectionCell.comicThumb.clipsToBounds = true
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicAlbum.count
    }

}

extension MyCreationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 30
        let comic = comicAlbum[indexPath.row]
        let comicAspectRatio = comic.size.width / comic.size.height
        return CGSize(width: width, height: width / comicAspectRatio)
    }
}
