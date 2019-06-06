//
//  ProfileVC.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class ProfileVC: UIViewController {

	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var avatarView: PFImageView!
	@IBOutlet weak var memberSinceView: UILabel!
	@IBOutlet weak var btnGener: UIButton!
	@IBOutlet weak var ageView: RoundTextField!
	@IBOutlet weak var weightView: RoundTextField!
	@IBOutlet weak var weightUnitSpinner: LBZSpinner!
	
	@IBOutlet weak var heightUnitSpinner: LBZSpinner!
	@IBOutlet weak var heightFeetInchContainer: UIView!
	@IBOutlet weak var heightFeetView: RoundTextField!
	@IBOutlet weak var heightInchView: RoundTextField!
	
	@IBOutlet weak var heightCMContainer: UIView!
	@IBOutlet weak var heightCMView: RoundTextField!
	
	@IBOutlet weak var levelSpinner: LBZSpinner!
	@IBOutlet weak var goalSpinner: LBZSpinner!
	
	@IBOutlet weak var paceOptionContainer: UIView!
	@IBOutlet weak var paceOptionTitleView: UILabel!
	@IBOutlet weak var paceOptionSpinner: LBZSpinner!
	@IBOutlet weak var calorieOverrideContainerMarginTop: NSLayoutConstraint!
	
	@IBOutlet weak var calorieOverrideContainer: UIView!
	@IBOutlet weak var calorieOverrideSwitch: UISwitch!
	@IBOutlet weak var customGoalView: RoundTextField!
	@IBOutlet weak var btnDone: CustomButton!
	@IBOutlet weak var btnDoneTopMargine: NSLayoutConstraint!
	
	static func instance() -> ProfileVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
		return vc
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateUI()
	}
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onDoneBtnTapped(_ sender: UIButton) {
		self.save()
	}
	
	@IBAction func onCalorieOverrideSwitchChanged(_ sender: UISwitch) {
		self.updateCustomGoalView()
	}
	
	func initUI() {
		self.avatarView.layer.cornerRadius = self.avatarView.frame.width / 2
		
		let weightUnits = ["Lbs.", "Kg."]
		self.weightUnitSpinner.updateList(weightUnits)
		self.weightUnitSpinner.delegate = self
		self.weightUnitSpinner.changeSelectedIndex(0)
		
		let heightUnits = ["Feet/Inch", "CM"]
		self.heightUnitSpinner.updateList(heightUnits)
		self.heightUnitSpinner.delegate = self
		self.heightUnitSpinner.changeSelectedIndex(0)
		
		let levels = ["Sedentary/Little Exercise", "3 Times Per Week", "4 Times Per Week", "5 Times Per Week"]
		self.levelSpinner.updateList(levels)
		
		let goals = ["Lose weight and retain Muscle", "Gain weight and build muscle", "Maintain my current weight and optimize my health"]
		self.goalSpinner.updateList(goals)
		self.goalSpinner.delegate = self
	}
	
	func updateUI() {
		self.updateAvatar()
		
		self.nameView.text = User.sharedInstance.fullName()
		self.memberSinceView.text = User.sharedInstance.memberSince()
		
		self.btnGener.isSelected = User.sharedInstance.gender()
		
		self.ageView.text = String(User.sharedInstance.age())
		
		heightCMView.text = String(Int(User.sharedInstance.heightInCM()))
		heightFeetView.text = String(Int(UnitHelper.feetFromCM(User.sharedInstance.heightInCM())))
		heightInchView.text = String(Int(UnitHelper.inchFromCM(User.sharedInstance.heightInCM())))
		
		var weight = User.sharedInstance.weightInKg()
		if weightUnitSpinner.selectedIndex == 0 {
			weight = UnitHelper.lbsFromKG(weight)
		}
		weightView.text = String(weight)
		
		levelSpinner.changeSelectedIndex(User.sharedInstance.level())
		goalSpinner.changeSelectedIndex(User.sharedInstance.paceType())
		paceOptionSpinner.changeSelectedIndex(User.sharedInstance.paceOption())
		
		calorieOverrideSwitch.isOn = User.sharedInstance.isOverride()
		self.updateCustomGoalView()
	}
	
	func updateAvatar() {
		let galleries = GalleryManager.sharedInstance.items
		if galleries.count > 0 {
			let item = galleries.last
			self.avatarView.file = item?.image
			self.avatarView.loadInBackground()
		}
	}
	
	func updatePaceOptionContainer() {
		let paceType = goalSpinner.selectedIndex
		if paceType == User.PACE_MAINTAIN {
			paceOptionContainer.isHidden = true
		} else {
			paceOptionContainer.isHidden = false
			
			let paceOptions = paceType == User.PACE_LOSE ? ["Lose .50 lbs Per Week", "Lose 1 lbs Per Week"] : ["Gain .50 lbs Per Week", "Gain 1 lbs Per Week"]
			paceOptionSpinner.updateList(paceOptions)
			
			if paceType == User.sharedInstance.paceType() {
				paceOptionSpinner.changeSelectedIndex(User.sharedInstance.paceOption())
			}
			
			paceOptionTitleView.text = paceType == User.PACE_LOSE ? "Rate of Weight Loss:" : "Rate of Weight Gain:"
		}
		
		self.calorieOverrideContainerMarginTop.constant = self.paceOptionContainer.isHidden ? 0 : 80
		self.calorieOverrideContainer.setNeedsUpdateConstraints()
	}
	
	func save() {
		let strAge = ageView.text
		if strAge!.isNumeric() == false {
			Helper.showErrorAlert(target: self, message: "Please input correct information.")
			return
		}
		
		let strWeight = weightView.text
		if strWeight!.isNumeric() == false {
			Helper.showErrorAlert(target: self, message: "Please input correct information.")
			return
		}
		let weightInKG = weightUnitSpinner.selectedIndex == 0 ? UnitHelper.kgFromLBS(Float(strWeight!)!) : Float(strWeight!)!
		
		var heightInCM: Float = 0
		if heightUnitSpinner.selectedIndex == 0 {
			let strFeet = heightFeetView.text
			let strInch = heightInchView.text
			if strFeet!.isNumeric() == false || strInch!.isNumeric() == false {
				Helper.showErrorAlert(target: self, message: "Please input correct information.")
				return
			}
			heightInCM = UnitHelper.cmFromFeetAndInch(Float(strFeet!)!, Float(strInch!)!)
		} else {
			let strCM = heightCMView.text
			if (strCM == "" || strCM!.isNumeric() == false) {
				Helper.showErrorAlert(target: self, message: "Please input correct information.")
				return
			}
			heightInCM = Float(strCM!)!
		}
		
		User.sharedInstance.setGender(btnGener.isSelected)
		
		User.sharedInstance.setAge(Int(strAge!)!)
		User.sharedInstance.setWeightInKg(weightInKG)
		User.sharedInstance.setHeightInCm(heightInCM)
		
		User.sharedInstance.setLevel(levelSpinner.selectedIndex)
		User.sharedInstance.setGoal(goalSpinner.selectedIndex)
		User.sharedInstance.setPaceType(goalSpinner.selectedIndex)
		User.sharedInstance.setPaceOption(paceOptionSpinner.selectedIndex)
		
		User.sharedInstance.setOverride(calorieOverrideSwitch.isOn)
		if calorieOverrideSwitch.isOn {
			let strCustomGoal = customGoalView.text
			if (strCustomGoal == "" || !strCustomGoal!.isNumeric()) {
				Helper.showErrorAlert(target: self, message: "Please input correct information.")
				return;
			}
			
			let customGoal = Int(strCustomGoal!)!
			User.sharedInstance.setCustomGoal(customGoal)
		}
		
		Helper.showLoading(target: self)
		User.sharedInstance.optimize()
		User.sharedInstance.save { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return;
			}
			
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	func updateCustomGoalView() {
		self.customGoalView.isHidden = !self.calorieOverrideSwitch.isOn
		if !self.customGoalView.isHidden {
			self.customGoalView.text = String(Int(User.sharedInstance.customGoal()))
		} else {
			self.customGoalView.text = ""
		}
		
		self.btnDoneTopMargine.constant = self.calorieOverrideSwitch.isOn ? 50 : 0
		self.btnDone.setNeedsUpdateConstraints()
	}
}

extension ProfileVC: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		spinner.text = spinner.list[index]
		
		if spinner == self.heightUnitSpinner {
			heightFeetInchContainer.isHidden = index == 1
			heightCMContainer.isHidden = index == 0
		}
		
		if spinner == self.goalSpinner {
			self.updatePaceOptionContainer()
		}
	}
}
