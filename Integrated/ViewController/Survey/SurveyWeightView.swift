//
//  SurveyWeightView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyWeightView: SurveyBaseView {

	@IBOutlet weak var weightView: RoundTextField!
	@IBOutlet weak var unitSpinner: LBZSpinner!
	@IBOutlet weak var btnNext: UIButton!
	
	static func create() -> SurveyWeightView! {
		let view = UINib(nibName: "SurveyWeightView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyWeightView
		return view
	}
	
	override func initUI() {
		weightView.addTarget(self, action: #selector(onWeightTextChanged(_:)), for: UIControlEvents.editingChanged)
		if unitSpinner.selectedIndex == 0 {
			weightView.text = String(UnitHelper.lbsFromKG(User.sharedInstance.weightInKg()))
		} else {
			weightView.text = String(User.sharedInstance.weightInKg())
		}
		
		unitSpinner.updateList(User.WeightUnits)
		unitSpinner.delegate = self
		unitSpinner.changeSelectedIndex(0)
		
		updateUI()
	}
	
	override func updateUI() {
		btnNext.isHidden = self.weightInKG() <= 0
	}

	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		(self.parentViewController as? SurveyVC)?.goBack()
	}
	
	@IBAction func onNextBtnTapped(_ sender: UIButton) {
		User.sharedInstance.setWeightInKg(weightInKG())
		
		(self.parentViewController as? SurveyVC)?.goNext()
	}
	
	func weightInKG() -> Float {
		let strWeight = weightView.text!
		if !strWeight.isNumeric() {
			return 0;
		}
		
		var weight = Float(strWeight)!
		if unitSpinner.selectedIndex == 0 {
			weight = UnitHelper.kgFromLBS(weight)
		}
		
		return weight;
	}
	
	@objc func onWeightTextChanged(_ sender: UITextField) {
		btnNext.isHidden = self.weightInKG() <= 0
	}
}

extension SurveyWeightView: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		spinner.text = spinner.list[index]
		
		updateUI()
	}
}
