//
//  PartialSlideDownAnimator.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 09/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

@objc protocol PartialSlideDownAnimatorDelegate { func dismiss() }

class PartialSlideDownAnimator: NSObject {
	
	let duration = 0.5
	var isPresenting = false
	var snapshot: UIView? {
		didSet {
			// add tap to dismiss to snapshot by protocol
			guard let delegate = delegate else { return }
			let tap = UITapGestureRecognizer(target: delegate, action: #selector(delegate.dismiss))
			snapshot?.addGestureRecognizer(tap)
		}
	}
	var delegate: PartialSlideDownAnimatorDelegate?
}

extension PartialSlideDownAnimator: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = true
		return self
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		isPresenting = false
		return self
	}
}

extension PartialSlideDownAnimator: UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Get reference to our fromView, toView and the containerView
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		let containerView = transitionContext.containerView
		
		// Set up the transform will be used in the animation
		let moveDown = CGAffineTransform(translationX: 0, y: containerView.frame.height - 450)
		let moveUp = CGAffineTransform(translationX: 0, y: -50)
		
		// Add both fromView and toView to the containerView
		if isPresenting {
			toView.transform = moveUp
			snapshot = fromView.snapshotView(afterScreenUpdates: true)
			containerView.addSubview(toView)
			containerView.addSubview(snapshot!) // snapshot added on top of toView
		}
		
		// Perform the animation
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
			
			if self.isPresenting {
				self.snapshot?.transform = moveDown
				toView.transform = CGAffineTransform.identity
			} else {
				self.snapshot?.transform = CGAffineTransform.identity
				fromView.transform = moveUp
			}
			
		}) { (finished) in
			transitionContext.completeTransition(true)
			if !self.isPresenting {
				self.snapshot?.removeFromSuperview()
			}
		}
	}
}
