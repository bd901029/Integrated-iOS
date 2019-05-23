//
//  Goal.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Goal: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Goal"
	}
	
	@NSManaged var userId: String
	@NSManaged var name: String
	@NSManaged var value: Float
	@NSManaged var goal: Int
	
	class Key {
		static let UserId = "userId"
		static let Name = "name"
		static let Value = "value"
		static let Goal = "goal"
	}
	
	class Default {
		static let Bench = "Bench"
		static let Deadlift = "Deadlift"
		static let BentOverRow = "Bent Over Row"
		static let DistanceRun = "Distance Run"
		static let Custom = "Custom"
	}
	
	public static func create() -> Goal {
		let goal = Goal()
		goal.setUserId(User.sharedInstance.userId())
		return goal
	}
	
	public static func defaults() -> [String] {
		var defaults = [String]()
		defaults.append(Default.Bench)
		defaults.append(Default.Deadlift);
		defaults.append(Default.BentOverRow);
		defaults.append(Default.DistanceRun);
		return defaults
	}
	
	public static func color(_ name: String) -> UIColor {
		if name == Default.Bench {
			return UIColor.rgb(0, 153, 0);
		}
		
		if name == Default.Deadlift {
			return UIColor.rgb(102, 51, 204);
		}
		
		if name == Default.BentOverRow {
			return UIColor.rgb(153, 0, 0);
		}
		
		if name == Default.DistanceRun {
			return UIColor.rgb(51, 51, 204);
		}
		
		return UIColor.random()
	}
	
	public func setUserId(_ userId: String) {
		self.userId = userId
	}
	
	public func setName(_ name: String) {
		self.name = name
	}
	
	public func setValue(_ value: Float) {
		self.value = value
	}
	
	public func setGoal(_ value: Int) {
		self.goal = value
	}
	
	public func date() -> Date {
		return createdAt!
	}
}
