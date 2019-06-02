//
//  MainMentalView.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MainMentalView: UIView {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var meditationTitleView: UILabel!
	@IBOutlet weak var meditationRemainedMinutesView: UILabel!
	
	var blogs = [Blog]()
	
	deinit {
		self.stopMeditationTimer()
	}
	
	static func create() -> MainMentalView! {
		let view = UINib(nibName: "MainMentalView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MainMentalView
		return view
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.initUI()
		
		self.startMeditationTimer()
	}
	
	@IBAction func onMeditationBtnTapped(_ sender: UIButton) {
		let vc = MeditationVC.instance()
		self.parentViewController?.present(vc, animated: true, completion: nil)
	}
	
	@IBAction func onYogaBtnTapped(_ sender: UIButton) {
		
	}
	
	@IBAction func onDailyReflectionBtnTapped(_ sender: UIButton) {
		
	}

	func initUI() {
		self.tableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.updateUI()
	}
	
	func updateUI() {
		let tags = ["mental"]
		self.blogs = BlogManager.sharedInstance.blogsByTags(tags)
		self.tableView.reloadData()
	}
	
	var meditationUpdateTimer: Timer? = nil
	func startMeditationTimer() {
		self.stopMeditationTimer()
		
		meditationUpdateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onMeditationUpdateTimer), userInfo: nil, repeats: true)
	}
	
	func stopMeditationTimer() {
		if meditationUpdateTimer != nil {
			meditationUpdateTimer?.invalidate()
			meditationUpdateTimer = nil
		}
	}
	
	@objc func onMeditationUpdateTimer() {
		let currentTrack = MeditationManager.sharedInstance.currentPlayingTrack
		let remainedDurationInSec = MeditationManager.sharedInstance.remainedDuration()
		if currentTrack == nil || remainedDurationInSec == 0 {
			self.meditationRemainedMinutesView.isHidden = true
			self.meditationTitleView.isHidden = true
		} else {
			self.meditationRemainedMinutesView.isHidden = false
			self.meditationTitleView.isHidden = false
			
			let minute = remainedDurationInSec / 60
			let second = remainedDurationInSec % 60
			self.meditationRemainedMinutesView.text = String(format: "%02d:%02d", minute, second)
			
			self.meditationTitleView.text = currentTrack!.title
		}
	}
}

extension MainMentalView: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.blogs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "BlogCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BlogCell
		cell.blog = self.blogs[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let blogDetailVC = storyboard.instantiateViewController(withIdentifier: "BlogDetailVC") as! BlogDetailVC
		blogDetailVC.blog = self.blogs[indexPath.row]
		self.parentViewController?.present(blogDetailVC, animated: true, completion: nil)
	}
}
