//
//  MainPhysicalView.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MainPhysicalView: UIView {
	
	@IBOutlet weak var caloriesBurnedView: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var blogs = [Blog]()
	
	static func create() -> MainPhysicalView! {
		let view = UINib(nibName: "MainPhysicalView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainPhysicalView
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		initUI()
	}
	
	func initUI() {
		self.tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.tableFooterView = UIView()
		
		self.updateUI()
	}
	
	func updateUI() {
		let calorieBurned = User.sharedInstance.calorieBurned()
		caloriesBurnedView.text = "\(Int(calorieBurned))"
	}
	
	@IBAction func onYourWorkoutBtnClicked(_ sender: UIButton) {
		let workoutVC = WorkoutVC.instance()
		let navController = UINavigationController(rootViewController: workoutVC)
		navController.isNavigationBarHidden = true
		self.parentViewController?.present(navController, animated: true, completion: nil)
	}
	
	@IBAction func onProgressTrackerBtnClicked(_ sender: UIButton) {
		let progressTrackerVC = ProgressTrackerVC.instance()
		let navController = UINavigationController(rootViewController: progressTrackerVC)
		navController.isNavigationBarHidden = true
		self.parentViewController?.present(navController, animated: true, completion: nil)
	}
}

extension MainPhysicalView: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.blogs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "BlogCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BlogCell
		cell.blog = self.blogs[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let blogDetailVC = storyboard.instantiateViewController(withIdentifier: "BlogDetailVC") as! BlogDetailVC
		blogDetailVC.blog = self.blogs[indexPath.row]
		self.parentViewController?.present(blogDetailVC, animated: true, completion: nil)
	}
}
