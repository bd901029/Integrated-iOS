//
//  AddStateVC.swift
//  Integrated
//
//  Created by developer on 2019/6/11.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

protocol AddStateDelegate {
	func addStateDidChange()
}

class AddStateVC: UIViewController {

	@IBOutlet weak var typeSpinner: LBZSpinner!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var nameView: RoundTextField!
	
	@IBOutlet weak var valueContainer: UIView!
	@IBOutlet weak var valueView: RoundTextField!
	
	@IBOutlet weak var minMaxContainer: UIStackView!
	@IBOutlet weak var maxView: RoundTextField!
	@IBOutlet weak var minView: RoundTextField!
	
	@IBOutlet weak var btnAdd: CustomButton!
	@IBOutlet weak var btnSave: CustomButton!
	
	var delegate: AddStateDelegate? = nil
	
	var states = [State]()
	var selectedState: State? = nil
	var stateTypes = State.types()
	
	static func instance() -> AddStateVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AddStateVC") as! AddStateVC
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
		let selectedIndex = typeSpinner.selectedIndex
		let stateType = stateTypes[selectedIndex]
		let strName = nameView.text!
		if (strName == "") {
			Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
			return
		}
		
		let state = State.create()
		state.setType(stateType);
		state.setName(strName);
		
		if (stateType == State.Kind.BloodPressure) {
			let strMin = minView.text!
			let strMax = maxView.text!
			
			if (strMin == "" || strMax == "") {
				Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
				return
			}
			
			state.setMinValue(Int(strMin)!)
			state.setMaxValue(Int(strMax)!)
		} else {
			let strValue = valueView.text!
			if (strValue == "") {
				Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
				return;
			}
			
			state.setValue(Int(strValue)!)
		}
		
		Helper.showLoading(target: self)
		StateManager.sharedInstance.add(state) { (error) in
			Helper.hideLoading(target: self)
			if (error != nil) {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
			self.delegate?.addStateDidChange()
		}
	}
	
	@IBAction func onSaveBtnTapped(_ sender: UIButton) {
		if selectedState == nil {
			return
		}
		
		let stateType = selectedState?.type
		if (stateType == State.Kind.BloodPressure) {
			let strMin = minView.text!
			let strMax = maxView.text!
			
			if (strMin == "" || strMax == "") {
				Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
				return
			}
			
			selectedState!.setMinValue(Int(strMin)!)
			selectedState!.setMaxValue(Int(strMax)!)
		} else {
			let strValue = valueView.text!
			if (strValue == "") {
				Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
				return
			}
			
			selectedState!.setValue(Int(strValue)!)
		}
		
		Helper.showLoading(target: self)
		StateManager.sharedInstance.save(selectedState!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()			
			self.delegate?.addStateDidChange()
		}
	}
	
	func initUI() {
		typeSpinner.updateList(self.stateTypes)
		typeSpinner.delegate = self
		
		tableView.tableFooterView = UIView()
	}
	
	func updateUI() {
		updateTableView()
		updateValueContainer()
	}
	
	func updateTableView() {
		let selectedIndex = typeSpinner.selectedIndex
		let stateType = self.stateTypes[selectedIndex]
		self.states = StateManager.sharedInstance.statesByType(stateType)
		self.tableView.reloadData()
	}
	
	func updateValueContainer() {
		let selectedIndex = typeSpinner.selectedIndex
		let stateType = self.stateTypes[selectedIndex]
		if stateType == State.Kind.BloodPressure {
			valueContainer.isHidden = true
			minMaxContainer.isHidden = false
		} else {
			valueContainer.isHidden = false
			minMaxContainer.isHidden = true
		}
		
		if stateType == State.Kind.Custom {
			nameView.isEnabled = true
			nameView.text = ""
		} else {
			nameView.isEnabled = false
			nameView.text = stateType
		}
		
		if selectedState != nil {
			nameView.text = selectedState!.name
			if selectedState!.type == State.Kind.BloodPressure {
				maxView.text = String(selectedState!.maxValue)
				minView.text = String(selectedState!.minValue)
			} else {
				valueView.text = String(selectedState!.value())
			}
		} else {
			if stateType == State.Kind.Custom {
				nameView.text = ""
			} else {
				nameView.text = stateType
			}
			maxView.text = ""
			minView.text = ""
			valueView.text = ""
		}
	}
}

extension AddStateVC: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		self.selectedState = nil
		self.updateUI()
	}
}

extension AddStateVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.states.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddStateCell", for: indexPath) as! AddStateCell
		cell.state = self.states[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedState = self.states[indexPath.row]
		self.updateValueContainer()
	}
}

class AddStateCell: UITableViewCell {
	
	@IBOutlet weak var dateView: UILabel!
	@IBOutlet weak var maxView: UILabel!
	@IBOutlet weak var minValue: UILabel!
	
	var state: State? {
		didSet {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMMM dd yyyy"
			dateView.text = dateFormatter.string(from: self.state!.date())
			
			if self.state!.type == State.Kind.BloodPressure {
				maxView.isHidden = false
				maxView.text = String(Int(self.state!.maxValue))
				minValue.text = String(Int(self.state!.minValue))
			} else {
				maxView.isHidden = true
				minValue.text = String(Int(self.state!.value()))
			}
		}
	}
}
