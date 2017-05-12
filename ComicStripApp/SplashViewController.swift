//
//  SplashViewController.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

        @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var parentUIView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGetStartedClick(_ sender: UIButton) {
        let imgArray = ComicStripPhotoAlbum.sharedInstance.getAllComicsFromAlbum ()
        decideAndLaunchNextFlow(isComicCreated: imgArray.count != 0)
    }

    func decideAndLaunchNextFlow(isComicCreated: Bool){
        if isComicCreated{
            performSegue(withIdentifier: "mycreationsegue", sender: nil)
        }else{
            performSegue(withIdentifier: "firsttimesegue", sender: nil)
        }
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
