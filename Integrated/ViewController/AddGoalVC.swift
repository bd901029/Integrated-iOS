//
//  AddGoalVC.swift
//  Integrated
//
//  Created by developer on 2019/6/11.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

protocol AddGoalDelegate {
	func addGoalDidChange()
}

class AddGoalVC: UIViewController {
	
	@IBOutlet weak var typeSpinner: LBZSpinner!
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var nameView: RoundTextField!
	@IBOutlet weak var valueView: RoundTextField!
	@IBOutlet weak var goalView: RoundTextField!
	
	var delegate: AddGoalDelegate? = nil
	
	var goalNames = [String]()
	var goals = [Goal]()
	var selectedGoal: Goal? = nil
	
	static func instance() -> AddGoalVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AddGoalVC") as! AddGoalVC
		vc.modalPresentationStyle = .overCurrentContext
		return vc
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateUI()
	}
	
	@IBAction func onCloseBtnTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onAddBtnTapped(_ sender: UIButton) {
		let strName = nameView.text!
		let strValue = valueView.text!
		let strGoal = goalView.text!
		
		if (strName == "" || strValue == "" || strGoal == "") {
			Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
			return
		}
		
		if (!strValue.isNumeric() || !strGoal.isNumeric()) {
			Helper.showErrorAlert(target: self, message: "Please input correct information.")
			return
		}
		
		let goal = Goal.create()
		goal.setName(strName)
		goal.setValue(Float(strValue)!)
		goal.setGoal(Int(strGoal)!)
		
		Helper.showLoading(target: self)
		GoalManager.sharedInstance.add(goal) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
			
			let index = self.goalNames.index(of: goal.name)!
			self.typeSpinner.changeSelectedIndex(index)
			
			self.delegate?.addGoalDidChange()
		}
	}
	
	@IBAction func onSaveBtnTapped(_ sender: UIButton) {
		if (selectedGoal == nil) {
			return
		}
		
		let strValue = valueView.text!
		let strGoal = goalView.text!
		
		if (strValue == "" || strGoal == "") {
			Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
			return
		}
		
		if (!strValue.isNumeric() || !strGoal.isNumeric()) {
			Helper.showErrorAlert(target: self, message: "Please input correct information.")
			return
		}
		
		selectedGoal!.setValue(Float(strValue)!)
		selectedGoal!.setGoal(Int(strGoal)!)
		
		Helper.showLoading(target: self)
		GoalManager.sharedInstance.save(self.selectedGoal!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
			
			self.delegate?.addGoalDidChange()
		}
	}
	
	func initUI() {
		typeSpinner.delegate = self
		
		self.tableView.tableFooterView = UIView()
	}
	
	func updateUI() {
		updateSpinner()
		updateGoalList()
		updateValueContainer()
	}
	
	func updateSpinner() {
		goalNames = GoalManager.sharedInstance.allNames()
		
		var list = goalNames
		list.append("Custom")
		
		typeSpinner.updateList(list)
	}
	
	func updateGoalList() {
		let selectedIndex = typeSpinner.selectedIndex
		if selectedIndex < goalNames.count {
			let goalType = goalNames[selectedIndex]
			goals = GoalManager.sharedInstance.goalsByType(goalType)
		} else {
			goals = [Goal]()
		}
		
		self.tableView.reloadData()
	}
	
	func updateValueContainer() {
		let selectedIndex = typeSpinner.selectedIndex
		if selectedIndex >= goalNames.count {
			nameView.isEnabled = true
			nameView.text = (selectedGoal != nil) ? selectedGoal?.name : ""
		} else {
			let goalName = goalNames[selectedIndex]
			nameView.isEnabled = false
			nameView.text = goalName
		}
		
		if goals.count > 0 {
			let lastGoal = goals.last!
			goalView.text = String(lastGoal.goal)
		} else {
			goalView.text = (selectedGoal != nil) ? String(selectedGoal!.goal) : ""
		}
		
		valueView.text = (selectedGoal != nil) ? String(selectedGoal!.value) : ""
	}
	
	func showDeleteConfirmation(_ goal: Goal) {
		let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .alert)
		
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
			GoalManager.sharedInstance.delete(goal)
			self.updateUI()
		}
		alertController.addAction(deleteAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
		}
		alertController.addAction(cancelAction)
		
		present(alertController, animated: true, completion: nil)
	}
}

extension AddGoalVC: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		self.selectedGoal = nil
		updateUI()
	}
}

extension AddGoalVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.goals.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddGoalCell", for: indexPath) as! AddGoalCell
		cell.goal = self.goals[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedGoal = self.goals[indexPath.row]
		updateValueContainer()
	}
}

class AddGoalCell: UITableViewCell {
	
	@IBOutlet weak var dateView: UILabel!
	@IBOutlet weak var valueView: UILabel!
	@IBOutlet weak var goalView: UILabel!
	
	var goal: Goal? = nil {
		didSet {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMMM dd yyyy"
			dateView.text = dateFormatter.string(from: self.goal!.date())
			
			valueView.text = String(self.goal!.value)
			goalView.text = String(self.goal!.goal)
		}
	}
	
	@IBAction func onDeleteBtnTapped(_ sender: UIButton) {
		let vc = self.parentViewController as? AddGoalVC
		vc?.showDeleteConfirmation(self.goal!)
	}
}
