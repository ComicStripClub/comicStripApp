//
//  ViewControllerAnimator.swift
//  ComicStripApp
//
//  Created by Sethi, Pinkesh on 5/14/17.
//  Copyright © 2017 comicStripClub. All rights reserved.
//

import UIKit

class ViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: -bounds.size.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveLinear, animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
            fromViewController.view.alpha = 1.0
        })
    }
}
