//
//  GalleryVC.swift
//  Integrated
//
//  Created by developer on 2019/5/27.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class GalleryVC: UIViewController {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var items = [Gallery]()
	var cellSize: CGSize?
	
	static func instance() -> GalleryVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let galleryVC = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
		return galleryVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.updateUI()
	}
	
	@IBAction func onBackBtnClicked(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func onAddPhotoBtnClicked(_ sender: UIButton) {
		let addPhotoVC = AddPhotoVC.instance()
		addPhotoVC.delegate = self
		self.present(addPhotoVC, animated: true, completion: nil)
	}
	
	private func initUI() {
		let cellSpace: CGFloat = 10
		let numCol: CGFloat = 3
		self.cellSize = CGSize(width: (self.collectionView.frame.width-cellSpace*numCol)/numCol,
							   height: 190)
	}
	
	func updateUI() {
		self.items = GalleryManager.sharedInstance.items
		self.collectionView.reloadData()
	}
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return self.cellSize!
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellIdentifier = "GalleryCell"
		let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GalleryCell
		cell.gallery = self.items[indexPath.row]
		return cell
	}
}

extension GalleryVC: AddPhotoVCDelegate {
	func addPhotoVCDidAdded() {
		self.updateUI()
	}
}

class GalleryCell: UICollectionViewCell {
	
	@IBOutlet weak var imageView: PFImageView!
	@IBOutlet weak var dateView: UILabel!
	@IBOutlet weak var weightView: UILabel!
	
	var gallery: Gallery? {
		didSet {
			self.imageView.file = self.gallery?.image
			self.imageView.loadInBackground()
			
			if let date = self.gallery?.date() {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "MMMM dd yyyy"
				self.dateView.text = dateFormatter.string(from: date)
			}
			
			weightView.text = String(format: "%dlbs", Int(self.gallery!.weightInLbs()))
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func onDeleteBtnClicked(_ sender: UIButton) {
		self.showDeleteConfirmation()
	}
	
	private func showDeleteConfirmation() {
		let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete?", preferredStyle: .alert)
		
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
			self.deleteGallery()
		}
		alertController.addAction(deleteAction)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action: UIAlertAction) in
			self.deleteGallery()
		}
		alertController.addAction(cancelAction)
		
		self.parentViewController!.present(alertController, animated: true, completion: nil)
	}
	
	private func deleteGallery() {
		let vc = self.parentViewController as! GalleryVC
		
		Helper.showLoading(target: vc)
		GalleryManager.sharedInstance.delete(self.gallery!) { (error) in
			Helper.hideLoading(target: vc)
			if error != nil {
				Helper.showErrorAlert(target: vc, message: error!.localizedDescription)
				return
			}
			
			vc.updateUI()
		}
	}
}
