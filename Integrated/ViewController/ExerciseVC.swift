//
//  ExcerciseVC.swift
//  Integrated
//
//  Created by developer on 2019/5/25.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse
import AVKit
import AVFoundation

class ExerciseVC: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var workout: Workout?
	var exercises = [Exercise]()
	
	static func instance(_ workout: Workout) -> ExerciseVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let exerciseVC = storyboard.instantiateViewController(withIdentifier: "ExerciseVC") as! ExerciseVC
		exerciseVC.workout = workout
		return exerciseVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		initUI()
		
		Helper.showLoading(target: self)
		WorkoutManager.sharedInstance.loadExercise(self.workout!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	@IBAction func onBackBtnClicked(_ sender: UIButton) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func initUI() {
		
	}
	
	func updateUI() {
		self.exercises = WorkoutManager.sharedInstance.excercies
		self.tableView.reloadData()
	}
}

extension ExerciseVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.exercises.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "ExcerciseCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExcerciseCell
		cell.exercise = self.exercises[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let exercise = self.exercises[indexPath.row]
		let videoFile = exercise.video
		let videoUrl = URL(string: videoFile.url!)!
		let player = AVPlayer(url: videoUrl)
		
		let vc = AVPlayerViewController()
		vc.player = player
		
		self.present(vc, animated: true) {
			vc.player?.play()
		}
	}
}

class ExcerciseCell: UITableViewCell {
	
	@IBOutlet weak var thumbView: PFImageView!
	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var durationView: UILabel!
	
	var exercise: Exercise? = nil {
		didSet {
			self.thumbView.file = self.exercise?.thumb
			self.thumbView.loadInBackground()
			
			self.titleView.text = self.exercise?.title
			
			let durationInSec = self.exercise?.durationInSec
			let hour = durationInSec! / 3600
			let minute = (durationInSec! - hour * 3600) / 60
			let second = durationInSec! % 60
			
			self.durationView.text = hour > 0 ? String(format: "%02d:%02d:%02d", hour, minute, second) : String(format: "%02d:%02d", minute, second)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
