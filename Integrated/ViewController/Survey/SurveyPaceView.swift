//
//  SurveyPaceView.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyPaceView: SurveyBaseView {

	@IBOutlet weak var btn50: CustomButton!
	@IBOutlet weak var btn100: CustomButton!
	
	static func create() -> SurveyPaceView! {
		let view = UINib(nibName: "SurveyPaceView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyPaceView
		return view
	}
	
	override func updateUI() {
		btn50.setTitle(User.sharedInstance.paceType() == User.PACE_LOSE ? "Lose .50 lbs Per Week" : "Gain .50 lbs Per Week", for: UIControlState.normal)
		btn100.setTitle(User.sharedInstance.paceType() == User.PACE_LOSE ? "Lose 1 lbs Per Week" : "Gain 1 lbs Per Week", for: UIControlState.normal)
	}

	@IBAction func onPaceOptionBtnTapped(_ sender: CustomButton) {
		User.sharedInstance.setPaceOption(sender == btn50 ? User.PACE_50 : User.PACE_100)
		
		(self.parentViewController as? SurveyVC)?.goNext()
		
		let optimizeView = (self.parentViewController as? SurveyVC)?.optimizeView
		optimizeView?.saveAndGotoHome()
	}
	
}
