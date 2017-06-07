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
    @IBOutlet weak var imgParentView: UIView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imgParentView.startRotate()
        showRotateAnimationWithZoomInOut()
        getStartedButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTitleLable()
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
    
    func showRotateAnimationWithZoomInOut(){
        self.imgParentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.5, delay: 0.15, usingSpringWithDamping: 0.3, initialSpringVelocity: 4.0, options: [], animations: {
            self.imgParentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
        handleButtonVisisblity()
    }
    
    func handleButtonVisisblity(){
        getStartedButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 1.5,
                       delay: 0.3,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 4.0,
                       options: .allowUserInteraction,
                       animations: {
                        self.getStartedButton.transform = .identity
            }, completion: nil)
    }
    
    func animateTitleLable(){
        titleLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 4.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.titleLabel.transform = .identity
            },
                       completion: nil)
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
