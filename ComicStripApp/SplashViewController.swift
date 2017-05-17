//
//  SplashViewController.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/12/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit
import Onboard

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var imgParentView: UIView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imgParentView.startRotate()
        showRotateAnimationWithZoomInOut()
        getStartedButton.isHidden = true
        getStartedButton.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let isFirstTime = defaults.bool(forKey: "firstTime")
        if(isFirstTime){
            self.performSegue(withIdentifier: "firsttimesegue", sender: nil)
            self.dismiss(animated: true, completion: nil)
        }else{
            animateTitleLable()
        }
    }
    @IBAction func onGetStartedClick(_ sender: UIButton) {
        let imgArray = ComicStripPhotoAlbum.sharedInstance.getAllComicsFromAlbum ()
        decideAndLaunchNextFlow(isComicCreated: imgArray.count != 0)
    }

    func decideAndLaunchNextFlow(isComicCreated: Bool){
        if isComicCreated{
            performSegue(withIdentifier: "mycreationsegue", sender: nil)
        }else{
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "firstTime")

            let firstPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "facebook"), buttonText: "looks cool page 1") { () -> Void in
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            }
            
            firstPage.titleLabel.textColor = UIColor.blue
            
            let secondPage = OnboardingContentViewController(title: "Page Title 2", body: "Page body goes here.", image: UIImage(named: "twitter"), buttonText: "looks cool page 2") { () -> Void in
                self.performSequeFirstTime()
            }
            
            // Image
            let onboardingVC = OnboardingViewController(backgroundImage: UIImage(named: "background_onboarding"), contents: [firstPage, secondPage])
            
            // Setting the rootViewController to your onboardingVC
            self.present(onboardingVC!, animated: true, completion: nil)
        }
    }
    
    func performSequeFirstTime(){
        self.dismiss(animated: true, completion: nil)
    }

    
    func showRotateAnimationWithZoomInOut(){
        self.imgParentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5, animations: {
            self.imgParentView.transform = CGAffineTransform(scaleX: 2, y: 2)
        }) { (isZoomOutDone) in
            if isZoomOutDone{
                UIView.animate(withDuration: 0.5, animations: {
                    self.imgParentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { (isComplete) in
                    if isComplete{
//                        self.imgParentView.stopRotate()
                        self.handleButtonVisisblity()
                        
                    }
                })
            }
        }
    }
    
    func handleButtonVisisblity(){
        getStartedButton.isHidden = false
        getStartedButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.getStartedButton.transform = .identity
            },
                       completion: nil)
    }
    
    func animateTitleLable(){
        titleLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
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
