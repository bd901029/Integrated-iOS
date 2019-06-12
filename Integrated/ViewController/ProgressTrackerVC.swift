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
	@IBOutlet weak var tableContentView: UIView!
	
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
	@IBOutlet weak var goalButtonContainer: UIView!
	
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
	
	@IBAction func onAddStateBtnTapped(_ sender: UIButton) {
		let vc = AddStateVC.instance()
		vc.delegate = self
		present(vc, animated: true, completion: nil)
	}
	
	@IBAction func onAddGoalBtnTapped(_ sender: UIButton) {
		let vc = AddGoalVC.instance()
		vc.delegate = self
		present(vc, animated: true, completion: nil)
	}
	
	@IBAction func onGraphBtnTapped(_ sender: UIButton) {
		let vc = ProgressTrackerGraphVC.instance()
		present(vc, animated: true, completion: nil)
	}
	
	private func initUI() {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	private func updateUI() {
		self.updateGallery()
		self.updateState()
		self.updateGoal()
		
		updateLayout()
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
		let cellHeight: CGFloat = 30
		
		var customStateContainerFrame = customStateContainer.frame
		customStateContainerFrame.size.height = cellHeight * CGFloat(customNames.count)
		customStateContainer.frame = customStateContainerFrame
		
		for index in 0 ..< customNames.count {
			let name = customNames[index]
			let cell = ProgressTrackerStateCell.create()!
			cell.frame = CGRect(x: 0, y: CGFloat(index)*cellHeight, width: customStateContainer.frame.width, height: cellHeight)
			cell.name = name
			
			customStateContainer.addSubview(cell)
		}
	}
	
	private func updateGoal() {
		goalValueContainer.subviews.forEach({ $0.removeFromSuperview() })
		
		let goalNames = GoalManager.sharedInstance.allNames()
		let cellHeight: CGFloat = 30
		
		var frame = goalValueContainer.frame
		frame.size.height = cellHeight * CGFloat(goalNames.count)
		goalValueContainer.frame = frame
		
		for index in 0 ..< goalNames.count {
			let name = goalNames[index]
			let cell = ProgressTrackerGoalCell.create()!
			cell.goalName = name
			cell.frame = CGRect(x: 0, y: cellHeight * CGFloat(index),
								 width: goalValueContainer.frame.width, height: cellHeight)
			
			goalValueContainer.addSubview(cell)
		}
	}
	
	private func updateLayout() {
		var frame = stateButtonContainer.frame
		frame.origin.y = customStateContainer.frame.origin.y + customStateContainer.frame.height + 10
		stateButtonContainer.frame = frame
		
		frame = goalContainer.frame
		frame.origin.y = stateButtonContainer.frame.origin.y + stateButtonContainer.frame.height + 40
		goalContainer.frame = frame
		
		frame = goalButtonContainer.frame
		frame.origin.y = goalValueContainer.frame.origin.y + goalValueContainer.frame.height + 10
		goalButtonContainer.frame = frame
		
		frame = goalContainer.frame
		frame.size.height = goalButtonContainer.frame.origin.y + goalButtonContainer.frame.height
		goalContainer.frame = frame
		
		frame = tableContentView.frame
		frame.size.height = goalContainer.frame.origin.y + goalContainer.frame.height + 20
		tableContentView.frame = frame
	}
}

extension ProgressTrackerVC: AddPhotoVCDelegate {
	func addPhotoVCDidAdded() {
		self.updateUI()
	}
}

extension ProgressTrackerVC: AddStateDelegate {
	func addStateDidChange() {
		self.updateUI()
	}
}

extension ProgressTrackerVC: AddGoalDelegate {
	func addGoalDidChange() {
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
