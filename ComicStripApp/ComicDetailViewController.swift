//
//  ComicDetailViewController.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/13/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit
import Social

class ComicDetailViewController: UIViewController {

    var comicImage: UIImage?
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var thumbContainerView: UIView!
    @IBOutlet weak var comicImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbContainerView.layer.shadowColor = UIColor.black.cgColor
        thumbContainerView.layer.shadowOpacity = 0.5
        thumbContainerView.layer.shadowOffset = CGSize.zero
        thumbContainerView.layer.shadowRadius = 7
        thumbContainerView.layer.cornerRadius = 5.0
        thumbContainerView.layer.borderWidth = 0.5
        comicImageView.layer.cornerRadius = 5.0
        comicImageView.clipsToBounds = true
        comicImageView.image = comicImage
        animationButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareToFacebook(_ sender: Any) {
        let facebookPostViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookPostViewController?.add(comicImage)
        self.present(facebookPostViewController!, animated: true, completion: nil)
    }

    @IBAction func shareToTwitter(_ sender: Any) {
        let twitterPostViewController = SLComposeViewController(forServiceType:
            SLServiceTypeTwitter)
        twitterPostViewController?.add(comicImage)
        self.present(twitterPostViewController!, animated:true, completion: nil)
    }
    
    @IBAction func shareToOtherApp(_ sender: Any) {
        func getTopViewController() -> UIViewController?{
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while (topController.presentedViewController != nil)
                {
                    topController = topController.presentedViewController!
                }
                return topController
            }
            return nil
        }
        
        let imageToShare = [ comicImage ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        getTopViewController()?.present(activityViewController, animated: true, completion: nil)
    }
    
    func animationButton(){
        facebookButton.center.y += view.bounds.height
        UIView.animate(withDuration: 1.0) { 
            self.facebookButton.center.y -= (self.view.bounds.width)
        }
        twitterButton.center.y += view.bounds.height
        UIView.animate(withDuration: 1.0) {
            self.twitterButton.center.y -= (self.view.bounds.width)
        }
        shareButton.center.y += view.bounds.height
        UIView.animate(withDuration: 1.0) {
            self.shareButton.center.y -= (self.view.bounds.width)
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
