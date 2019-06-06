//
//  MainRootVC.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import LMSideBarController

class MainRootVC: LMSideBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		let sideBarDepthStyle = LMSideBarDepthStyle()
		sideBarDepthStyle.menuWidth = 300
		
		// Init view controllers
		let rightMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuVC") as! MainMenuVC
		let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavVC") as! MainNavVC
		
		// Setup side bar controller
		self.panGestureEnabled = false
		self.delegate = self
		self.setMenuView(rightMenuViewController, for: LMSideBarControllerDirection.right)
		self.setSideBarStyle(sideBarDepthStyle, for: LMSideBarControllerDirection.right)
		self.contentViewController = navigationController
		
		let mainVC = navigationController.viewControllers[0] as! MainVC
		rightMenuViewController.delegate = mainVC
	}
}

extension MainRootVC: LMSideBarControllerDelegate {
	
}
