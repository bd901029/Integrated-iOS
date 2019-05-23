//
//  RegisterVC.swift
//  Integrated
//
//  Created by developer on 2019/5/21.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
	
	@IBOutlet weak var btnAvatar: CustomButton!
	@IBOutlet weak var firstNameView: RoundTextField!
	@IBOutlet weak var lastNameView: RoundTextField!
	@IBOutlet weak var userNameView: RoundTextField!
	@IBOutlet weak var passwordView: RoundTextField!
	
	var avatar: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
		
		initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateUI()
	}
	
	@IBAction func onAvatarBtnClicked(_ sender: Any) {
		let imagePicker = UIImagePickerController()
		imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
		imagePicker.delegate = self
		self.present(imagePicker, animated: true, completion: nil)

	}
	
	@IBAction func onRegisterBtnClicked(_ sender: Any) {
	}
	
	private func initUI() {
		#if DEBUG
		firstNameView.text = "Mingzhe"
		lastNameView.text = "Qiu"
		userNameView.text = "q@q.com"
		passwordView.text = "q"
		#endif
	}
	
	private func updateUI() {
		if avatar != nil {
			btnAvatar.setImage(avatar, for: .normal)
		}
	}
	
	private func register() {
		let firstName = firstNameView.text
		let lastName = lastNameView.text
		let username = userNameView.text
		let password = passwordView.text
		
		if firstName == "" || lastName == "" || username == "" || password == "" {
			return
		}
		
		Helper.showLoading(target: self)
		User.sharedInstance.signup(username!, password!, firstName!, lastName!, avatar) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.gotoMainVC()
		}
	}
	
	private func gotoMainVC() {
		self.navigationController?.popViewController(animated: true)
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
		self.navigationController?.pushViewController(mainVC, animated: true)
	}
}

extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		self.avatar = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		self.dismiss(animated: true, completion: nil)
	}
}
