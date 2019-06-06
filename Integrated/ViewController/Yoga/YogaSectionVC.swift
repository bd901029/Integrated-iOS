//
//  YogaSectionVC.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class YogaSectionVC: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var sections = [YogaSection]()
	
	static func instance() -> YogaSectionVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let workoutVC = storyboard.instantiateViewController(withIdentifier: "YogaSectionVC") as! YogaSectionVC
		return workoutVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
		
		Helper.showLoading(target: self)
		YogaManager.sharedInstance.load { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
		}
    }
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func initUI() {
		self.navigationController?.isNavigationBarHidden = true
		self.tableView.tableFooterView = UIView()
	}
	
	func updateUI() {
		self.sections = YogaManager.sharedInstance.sections
		self.tableView.reloadData()
	}
}

extension YogaSectionVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.sections.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "YogaSectionCell", for: indexPath) as! YogaSectionCell
		cell.section = self.sections[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let vc = YogaItemVC.instance(self.sections[indexPath.row])
		self.navigationController?.pushViewController(vc, animated: true)
	}
}

class YogaSectionCell: UITableViewCell {
	
	@IBOutlet weak var thumbView: PFImageView!
	@IBOutlet weak var titleView: UILabel!
	
	var section: YogaSection? = nil {
		didSet {
			self.thumbView.file = self.section?.cover
			self.thumbView.loadInBackground()
			
			self.titleView.text = self.section?.title
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
