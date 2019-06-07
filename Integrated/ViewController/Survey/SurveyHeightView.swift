//
//  SurveyHeightView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyHeightView: SurveyBaseView {

	@IBOutlet weak var feetView: RoundTextField!
	@IBOutlet weak var inchView: RoundTextField!
	@IBOutlet weak var cmView: RoundTextField!
	@IBOutlet weak var btnNext: UIButton!
	
	static func create() -> SurveyHeightView! {
		let view = UINib(nibName: "SurveyHeightView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyHeightView
		return view
	}

	override func initUI() {
		self.feetView.addTarget(self, action: #selector(onTextChanged(_:)), for: UIControlEvents.editingChanged)
		self.inchView.addTarget(self, action: #selector(onTextChanged(_:)), for: UIControlEvents.editingChanged)
		self.cmView.addTarget(self, action: #selector(onTextChanged(_:)), for: UIControlEvents.editingChanged)
		
		feetView.text = String(UnitHelper.feetFromCM(User.sharedInstance.heightInCM()))
		inchView.text = String(UnitHelper.inchFromCM(User.sharedInstance.heightInCM()))
		cmView.text = String(User.sharedInstance.heightInCM())
	}
	
	override func updateUI() {
		btnNext.isHidden = heightInCM() <= 0
	}
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		(self.parentViewController as? SurveyVC)?.goBack()
	}
	
	@IBAction func onNextBtnTapped(_ sender: UIButton) {
		User.sharedInstance.setHeightInCm(heightInCM())
		
		(self.parentViewController as? SurveyVC)?.goNext()
	}
	
	func heightInCM() -> Float {
		let strFeet = feetView.text!
		let strInch = inchView.text!
		let strCM = cmView.text!
		
		let feet = !strFeet.isNumeric() ? 0 : Float(strFeet)!
		let inch = !strInch.isNumeric() ? 0 : Float(strInch)!
		let cm = !strCM.isNumeric() ? 0 : Float(strCM)!
		
		let heightInCM = max(UnitHelper.cmFromFeetAndInch(feet, inch), cm);
		return heightInCM;
	}
	
	@objc func onTextChanged(_ sender: UITextField) {
		self.updateUI()
	}
}
