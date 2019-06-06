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
		unitSpinner.updateList(Constants.WeightUnits)
		unitSpinner.delegate = self
		unitSpinner.changeSelectedIndex(0)
	}
	
	override func updateUI() {
		if unitSpinner.selectedIndex == 0 {
			weightView.text = String(UnitHelper.lbsFromKG(User.sharedInstance.weightInKg()))
		} else {
			weightView.text = String(User.sharedInstance.weightInKg())
		}
		
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
}

extension SurveyWeightView: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		btnNext.isHidden = self.weightInKG() <= 0
		
		return true
	}
}

extension SurveyWeightView: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		spinner.text = spinner.list[index]
		
		updateUI()
	}
}
