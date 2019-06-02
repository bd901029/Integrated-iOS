//
//  MainVC.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import LMSideBarController
import BarcodeScanner

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
		self.viewPager.scrollToPage(index: selectedIndex+1)
	}
	
	@IBAction func onMenuBtnClicked(_ sender: UIButton) {
		self.sideBarController()?.showMenuViewController(in: LMSideBarControllerDirection.right)
	}
	
	private func initUI() {
		viewPager.dataSource = self
		viewPager.delegate = self
		viewPager.pageControl.isHidden = true
		self.view.sendSubview(toBack: viewPager)
		
		for i in 0 ... self.bottomButtons.count-1 {
			let button = self.bottomButtons[i]
			button.setBackgroundColor(color: self.bottomButtonColors[i], forState: UIControl.State.selected)
		}
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
	
	func openBarcodeScanner() {
		let viewController = BarcodeScannerViewController()
		viewController.codeDelegate = self
		viewController.errorDelegate = self
		viewController.dismissalDelegate = self
		
		present(viewController, animated: true, completion: nil)
	}
	
	func openAddDietary(_ dietary: Dietary) {
		Helper.showLoading(target: self)
		DietaryManager.sharedInstance.fetchInformation(dietary.nix_item_id) { (results, error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			if results!.count > 0 {
				let vc = AddDietaryVC.instance(results!.first as? Dietary)
				vc.delegate = self
				self.present(vc, animated: true, completion: nil)
			}
		}
	}
}


extension MainVC: ViewPagerDataSource, ViewPagerDelegate {
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
	
	func viewPager(_ viewPager: ViewPager, didSelectedItem itemIndex: Int) {
		for i in 0 ... self.bottomButtons.count-1 {
			self.bottomButtons[i].isSelected = i == itemIndex
		}
	}
}

extension MainVC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
	func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
		self.dismiss(animated: true, completion: nil)
		print(code)
		
		Helper.showLoading(target: self)
		DietaryManager.sharedInstance.searchByBarcode(code) { (results, error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			if results!.count > 0 {
				self.openAddDietary(results?.first as! Dietary)
			}
		}
	}
	
	func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
		print(error)
	}
	
	func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension MainVC: AddDietaryVCDelegate {
	func addDietaryCompleted(_ vc: AddDietaryVC) {
		self.updateUI()
	}
}
