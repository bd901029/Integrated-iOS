//
//  MainHomeView.swift
//  Integrated
//
//  Created by developer on 2019/5/22.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MainHomeView: UIView {
	
	@IBOutlet weak var calorieChartContainer: UIView!
	var calorieChart: KNCirclePercentView!
	@IBOutlet weak var calorieConsumedView: UILabel!
	@IBOutlet weak var calorieGoalView: UILabel!
	
	@IBOutlet weak var tableView: UITableView!
	var blogs = [Blog]()
	
	static func create() -> MainHomeView! {
		let view = UINib(nibName: "MainHomeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainHomeView
		return view
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.initUI()
	}
	
	@IBAction func onScanFoodBtnClicked(_ sender: Any) {
		if let mainVC = self.parentViewController as? MainVC {
			mainVC.openBarcodeScanner()
		}
	}
	
	func initUI() {
		self.calorieChart = KNCirclePercentView(frame: self.calorieChartContainer.bounds)
		self.calorieChart.percentLabel.isHidden = true
		self.calorieChart.fillColor = UIColor.clear
		self.calorieChart.strokeColor = UIColor(red:16/255, green: 119/255, blue: 234/255, alpha: 1.0)
		self.calorieChartContainer.addSubview(self.calorieChart)
		
		self.tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell") 
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.tableFooterView = UIView()
		
		updateUI()
	}
	
	func updateUI() {
		let dietaries = DietaryManager.sharedInstance.dietariesByDate(Date())
		var calorieConsumed: Float = 0
		for dietary in dietaries {
			calorieConsumed += dietary.caloriesInKCal() * Float(dietary.count)
		}
		calorieConsumedView.text = "\(Int(calorieConsumed))"
		
		let calorieGoal = User.sharedInstance.isOverride() ? User.sharedInstance.customGoal() : User.sharedInstance.calorieGoal()
		self.calorieGoalView.text = "\(Int(calorieGoal))"
		
		let calorieProgress: Float = calorieConsumed / calorieGoal * 100.0 + 0.5;
		if (calorieProgress < NutrientCalculator.MAX_PERCENT) {
			self.calorieChart.strokeColor = UIColor.notFull()
			self.calorieChart.updatePercent(CGFloat(calorieProgress))
		} else {
			self.calorieChart.strokeColor = UIColor.full()
			self.calorieChart.updatePercent(CGFloat(calorieProgress))
		}		
		
		self.blogs = BlogManager.sharedInstance.blogs
		self.tableView.reloadData()
	}
}

extension MainHomeView: UITableViewDelegate, UITableViewDataSource {
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

extension UIView {
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}
