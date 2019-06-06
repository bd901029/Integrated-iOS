//
//  SurveyGenderView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyGenderView: SurveyBaseView {

	@IBOutlet weak var btnMale: CustomButton!
	@IBOutlet weak var btnFemale: CustomButton!
	
	static func create() -> SurveyGenderView! {
		let view = UINib(nibName: "SurveyGenderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyGenderView
		return view
	}

	@IBAction func onGenderBtnTapped(_ sender: UIButton) {
		User.sharedInstance.setGender(sender == btnFemale)
		
		(self.parentViewController as? SurveyVC)?.goNext()
	}
}
