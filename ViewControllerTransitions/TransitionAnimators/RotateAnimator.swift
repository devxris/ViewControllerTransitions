//
//  RotateAnimator.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 06/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class RotateAnimator: NSObject {
	
	let duration = 0.5
	var isPresenting = false
}

extension RotateAnimator: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension RotateAnimator: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Get reference to our fromView, toView and the containerView
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let containerView = transitionContext.containerView
		
		// Set up the transform will be used in the animation
		let rotateOut = CGAffineTransform(rotationAngle: -90 * CGFloat.pi / 180)
		// Change the anchor point and position
		toView.layer.anchorPoint = CGPoint(x: 0, y: 0)
		fromView.layer.anchorPoint = CGPoint(x: 0, y: 0)
		toView.layer.position = CGPoint(x: 0, y: 0)
		fromView.layer.position = CGPoint(x: 0, y: 0)
		
		// Make the toView off screen
		toView.transform = rotateOut
		
		// Add both fromView and toView to the containerView
		containerView.addSubview(toView)
		containerView.addSubview(fromView)
		
		// Perform the animation
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
			if self.isPresenting {
				fromView.transform = rotateOut
				fromView.alpha = 0
				toView.transform = CGAffineTransform.identity
				toView.alpha = 1.0
			} else {
				fromView.transform = rotateOut
				fromView.alpha = 0
				toView.transform = CGAffineTransform.identity
				toView.alpha = 1.0
			}
		}) { (finished) in transitionContext.completeTransition(finished) }
	}
}
