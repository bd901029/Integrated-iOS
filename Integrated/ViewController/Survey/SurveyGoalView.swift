//
//  SurveyGoalView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyGoalView: SurveyBaseView {

	@IBOutlet weak var btnLose: CustomButton!
	@IBOutlet weak var btnGain: CustomButton!
	@IBOutlet weak var btnMaintain: CustomButton!
	
	static func create() -> SurveyGoalView! {
		let view = UINib(nibName: "SurveyGoalView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyGoalView
		return view
	}

	@IBAction func onGoalBtnClicked(_ sender: CustomButton) {
		if (sender == btnLose || sender == btnGain) {
			User.sharedInstance.setPaceType(sender == btnLose ? User.PACE_LOSE : User.PACE_GAIN)
			
			(self.parentViewController as? SurveyVC)?.viewPager.scrollToPage(index: 6)
		}
		
		if (sender == btnMaintain) {
			User.sharedInstance.setPaceType(User.PACE_MAINTAIN)
			
			(self.parentViewController as? SurveyVC)?.viewPager.scrollToPage(index: 7)
			
			let optimizeView = (self.parentViewController as? SurveyVC)?.optimizeView
			optimizeView?.saveAndGotoHome()
		}
	}
}
