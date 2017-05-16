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
        
        collectionCell.comicThumb.layer.shadowColor = UIColor.black.cgColor
        collectionCell.comicThumb.layer.shadowOpacity = 0.5
        collectionCell.comicThumb.layer.shadowOffset = CGSize.zero
        collectionCell.comicThumb.layer.shadowRadius = 7
        collectionCell.comicThumb.layer.cornerRadius = 5.0
        collectionCell.comicThumb.layer.borderWidth = 0.5
        collectionCell.comicThumb.layer.cornerRadius = 5.0
        collectionCell.comicThumb.clipsToBounds = true
        
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicAlbum.count
    }

}
