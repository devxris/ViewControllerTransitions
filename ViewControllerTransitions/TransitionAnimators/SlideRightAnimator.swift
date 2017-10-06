//
//  SlideRightAnimator.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 06/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class SlideRightAnimator: NSObject {
	
	let duration = 0.5
	var isPresenting = false
}

extension SlideRightAnimator: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension SlideRightAnimator: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Get reference to our fromView, toView and the container view
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let containerView = transitionContext.containerView
		
		// Set up the transform will be used in the animation
		let offScreenLeft = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
		
		// Make the toView off screen
		if isPresenting {
			toView.transform = offScreenLeft
		}
		
		// Add both fromView and toView to the containerView
		if isPresenting {
			containerView.addSubview(fromView)
			containerView.addSubview(toView)
		} else {
			containerView.addSubview(toView)
			containerView.addSubview(fromView)
		}
		
		// Perform the animation
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
			if self.isPresenting {
				toView.transform = CGAffineTransform.identity
			} else {
				fromView.transform = offScreenLeft
			}
		}) { (finished) in transitionContext.completeTransition(finished) } }
}
