//
//  InfoTableViewController.swift
//  ViewControllerTransitions
//
//  Created by Chris Huang on 09/10/2017.
//  Copyright © 2017 Chris Huang. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

	var menuItems = ["Home", "News", "Tech", "Finance", "Reviews"]
	var currentItem = "Home"
	
	// MARK: UITableViewDataSource and UITableViewDelegate
	
	override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuItems.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InfoCell
		
		// Configure the cell...
		cell.titleLabel.text = menuItems[indexPath.row]
		cell.titleLabel.textColor = (menuItems[indexPath.row] == currentItem) ? UIColor.white : UIColor.gray
		
		return cell
	}
	
	// MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let infoTableViewController = segue.source as? InfoTableViewController else { return }
		guard let selectedIndexPath = infoTableViewController.tableView.indexPathForSelectedRow else { return }
		currentItem = menuItems[selectedIndexPath.row]
	}
}
