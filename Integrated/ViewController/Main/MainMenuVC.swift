//
//  MainMenuVC.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

protocol MainMenuDelegate {
	func mainMenuOnProfileTapped()
	func mainMenuOnHomeIntegratedTapped()
	
	func mainMenuOnHomeNutritionTapped()
	func mainMenuOnAddFoodTapped()
	func mainMenuOnNutritionStatisticsTapped()
	func mainMenuOnDietaryJournalTapped()
	
	func mainMenuOnHomePhysicalTapped()
	func mainMenuOnYourWorkoutTapped()
	func mainMenuOnProgressTrackerTapped()
	
	func mainMenuOnHomeMentalTapped()
	func mainMenuOnYourMeditationTapped()
	func mainMenuOnYogaTapped()
	func mainMenuOnDailyReflectionTapped()
	
	func mainMenuOnSignOutTapped()
}

class MainMenuVC: UIViewController {

	@IBOutlet weak var avatarView: PFImageView!
	
	var delegate: MainMenuDelegate? = nil
	
	override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateUI()
	}
	
	func initUI() {
		
	}
	
	func updateUI() {
		self.avatarView.file = User.sharedInstance.avatarFile()
		self.avatarView.loadInBackground()
	}
	
	@IBAction func onMyProfileBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnProfileTapped()
	}
	
	@IBAction func onHomeIntegratedBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnHomeIntegratedTapped()
	}
	
	@IBAction func onHomeNutritionTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnHomeNutritionTapped()
	}
	
	@IBAction func onAddFoodTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnAddFoodTapped()
	}
	
	@IBAction func onNutritionStatisticsBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnNutritionStatisticsTapped()
	}
	
	@IBAction func onDietaryJournalBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnDietaryJournalTapped()
	}
	
	@IBAction func onHomePhysicalBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnHomePhysicalTapped()
	}
	
	@IBAction func onYourWorkoutBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnYourWorkoutTapped()
	}
	
	@IBAction func onProgressTrackerBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnProgressTrackerTapped()
	}
	
	@IBAction func onHomeMentalBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnHomeMentalTapped()
	}
	
	@IBAction func onYourMeditationBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnYourMeditationTapped()
	}
	
	@IBAction func onYogaBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnYogaTapped()
	}
	
	@IBAction func onDailyReflectionBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnDailyReflectionTapped()
	}
	
	@IBAction func onSignOutBtnTapped(_ sender: UIButton) {
		self.delegate?.mainMenuOnSignOutTapped()
	}
}
