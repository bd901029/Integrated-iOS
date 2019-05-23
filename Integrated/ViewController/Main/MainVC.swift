//
//  MainVC.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import LMSideBarController

class MainVC: UIViewController {

	@IBOutlet weak var viewPager: ViewPager!
	
	@IBOutlet var bottomButtons: [UIButton]!
	let bottomButtonColors: [UIColor] = [UIColor.primary(),
										 UIColor.nutrition(),
										 UIColor.physical(),
										 UIColor.mental()]
	
	var homeView: MainHomeView? = nil
	var nutritionView: MainNutritionView? = nil
	var physicalView: MainPhysicalView? = nil
	var mentalView: MainMentalView? = nil
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateUI()
	}
	
	@IBAction func onBottomBtnClicked(_ sender: UIButton) {
		let selectedIndex = self.bottomButtons.index(of: sender)!
		for i in 0 ... self.bottomButtons.count-1 {
			self.bottomButtons[i].backgroundColor = i == selectedIndex ? self.bottomButtonColors[selectedIndex] : UIColor.primary()
		}
		
		self.viewPager.scrollToPage(index: selectedIndex+1)
	}
	
	@IBAction func onMenuBtnClicked(_ sender: UIButton) {
		self.sideBarController()?.showMenuViewController(in: LMSideBarControllerDirection.right)
	}
	
	private func initUI() {
		viewPager.dataSource = self
		viewPager.pageControl.isHidden = true
		viewPager.scrollToPage(index: 0)
		self.view.sendSubviewToBack(viewPager)
	}
	
	private func updateUI() {
		self.homeView?.updateUI()
		self.nutritionView?.updateUI()
		self.physicalView?.updateUI()
		self.mentalView?.updateUI()
	}
	
	func sideBarController() -> LMSideBarController? {
		var iter = self.parent
		while iter != nil {
			if iter!.isKind(of: LMSideBarController.self) {
				return (iter as! LMSideBarController)
			} else if iter?.parent != nil, iter?.parent != iter {
				iter = iter?.parent
			} else {
				iter = nil
			}
		}
		
		return nil
	}
}


extension MainVC: ViewPagerDataSource {
	func numberOfItems(viewPager:ViewPager) -> Int {
		return 4;
	}
	
	func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
		if index == 0 {
			if self.homeView == nil {
				self.homeView = MainHomeView.create()
			}
			
			return self.homeView!
		} else if index == 1 {
			if self.nutritionView == nil {
				self.nutritionView = MainNutritionView.create()
			}
			return self.nutritionView!
		} else if index == 2 {
			if self.physicalView == nil {
				self.physicalView = MainPhysicalView.create()
			}
			return self.physicalView!
		} else if index == 3 {
			if self.mentalView == nil {
				self.mentalView = MainMentalView.create()
			}
			return self.mentalView!
		}
		
		return view!
	}
}
