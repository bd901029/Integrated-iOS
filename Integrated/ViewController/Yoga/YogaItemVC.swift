//
//  YogaItemVC.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class YogaItemVC: UIViewController {
	
	var section: YogaSection? = nil
	var items = [YogaItem]()

	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	static func instance(_ section: YogaSection) -> YogaItemVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "YogaItemVC") as! YogaItemVC
		vc.section = section
		return vc
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
		
		Helper.showLoading(target: self)
		YogaManager.sharedInstance.loadExercise(self.section!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
		}
    }
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func initUI() {
		self.titleView.text = self.section?.title
		
		self.tableView.tableFooterView = UIView()
	}
	
	func updateUI() {
		self.items = YogaManager.sharedInstance.items
		self.tableView.reloadData()
	}
}

extension YogaItemVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "YogaItemCell", for: indexPath) as! YogaItemCell
		cell.item = self.items[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let item = self.items[indexPath.row]
		let videoFile = item.video
		let videoUrl = URL(string: videoFile.url!)!
		let player = AVPlayer(url: videoUrl)
		
		let vc = AVPlayerViewController()
		vc.player = player
		
		self.present(vc, animated: true) {
			vc.player?.play()
		}
	}
}

class YogaItemCell: UITableViewCell {
	
	@IBOutlet weak var thumbView: PFImageView!
	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var durationView: UILabel!
	
	var item: YogaItem? = nil {
		didSet {
			self.thumbView.file = self.item?.thumb
			self.thumbView.loadInBackground()
			
			self.titleView.text = self.item?.title
			
			let durationInSec = self.item!.durationInSec
			let hour: Int = Int(durationInSec / 3600)
			let minute = (durationInSec - hour * 3600) / 60
			let second = durationInSec % 60
			
			if hour > 0 {
				durationView.text = String(format: "%02d:%02d:%02d", hour, minute, second)
			} else {
				durationView.text = String(format: "%02d:%02d", minute, second)
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
