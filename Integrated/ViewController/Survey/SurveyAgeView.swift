//
//  SurveyAgeView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyAgeView: SurveyBaseView {

	@IBOutlet weak var ageView: RoundTextField!
	@IBOutlet weak var btnNext: UIButton!
	
	static func create() -> SurveyAgeView! {
		let view = UINib(nibName: "SurveyAgeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyAgeView
		return view
	}
	
	override func initUI() {
		ageView.delegate = self
		ageView.text = String(User.sharedInstance.age())
	}
	
	override func updateUI() {
		btnNext.isHidden = self.age() <= 0 || self.age() >= 99
	}

	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		(self.parentViewController as? SurveyVC)?.goBack()
	}
	
	@IBAction func onNextBtnTapped(_ sender: UIButton) {
		User.sharedInstance.setAge(self.age())
		
		(self.parentViewController as? SurveyVC)?.goNext()
	}
	
	func age() -> Int {
		let strAge = ageView.text!
		if strAge == "", !strAge.isNumeric() {
			return 0
		}
		
		return Int(strAge)!
	}
}

extension SurveyAgeView: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		self.updateUI()
		
		return true
	}
}
