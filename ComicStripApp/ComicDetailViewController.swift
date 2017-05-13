//
//  ComicDetailViewController.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/13/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {

    @IBOutlet weak var comicImage: UIImageView!
    @IBOutlet weak var thumbContainerView: UIView!
    var savedComicImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbContainerView.layer.shadowColor = UIColor.black.cgColor
        thumbContainerView.layer.shadowOpacity = 0.5
        thumbContainerView.layer.shadowOffset = CGSize.zero
        thumbContainerView.layer.shadowRadius = 7
        thumbContainerView.layer.cornerRadius = 5.0
        thumbContainerView.layer.borderWidth = 0.5
        comicImage.layer.cornerRadius = 5.0
        comicImage.clipsToBounds = true
        comicImage.image = savedComicImage
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
