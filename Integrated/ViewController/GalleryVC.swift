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
		self.cellSize = CGSize(width: (self.collectionView.frame.width-cellSpace*(numCol-1))/numCol,
							   height: 190)
	}
	
	private func updateUI() {
		self.items = GalleryManager.sharedInstance.items
		self.collectionView.reloadData()
	}
}

extension GalleryVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
			
			weightView.text = String(format: "%dlbs", self.gallery!.weightInLbs())
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	@IBAction func onDeleteBtnClicked(_ sender: UIButton) {
	}
}
