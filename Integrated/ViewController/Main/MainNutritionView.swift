//
//  MainNutritionView.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MainNutritionView: UIView {

	@IBOutlet weak var caloriesConsumedView: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var blogs = [Blog]()
	
	static func create() -> MainNutritionView! {
		let view = UINib(nibName: "MainNutritionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainNutritionView
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		initUI()
	}
	
	@IBAction func onNutritionStatisticsBtnTapped(_ sender: Any) {
		let vc = NutritionStatisticsVC.instance()
		self.parentViewController?.present(vc, animated: true, completion: nil)
	}
	
	@IBAction func onDietaryJournalBtnClicked(_ sender: UIButton) {
		let vc = DietaryJournalVC.instance()
		self.parentViewController?.present(vc, animated: true, completion: nil)
	}
	
	func initUI() {
		self.tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.updateUI()
	}
	
	func updateUI() {
		let caloriesConsumed = DietaryManager.sharedInstance.caloriesConsumed()
		caloriesConsumedView.text = "\(Int(caloriesConsumed))"
		
		let tags = ["nutrition"]
		self.blogs = BlogManager.sharedInstance.blogsByTags(tags)
		self.tableView.reloadData()
	}
}

extension MainNutritionView: UITableViewDataSource, UITableViewDelegate {
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
