//
//  ComicNavigationController.swift
//  ComicStripApp
//
//  Created by Sean McRoskey on 5/15/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ComicNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "BackIssuesBB", size: 19.0)!,
            NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "BackIssuesBB", size: 13.0)!,
            NSForegroundColorAttributeName: UIColor.white], for: .normal)
    }

}
