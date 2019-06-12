//
//  User.swift
//  Integrated
//
//  Created by developer on 2019/5/19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import Parse

class User: ApiManager {
	static let sharedInstance : User = {
		let instance = User()
		return instance
	}()
	
	public static let PACE_LOSE = 0
	public static let PACE_GAIN = 1
	public static let PACE_MAINTAIN = 2
	
	public static let PACE_50 = 0
	public static let PACE_100 = 1
	
	class Key {
		static let ClassName = "User"
		static let FirstName = "firstName"
		static let LastName = "lastName"
		static let Gender = "gender"
		static let Weight = "weightInKG"
		static let Height = "heightInCM"
		static let Level = "level"
		static let Goal = "goal"
		static let CalorieGoal = "calorieGoal"
		static let Avatar = "avatar"
		static let Age = "age"
		static let Override = "override"
		static let CustomGoal = "customGoal"
		static let PaceType = "paceType"
		static let PaceOption = "paceOption"
	}
	
	static let WeightUnits = ["Lbs.", "Kg."]
	
	static let HeightUnits = ["Feet/Inch", "CM"]
	
	static let Levels = ["Sedentary/Little Exercise",
						 "3 Times Per Week",
						 "4 Times Per Week",
						 "5 Times Per Week"]
	
	static let Goals = ["Lose weight and retain Muscle",
						"Gain weight and build muscle",
						"Maintain my current weight and optimize my health"]
	
	static let paceOptionsLose = ["Lose .50 lbs Per Week", "Lose 1 lbs Per Week"]
	static let paceOptionsGain = ["Gain .50 lbs Per Week", "Gain 1 lbs Per Week"]
	
	var object: PFObject!
	
	public func getObject() -> PFUser? {
		if self.object != nil {
			return self.object as? PFUser
		}
		
		return PFUser.current()
	}
	
	public func userId() -> String {
		return (self.object as! PFUser).objectId!
	}
	
	public func username() -> String {
		return (self.object as! PFUser).username!
	}
	
	public func email() -> String {
		return (self.object as! PFUser).email!
	}
	
	public func memberSince() -> String {
		let createdAt = (object as! PFUser).createdAt!
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM yyyy"
		return "Member Since: " + dateFormatter.string(from: createdAt)
	}
	
	public func firstName() -> String {
		if let firstName = self.object[Key.FirstName] as? String {
			return firstName
		}
		return ""
	}
	
	public func lastName() -> String {
		if let lastName = self.object[Key.LastName] as? String {
			return lastName
		}
		return ""
	}
	
	public func fullName() -> String {
		return firstName() + " " + lastName()
	}
	
	public func gender() -> Bool { /// True if Female
		return (self.object[Key.Gender] as! Bool)
	}
	
	public func weightInKg() -> Float {
		if let number = self.object[Key.Weight] as? NSNumber {
			return number.floatValue
		}
		return 0
	}
	
	public func heightInCM() -> Float {
		if let number = self.object[Key.Height] as? NSNumber {
			return number.floatValue
		}
		return 0
	}
	
	public func age() -> Int {
		if let number = self.object[Key.Age] as? NSNumber {
			return number.intValue
		}
		return 0
	}
	
	public func level() -> Int {
		if let number = self.object[Key.Level] as? NSNumber {
			return number.intValue
		}
		return 0
	}
	
	public func goal() -> Int {
		return (self.object[Key.Goal] as! Int)
	}
	
	public func isOverride() -> Bool {
		if let override = self.object[Key.Override] as? Bool {
			return override
		}
		return false
	}
	
	public func customGoal() -> Float {
		if let customGoal = self.object[Key.CustomGoal] as? NSNumber {
			return customGoal.floatValue
		}
		return 0
	}
	
	public func avatarFile() -> PFFileObject? {
		return (self.object[Key.Avatar] as? PFFileObject)
	}
	
	public func setEmail(_ email: String) {
		(self.object as! PFUser).email = email
	}
	
	public func setFirstName(_ firstName: String) {
		self.object[Key.FirstName] = firstName
	}
	
	public func setLastName(_ lastName: String) {
		self.object[Key.LastName] = lastName
	}
	
	public func setGender(_ isFemale: Bool) {
		self.object[Key.Gender] = isFemale
	}
	
	public func setWeightInKg(_ weightInKg: Float) {
		self.object[Key.Weight] = weightInKg
	}
	
	public func setWeightInLbs(_ weightInLbs: Float) {
		let weightInKg = UnitHelper.kgFromLBS(weightInLbs)
		setWeightInKg(weightInKg)
	}
	
	public func setHeightInCm(_ heightInCm: Float) {
		self.object[Key.Height] = heightInCm
	}
	
	public func setHeightInFeetAndInch(_ feet: Int, _ inch: Int) {
		let heightInCm = UnitHelper.cmFromFeet(Float(feet)) + UnitHelper.cmFromInch(Float(inch))
		setHeightInCm(heightInCm)
	}
	
	public func setAge(_ age: Int) {
		self.object[Key.Age] = age
	}
	
	public func setLevel(_ level: Int) {
		self.object[Key.Level] = level
	}
	
	public func setGoal(_ goal: Int) {
		self.object[Key.Goal] = goal
	}
	
	public func calorieGoal() -> Float {
		if let calorieGoal = self.object[Key.CalorieGoal] as? NSNumber {
			return calorieGoal.floatValue
		}
		return 0
	}
	
	public func calorieBurned() -> Float {
		return isOverride() ? customGoal() : calorieGoal()
	}
	
	public func setCalorieGoal(_ calorieGoal: Float) {
		self.object[Key.CalorieGoal] = calorieGoal
	}
	
	public func setAvatar(_ image: UIImage) {
		let file = PFFileObject(name: "image.jpg", data: UIImageJPEGRepresentation(image, 0.5)!)
		self.object[Key.Avatar] = file
	}
	
	public func setOverride(_ override: Bool) {
		self.object[Key.Override] = override
		if !override {
			setCustomGoal(0)
		}
	}
	
	public func setCustomGoal(_ customGoal: Int) {
		self.object[Key.CustomGoal] = customGoal
	}
	
	public func paceType() -> Int {
		if let paceType = self.object[Key.PaceType] as? NSNumber {
			return paceType.intValue
		}
		return User.PACE_LOSE
	}
	
	public func setPaceType(_ paceType: Int) {
		self.object[Key.PaceType] = paceType
	}
	
	public func paceOption() -> Int {
		if let paceOption = self.object[Key.PaceOption] as? NSNumber {
			return paceOption.intValue
		}
		return User.PACE_50
	}
	
	public func setPaceOption(_ paceOption: Int) {
		self.object[Key.PaceOption] = paceOption
	}
	
	public func optimize() {
		let weight = weightInKg()
		let height = heightInCM()
		let age = Float(self.age())
		
		let bmrWeight = 10 * weight
		let bmrHeight = 6.25 * height
		let bmrAge = 5 * age
		var bmr = bmrWeight + bmrHeight - bmrAge
		if gender() {
			bmr -= 161
		}
		
		var levelValue: Float = 0
		switch level() {
		case 0:
			levelValue = 330
			break
		case 1:
			levelValue = 600
			break
		case 2:
			levelValue = 680
			break
		case 3:
			levelValue = 760
			break
		default:
			levelValue = 0
		}
		
		var goalValue: Float = 0
		if (paceType() == User.PACE_GAIN) {
			goalValue = paceOption() == User.PACE_50 ? 250 : 500
		} else if (paceType() == User.PACE_LOSE) {
			goalValue = paceOption() == User.PACE_50 ? -250 : -500
		}
		
		let goal = bmr + levelValue + goalValue
		setCalorieGoal(goal)
	}
	
	private func loadInformation() {
		BlogManager.sharedInstance.load()
		StateManager.sharedInstance.load()
		GoalManager.sharedInstance.load()
		GalleryManager.sharedInstance.load()
		ReflectionManager.sharedInstance.load()
		DietaryManager.sharedInstance.load()
	}
	
	private func clearInformation() {
		BlogManager.sharedInstance.clear()
		StateManager.sharedInstance.clear()
		GoalManager.sharedInstance.clear()
		GalleryManager.sharedInstance.clear()
		ReflectionManager.sharedInstance.clear()
		DietaryManager.sharedInstance.clear()
	}
	
	private func onCompleted(_ callback: @escaping ((_ error: Error?) -> Void), _ error: Error?) {
		if error != nil {
			runCallback(callback, error)
			return
		}
		
		DispatchQueue.global().async {
			self.object = PFUser.current()
			PFUser.enableAutomaticUser()
			self.loadInformation()
			
			self.runCallback(callback, error)
		}
	}
	
	public func autoLogin(_ callback: @escaping ((_ error: Error?) -> Void)) {
		if PFUser.current() != nil {
			PFUser.current()?.fetchInBackground(block: { (result, error) in
				self.onCompleted(callback, error)
			})
		}
	}
	
	public func login(_ username: String, _ password: String, callback: @escaping ((_ error: Error?) -> Void)) {
		PFUser.logInWithUsername(inBackground: username, password: password) { (result, error) in
			self.onCompleted(callback, error)
		}
	}
	
	public func signup(_ username: String, _ password: String, _ firstName: String, _ lastName: String, _ avatarImage: UIImage?, callback: @escaping ((_ error: Error?) -> Void)) {
		let parseUser = PFUser()
		parseUser.username = username
		parseUser.password = password
		parseUser.signUpInBackground { (success, error) in
			if error == nil {
				self.object = PFUser.current()
				
				self.setEmail(username)
				self.setFirstName(firstName)
				self.setLastName(lastName)
				if avatarImage != nil {
					self.setAvatar(avatarImage!)
				}
				
				PFUser.current()?.saveInBackground(block: { (success, error) in
					self.onCompleted(callback, error)
				})
				return
			}
			
			PFUser.logOut()
			self.runCallback(callback, error)
		}
	}
	
	public func logout() {
		PFUser.logOut()
		self.object = nil
		clearInformation()
	}
	
	public func save(_ callback: @escaping ((_ error: Error?) -> Void)) {
		self.object.saveInBackground { (success, error) in
			self.runCallback(callback, error)
		}
	}
}
