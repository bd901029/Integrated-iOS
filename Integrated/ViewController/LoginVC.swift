//
//  ViewController.swift
//  Integrated
//
//  Created by developer on 5/17/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {
	
	@IBOutlet weak var usernameView: UITextField!
	@IBOutlet weak var passwordView: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initUI()
		
		autoLogin()
	}

	@IBAction func onLoginBtnClicked(_ sender: UIButton) {
		login(usernameView.text!, passwordView.text!)
	}
	
	@IBAction func onRegisterBtnClicked(_ sender: UIButton) {
		gotoRegisterVC()
	}
	
	func initUI() {
		#if DEBUG
		usernameView.text = "q@q.com"
		passwordView.text = "q"
		#endif
	}
	
	func autoLogin() {
		if PFUser.current() != nil {
			usernameView.text = PFUser.current()?.email
			
			Helper.showLoading(target: self)
			User.sharedInstance.autoLogin { (error) in
				Helper.hideLoading(target: self)
				if error != nil {
					Helper.showAlert(target: self, title: "Error", message: error!.localizedDescription)
					return
				}
				
				self.gotoMainVC()
			}
		}
	}
	
	func login(_ username: String, _ password: String) {
		if username == "" || password == "" {
			return
		}
		
		Helper.showLoading(target: self)
		User.sharedInstance.login(username, password) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showAlert(target: self, title: "Error", message: error!.localizedDescription)
				return
			}
			
			self.gotoMainVC()
		}
	}
	
	func gotoMainVC() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let mainRootVC = storyboard.instantiateViewController(withIdentifier: "MainRootVC") as! MainRootVC
		self.navigationController?.pushViewController(mainRootVC, animated: true)
	}
	
	func gotoRegisterVC() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let mainVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
		self.navigationController?.pushViewController(mainVC, animated: true)
	}
}

