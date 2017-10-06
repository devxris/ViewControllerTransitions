//
//  PopAnimator.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 06/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class PopAnimator: NSObject {
	
	let duration = 0.5
	var isPresenting = false
}

extension PopAnimator: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension PopAnimator: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Get reference to our fromView, toView and the containerView
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let containerView = transitionContext.containerView
		
		// Set up the transform will be used in the animation
		let minimize = CGAffineTransform(scaleX: 0, y: 0)
		let offScreenDown = CGAffineTransform(translationX: 0, y: containerView.frame.height)
		let shiftDown = CGAffineTransform(translationX: 0, y: 15)
		let scaleDown = shiftDown.scaledBy(x: 0.95, y: 0.95)
		
		// Make the toView scale to 0
		toView.transform = minimize
		
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
				fromView.transform = scaleDown
				fromView.alpha = 0.5
				toView.transform = CGAffineTransform.identity
			} else {
				fromView.transform = offScreenDown
				toView.alpha = 1.0
				toView.transform = CGAffineTransform.identity
			}
		}) { (finished) in transitionContext.completeTransition(finished) }
		
		// Complete transition
	}
}
