//
//  SlideDownAnimator.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 06/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class SlideDownAnimator: NSObject {
	
	let duration = 0.5
	var isPresenting = false
}

extension SlideDownAnimator: UIViewControllerTransitioningDelegate {
	
	// present non-interactive viewController transitioning
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	// dismiss non-interactive viewController transitioning
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
	
}

extension SlideDownAnimator: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Get reference to our fromView, toView and the container view
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let containerView = transitionContext.containerView
		
		// Set up the transform we'll use in the animation
		let offScreenUp = CGAffineTransform(translationX: 0, y: -containerView.frame.height)
		let offScreenDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
		
		// Make the toView off screen
		if isPresenting {
			toView.transform = offScreenUp
		}
		
		// Add both views to the container view
		containerView.addSubview(fromView)
		containerView.addSubview(toView)
		
		// Perform the animation
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
			
			// forward animation
			if self.isPresenting {
				fromView.transform = offScreenDown
				fromView.alpha = 0.5
				toView.transform = CGAffineTransform.identity
			// reverse animation
			} else {
				fromView.transform = offScreenUp
				fromView.alpha = 1.0
				toView.transform = CGAffineTransform.identity
				toView.alpha = 1.0
			}
		}) { (finished) in transitionContext.completeTransition(finished) }
	}
}
