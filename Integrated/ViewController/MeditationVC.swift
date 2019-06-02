//
//  MeditationVC.swift
//  Integrated
//
//  Created by developer on 2019/5/31.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class MeditationVC: UIViewController {

	@IBOutlet weak var coverImageView: PFImageView!
	@IBOutlet weak var tableView: UITableView!
	
	var sections = [MeditationSection]()
	var sectionHeaders = [MeditationSectionHeader]()
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	static func instance() -> MeditationVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let workoutVC = storyboard.instantiateViewController(withIdentifier: "MeditationVC") as! MeditationVC
		return workoutVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
		self.load()
		
		NotificationCenter.default.addObserver(self, selector: #selector(onStartedPlaying(notification:)),
											   name: MeditationManager.NotificationStartedPlaying, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onFinishedPlaying(notification:)),
											   name: MeditationManager.NotificationFinishedPlaying, object: nil)
    }
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func onStartedPlaying(notification: Notification) {
		guard let track = notification.userInfo?["track"] as? MeditationTrack else {
			return
		}
		
		for section in self.sections {
			let tracks = MeditationManager.sharedInstance.tracksBySection(section)
			for tmpTrack in tracks {
				if tmpTrack.objectId == track.objectId {
					DispatchQueue.main.async {
						self.coverImageView.file = section.coverImage
						self.coverImageView.loadInBackground()
					}
					return
				}
			}
		}
	}
	
	@objc func onFinishedPlaying(notification: Notification) {
		DispatchQueue.main.async {
		}
	}
	
	func initUI() {
		self.tableView.tableFooterView = UIView()
	}
	
	func load() {
		Helper.showLoading(target: self)
		MeditationManager.sharedInstance.load { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.sections = MeditationManager.sharedInstance.allSections()
			self.updateUI()
		}
	}
	
	func updateUI() {
		if self.sections.count > 0 {
			let section = self.sections.first!
			self.coverImageView.file = section.coverImage
			self.coverImageView.loadInBackground()
		}
		
		self.sectionHeaders = [MeditationSectionHeader]()
		for section in self.sections {
			let sectionHeader = MeditationSectionHeader.create()
			sectionHeader?.section = section
			self.sectionHeaders.append(sectionHeader!)
		}
		
		self.tableView.reloadData()
	}
	
	func playTrack(_ track: MeditationTrack) {
		let currentTrack = MeditationManager.sharedInstance.currentPlayingTrack
		if currentTrack != nil && currentTrack!.objectId == track.objectId {
			if MeditationManager.sharedInstance.isPlaying() {
				MeditationManager.sharedInstance.pausePlay()
				self.updateUI()
			} else {
				MeditationManager.sharedInstance.resumePlay()
				self.updateUI()
			}
			return
		}
		
		Helper.showLoading(target: self)
		MeditationManager.sharedInstance.download(track) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			MeditationManager.sharedInstance.startPlay(track)
		}
	}
}

extension MeditationVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.sectionHeaders.count
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return self.sectionHeaders[section]
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return self.sectionHeaders[section].frame.height
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let curSection = self.sections[section]
		let tracks = MeditationManager.sharedInstance.tracksBySection(curSection)
		return tracks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "MeditationTrackCell", for: indexPath) as! MeditationTrackCell
		cell.track = MeditationManager.sharedInstance.tracksBySection(self.sections[indexPath.section])[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let track = MeditationManager.sharedInstance.tracksBySection(self.sections[indexPath.section])[indexPath.row]
		self.playTrack(track)
		
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}

class MeditationTrackCell: UITableViewCell {
	
	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var btnPlay: UIButton!
	
	var track: MeditationTrack? = nil {
		didSet {
			self.updateUI()
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		NotificationCenter.default.addObserver(self, selector: #selector(onStartedPlaying(notification:)),
											   name: MeditationManager.NotificationStartedPlaying, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onFinishedPlaying(notification:)),
											   name: MeditationManager.NotificationFinishedPlaying, object: nil)
	}
	
	@objc func onStartedPlaying(notification: Notification) {
		DispatchQueue.main.async {
			self.updateUI()
		}
	}
	
	@objc func onFinishedPlaying(notification: Notification) {
		DispatchQueue.main.async {
			self.updateUI()
		}
	}
	
	@IBAction func onPlayBtnTapped(_ sender: Any) {
		let meditationVC = self.parentViewController as? MeditationVC

		meditationVC?.playTrack(self.track!)
	}
	
	func updateUI() {
		self.titleView.text = self.track?.title
		
		if MeditationManager.sharedInstance.isPlaying() {
			let currentPlayingTrack = MeditationManager.sharedInstance.currentPlayingTrack
			self.btnPlay.isSelected = (currentPlayingTrack != nil && currentPlayingTrack!.objectId == self.track!.objectId)
		} else {
			self.btnPlay.isSelected = false
		}
	}
}
