//
//  ProgressTrackerVC.swift
//  Integrated
//
//  Created by developer on 2019/5/25.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class ProgressTrackerVC: UIViewController {

	@IBOutlet weak var day1PhotoView: PFImageView!
	@IBOutlet weak var day1WeightView: UILabel!
	
	@IBOutlet weak var currentPhotoView: PFImageView!
	@IBOutlet weak var currentWeightView: UILabel!
	
	@IBOutlet var defaultStateStartViews: [UILabel]!
	@IBOutlet var defaultStateCurrentViews: [UILabel]!
	@IBOutlet weak var customStateContainer: UIView!
	@IBOutlet weak var stateButtonContainer: UIView!
	
	@IBOutlet weak var goalContainer: UIView!
	@IBOutlet weak var goalValueContainer: UIView!
	
	let statesTypes = State.types()
	let goalNames = [String]()
	
	static func instance() -> ProgressTrackerVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let progressTrackerVC = storyboard.instantiateViewController(withIdentifier: "ProgressTrackerVC") as! ProgressTrackerVC
		return progressTrackerVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateUI()
	}
	
	@IBAction func onBackBtnClicked(_ sender: UIButton) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onGalleryBtnClicked(_ sender: UIButton) {
		let galleryVC = GalleryVC.instance()
		self.navigationController?.pushViewController(galleryVC, animated: true)
	}
	
	@IBAction func onAddPhotoBtnClicked(_ sender: UIButton) {
		let vc = AddPhotoVC.instance()
		vc.delegate = self
		self.present(vc, animated: true, completion: nil)
	}
	
	private func initUI() {
		
	}
	
	private func updateUI() {
		self.updateGallery()
		self.updateState()
		self.updateGoal()
	}
	
	private func updateGallery() {
		let galleries = GalleryManager.sharedInstance.items
		if galleries.count > 0 {
			let firstItem = galleries.first
			day1PhotoView.file = firstItem?.image
			day1PhotoView.loadInBackground()
			day1WeightView.text = String(format: "%dlbs", Int(firstItem!.weightInLbs()))
			
			let currentItem = galleries.last
			currentPhotoView.file = currentItem?.image
			currentPhotoView.loadInBackground()
			currentWeightView.text = String(format: "%dlbs", Int(currentItem!.weightInLbs()))
		} else {
			if let emptyImage = Gallery.emptyImage() {
				day1PhotoView.image = emptyImage
				currentPhotoView.image = emptyImage
			}
			
			day1WeightView.text = "-"
			currentWeightView.text = "-"
		}
	}
	
	private func updateState() {
		for i in 0 ..< defaultStateStartViews.count {
			let type = self.statesTypes[i]
			let startView = self.defaultStateStartViews[i]
			let currentView = self.defaultStateCurrentViews[i]
			
			let states = StateManager.sharedInstance.statesByType(type)
			if states.count > 0 {
				let start = states.first
				let current = states.last
				if type == State.Kind.BloodPressure {
					startView.text = String(format: "%d/%d", Int(start!.maxValue), Int(start!.minValue))
					currentView.text = String(format: "%d/%d", Int(current!.maxValue), Int(current!.minValue))
				} else {
					startView.text = String(format: "%d", Int(start!.value()))
					currentView.text = String(format: "%d", Int(current!.value()))
				}
			} else {
				startView.text = "-"
				currentView.text = "-"
			}
		}
		
		customStateContainer.subviews.forEach({ $0.removeFromSuperview() })
		let customNames = StateManager.sharedInstance.customNames()
		var cellHeight: CGFloat = 0
		for index in 0 ..< customNames.count {
			let name = customNames[index]
			let cell = ProgressTrackerStateCell.create()
			cell?.name = name
			customStateContainer.addSubview(cell!)
			cellHeight = cell!.bounds.height
		}
		
		customStateContainer.frame = CGRect(x: customStateContainer.frame.origin.x,
											y: customStateContainer.frame.origin.y,
											width: customStateContainer.frame.width,
											height: cellHeight * CGFloat(customNames.count))
		
		stateButtonContainer.frame = CGRect(x: stateButtonContainer.frame.origin.x,
											y: customStateContainer.frame.origin.y + customStateContainer.frame.height + 10,
											width: stateButtonContainer.frame.width,
											height: stateButtonContainer.frame.height)
		
		goalContainer.frame = CGRect(x: goalContainer.frame.origin.x,
									 y: stateButtonContainer.frame.origin.y + stateButtonContainer.frame.height,
									 width: goalContainer.frame.width,
									 height: goalContainer.frame.height)
	}
	
	private func updateGoal() {
		goalValueContainer.subviews.forEach({ $0.removeFromSuperview() })
		
		let goalNames = GoalManager.sharedInstance.allNames()
		var cellHeight: CGFloat = 0
		for name in goalNames {
			let cell = ProgressTrackerGoalCell.create()
			cell?.goalName = name
			goalValueContainer.addSubview(cell!)
			
			cellHeight = cell!.bounds.height
		}
		
		goalValueContainer.frame = CGRect(x: goalValueContainer.frame.origin.x,
										  y: goalValueContainer.frame.origin.y,
										  width: goalValueContainer.frame.width,
										  height: cellHeight * CGFloat(goalNames.count))
		
		goalContainer.frame = CGRect(x: goalContainer.frame.origin.x,
									 y: goalContainer.frame.origin.y,
									 width: goalContainer.frame.width,
									 height: goalValueContainer.frame.origin.y + goalValueContainer.frame.height + 80)
		
		goalContainer.superview?.frame = CGRect(x: goalContainer.superview!.frame.origin.x,
												y: goalContainer.superview!.frame.origin.y,
												width: goalContainer.superview!.frame.width,
												height: goalContainer.frame.origin.y + goalContainer.frame.height)
	}
}

extension ProgressTrackerVC: AddPhotoVCDelegate {
	func addPhotoVCDidAdded() {
		self.updateUI()
	}
}

class ProgressTrackerStateCell: UIView {
	
	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var startView: UILabel!
	@IBOutlet weak var currentView: UILabel!
	
	static func create() -> ProgressTrackerStateCell! {
		let view = UINib(nibName: "ProgressTrackerStateCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProgressTrackerStateCell
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	var name: String? = nil {
		didSet {
			let states = StateManager.sharedInstance.statesByName(self.name!)
			let start = states.first
			let current = states.last
			
			self.nameView.text = start?.name
			self.startView.text = String(format: "%d", start!.value())
			self.currentView.text = String(format: "%d", current!.value())
		}
	}
}

class ProgressTrackerGoalCell: UIView {
	
	@IBOutlet var nameView: UILabel!
	@IBOutlet var startView: UILabel!
	@IBOutlet var currentView: UILabel!
	@IBOutlet var goalView: UILabel!
	
	static func create() -> ProgressTrackerGoalCell! {
		let view = UINib(nibName: "ProgressTrackerGoalCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProgressTrackerGoalCell
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	var goalName: String? = nil {
		didSet {
			self.nameView.text = self.goalName
			
			let goals = GoalManager.sharedInstance.goalsByName(self.goalName!)
			if goals.count > 0 {
				let start = goals.first
				let current = goals.last
				
				startView.text = String(format: "%d", start!.value)
				currentView.text = String(format: "%d", current!.value)
				goalView.text = String(format: "%d", current!.goal)
			} else {
				startView.text = "-"
				currentView.text = "-"
				goalView.text = "-"
			}
		}
	}
}
