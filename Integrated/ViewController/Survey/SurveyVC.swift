//
//  SurveyVC.swift
//  Integrated
//
//  Created by developer on 2019/6/5.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class SurveyVC: UIViewController {
	
	@IBOutlet weak var viewPager: ViewPager!
	@IBOutlet var pageButtons: [CustomButton]!
	@IBOutlet var dummyViews: [UIView]!
	
	let genderView = SurveyGenderView.create()
	let ageView = SurveyAgeView.create()
	let weightView = SurveyWeightView.create()
	let heightView = SurveyHeightView.create()
	let levelView = SurveyLevelView.create()
	let goalView = SurveyGoalView.create()
	let paceView = SurveyPaceView.create()
	let optimizeView = SurveyOptimizeView.create()
	var pageViews: [SurveyBaseView] = []
	
	static func instance() -> SurveyVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let workoutVC = storyboard.instantiateViewController(withIdentifier: "SurveyVC") as! SurveyVC
		return workoutVC
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
    }
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		if self.viewPager.currentPosition <= 0 {
			self.navigationController?.popViewController(animated: true)
			return
		}
		
		self.goBack()
	}
	
	func initUI() {
		pageViews = [genderView, ageView, weightView, heightView, levelView, goalView, paceView, optimizeView] as! [SurveyBaseView]
		
		viewPager.dataSource = self
		viewPager.delegate = self
		viewPager.pageControl.isHidden = true
		viewPager.scrollView.isScrollEnabled = false
		viewPager.scrollToPage(index: 0)
		
		for pageButton in self.pageButtons {
			pageButton.setBackgroundColor(color: UIColor.rgb(0x8D2BE2), forState: UIControl.State.selected)
		}
	}
	
	func updateUI() {
		
	}
	
	func goBack() {
		if self.viewPager.currentPosition >= self.pageViews.count {
			return
		}
		
		let index = max(self.viewPager.currentPosition-1, 0)
		self.viewPager.scrollToPage(index: index)
	}
	
	func goNext() {
		let index = min(self.viewPager.currentPosition+1, self.pageViews.count-1)
		self.viewPager.scrollToPage(index: index)
	}
}

extension SurveyVC: ViewPagerDataSource, ViewPagerDelegate {
	func numberOfItems(viewPager:ViewPager) -> Int {
		return self.pageViews.count;
	}
	
	func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
		let view = self.pageViews[index]
		view.updateUI()
		return view
	}
	
	func viewPager(_ viewPager: ViewPager, didSelectedItem itemIndex: Int) {
		for pageButton in self.pageButtons {
			pageButton.isSelected = itemIndex == self.pageButtons.index(of: pageButton)
		}
		
		for dummyView in self.dummyViews {
			dummyView.isHidden = (itemIndex == self.pageViews.count-1)
		}
	}
}
