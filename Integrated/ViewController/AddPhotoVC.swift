//
//  AddPhotoVC.swift
//  Integrated
//
//  Created by developer on 2019/5/27.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

protocol AddPhotoVCDelegate {
	func addPhotoVCDidAdded()
}

class AddPhotoVC: UIViewController {
	
	@IBOutlet weak var unitView: UITextField!
	@IBOutlet weak var weightView: RoundTextField!
	@IBOutlet weak var photoView: UIImageView!
	
	var selectedPhoto: UIImage? = nil {
		didSet {
			self.photoView.image = self.selectedPhoto
		}
	}
	
	let units = ["Lbs.", "Kg."]
	var selectedUnitIndex = 0 {
		didSet {
			self.unitView.text = self.units[self.selectedUnitIndex]
		}
	}
	
	var delegate: AddPhotoVCDelegate? = nil
	
	static func instance() -> AddPhotoVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AddPhotoVC") as! AddPhotoVC
		vc.modalPresentationStyle = .overCurrentContext
		return vc
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateUI()
	}
	
	@IBAction func onCloseBtnTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onPhotoBtnTapped(_ sender: Any) {
		let imagePicker = UIImagePickerController()
		imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
		imagePicker.delegate = self
		self.present(imagePicker, animated: true, completion: nil)		
	}
	
	@IBAction func onAddBtnTapped(_ sender: Any) {
		let strWeight = weightView.text
		if strWeight == "" || self.selectedPhoto == nil || !strWeight!.isNumeric() {
			Helper.showErrorAlert(target: self, message: "Please fulfill all data.")
			return
		}
		
		var weight = strWeight!.floatValue
		if self.selectedUnitIndex == 0 {
			weight = UnitHelper.kgFromLBS(weight)
		}
		
		Helper.showLoading(target: self)
		let gallery = Gallery.create(self.selectedPhoto!, weight)
		GalleryManager.sharedInstance.add(gallery) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.dismiss(animated: true, completion: {
				self.delegate?.addPhotoVCDidAdded()
			})
		}
	}
	
	private func initUI() {
		
	}
	
	private func updateUI() {
	}
	
	private func showUnitSelectionAlert() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		for index in 0 ..< self.units.count {
			let action = UIAlertAction(title: self.units[index], style: .default) { (action: UIAlertAction) in
				self.selectedUnitIndex = index
			}
			alertController.addAction(action)
		}
		self.present(alertController, animated: true, completion: nil)
	}
}

extension AddPhotoVC: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if textField == unitView {
			self.showUnitSelectionAlert()
			self.view.endEditing(true)
			return false
		}
		
		return true
	}
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let image = info[UIImagePickerControllerOriginalImage] as? UIImage
		self.selectedPhoto = image?.fixedOrientation()
		self.dismiss(animated: true, completion: nil)
	}
}
