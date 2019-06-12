//
//  SurveyLevelView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyLevelView: SurveyBaseView {

	@IBOutlet weak var levelSpinner: LBZSpinner!
	@IBOutlet weak var btnNext: UIButton!
	
	static func create() -> SurveyLevelView! {
		let view = UINib(nibName: "SurveyLevelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyLevelView
		return view
	}
	
	override func initUI() {
		self.levelSpinner.updateList(User.Levels)
		self.levelSpinner.delegate = self
		self.levelSpinner.changeSelectedIndex(0)
	}

	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		(self.parentViewController as? SurveyVC)?.goBack()
	}
	
	@IBAction func onNextBtnTapped(_ sender: UIButton) {
		User.sharedInstance.setLevel(levelSpinner.selectedIndex)
		
		(self.parentViewController as? SurveyVC)?.goNext()
	}
}

extension SurveyLevelView: LBZSpinnerDelegate {
	func spinnerChoose(_ spinner: LBZSpinner, index: Int, value: String) {
		btnNext.isHidden = false
	}
}
