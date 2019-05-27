//
//  WorkoutVC.swift
//  Integrated
//
//  Created by developer on 2019/5/24.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class WorkoutVC: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	var workouts = [Workout]()
	
	static func instance() -> WorkoutVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let workoutVC = storyboard.instantiateViewController(withIdentifier: "WorkoutVC") as! WorkoutVC
		return workoutVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		initUI()
		
		Helper.showLoading(target: self)
		WorkoutManager.sharedInstance.load { (error) in
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
	
	@IBAction func onBackBtnClicked(_ sender: Any) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func initUI() {
		
	}
	
	func updateUI() {
		self.workouts = WorkoutManager.sharedInstance.workouts
		self.tableView.reloadData()
	}
}

extension WorkoutVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.workouts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "WorkoutCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkoutCell
		cell.workout = self.workouts[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let exerciseVC = ExerciseVC.instance(self.workouts[indexPath.row])
		self.navigationController?.pushViewController(exerciseVC, animated: true)
	}
}

class WorkoutCell: UITableViewCell {
	
	@IBOutlet weak var thumbView: PFImageView!
	@IBOutlet weak var titleView: UILabel!
	
	var workout: Workout? = nil {
		didSet {
			self.thumbView.file = self.workout?.thumb
			self.thumbView.loadInBackground()
			
			self.titleView.text = self.workout?.title
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
