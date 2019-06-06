//
//  SurveyOptimizeView.swift
//  Integrated
//
//  Created by developer on 2019/6/6.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class SurveyOptimizeView: SurveyBaseView {

	static func create() -> SurveyOptimizeView! {
		let view = UINib(nibName: "SurveyOptimizeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SurveyOptimizeView
		return view
	}
	
	func saveAndGotoHome() {
		User.sharedInstance.optimize()
		User.sharedInstance.save { (error) in
            let loginVC = (UIApplication.shared.delegate as! AppDelegate).loginVC!
            loginVC.gotoMainVC()
		}
	}
}
