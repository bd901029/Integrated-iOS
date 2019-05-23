//
//  State.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class State: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "State"
	}
	
	@NSManaged var userId: String
	@NSManaged var type: String
	@NSManaged var name: String
	@NSManaged var minValue: Int
	@NSManaged var maxValue: Int
	
	class Key {
		static let UserId = "userId"
		static let Kind = "type"
		static let Name = "name"
		static let MinValue = "minValue"
		static let MaxValue = "maxValue"
		static let Date = "createdAt"
	}
	
	class Kind {
		static let Weight = "Weight"
		static let RestingHeartRate = "Resting Heart Rate"
		static let BloodPressure = "Blood Pressure"
		static let BicepsMeasurement = "Biceps Measurement"
		static let QuadMeasurement = "Quad Measurement"
		static let AbdomenMeasurement = "Abdomen Measurement"
		static let Custom = "Custom"
	}
	
	static func create() -> State {
		let state = State()
		state.setUserId(User.sharedInstance.userId())
		return state
	}
	
	static func create(_ type: String, _ value: Int) -> State {
		let state = State()
		state.setUserId(User.sharedInstance.userId())
		state.setType(type)
		state.setValue(value)
		return state;
	}
	
	public static func create(_ type: String, _ minValue: Int, _ maxValue: Int) -> State {
		let state = State()
		state.setUserId(User.sharedInstance.userId())
		state.setType(type)
		state.setMinValue(minValue)
		state.setMaxValue(maxValue)
		return state
	}
	
	static func types() -> [String] {
		var stateTypes = [String]()
		stateTypes.append(State.Kind.Weight)
		stateTypes.append(State.Kind.RestingHeartRate)
		stateTypes.append(State.Kind.BloodPressure)
		stateTypes.append(State.Kind.BicepsMeasurement)
		stateTypes.append(State.Kind.QuadMeasurement)
		stateTypes.append(State.Kind.AbdomenMeasurement)
		stateTypes.append(State.Kind.Custom)
		return stateTypes
	}
	
	public static func color(_ name: String) -> UIColor {
		if name == Kind.Weight {
			return UIColor.rgb(0, 153, 0)
		}
		
		if name == Kind.RestingHeartRate {
			return UIColor.rgb(102, 51, 204)
		}
		
		if name == Kind.BloodPressure {
			return UIColor.rgb(153, 0, 0)
		}
		
		if name == Kind.QuadMeasurement {
			return UIColor.rgb(51, 51, 204)
		}
		
		return UIColor.random()
	}
	
	public func isCustom() -> Bool {
		return self.type == Kind.Custom
	}
	
	public func setUserId(_ userId: String) {
		self.userId = userId
	}
	
	public func setType(_ type: String) {
		self.type = type
	}
	
	public func setName(_ name: String) {
		self.name = name
	}
	
	public func valueInLBS() -> Int {
		return Int(UnitHelper.lbsFromKG(Float(self.minValue)))
	}
	
	public func setValue(_ value: Int) {
		setMinValue(value);
		setMaxValue(value);
	}
	
	public func setMinValue(_ value: Int) {
		self.minValue = Int(value)
	}
	
	public func setMaxValue(_ value: Int) {
		self.maxValue = Int(value)
	}
	
	public func date() -> Date {
		return self.createdAt!
	}
}
