//
//  MenuViewController.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 06/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

	var transitionImages = ["Doodle Icons-41", "Doodle Icons-42", "Doodle Icons-43", "Doodle Icons-44"]
	var transitions = ["Slide Down", "Slide Right", "Pop", "Rotate"]
	
	@IBOutlet var collectionView:UICollectionView! {
		didSet {
			collectionView.dataSource = self
			collectionView.delegate = self
		}
	}
		
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		collectionView.reloadData()
	}
	
	let slideDownAnimator = SlideDownAnimator()
	let slideRightAnimtor = SlideRightAnimator()
	let popAnimtor = PopAnimator()
	let rotateAnimator = RotateAnimator()
	let partialSlideDownAnimator = PartialSlideDownAnimator()
	
	// MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		let toViewController = segue.destination
		
		if segue.identifier == "ShowDetail" {
			guard let selectedindexPaths = collectionView.indexPathsForSelectedItems else { return }
			switch selectedindexPaths[0].row {
			case 0 : toViewController.transitioningDelegate = slideDownAnimator
			case 1 : toViewController.transitioningDelegate = slideRightAnimtor
			case 2 : toViewController.transitioningDelegate = popAnimtor
			case 3 : toViewController.transitioningDelegate = rotateAnimator
			default : break
			}
		} else if segue.identifier == "PartialSlideDown" {
			guard let infoViewController = toViewController as? InfoTableViewController else { return }
			if let prompt = navigationItem.prompt { infoViewController.currentItem = prompt }
			
			toViewController.transitioningDelegate = partialSlideDownAnimator
			partialSlideDownAnimator.delegate = self
		}
	}
	
	@IBAction func unwindFromInfo(segue: UIStoryboardSegue) {
		guard let sourceController = segue.source as? InfoTableViewController else { return }
		navigationItem.prompt = sourceController.currentItem
	}
}

extension MenuViewController: PartialSlideDownAnimatorDelegate {
	func dismiss() {
		dismiss(animated: true, completion: nil)
	}
}

extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return transitionImages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MenuCell
		
		cell.thumbnailImageView.image = UIImage(named: transitionImages[indexPath.row])
		cell.titleLabel.text = transitions[indexPath.row]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let width = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 80.0 : 100.0
		let height = (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 105.0: 130.0

		return CGSize(width: width, height: height)
	}
}
