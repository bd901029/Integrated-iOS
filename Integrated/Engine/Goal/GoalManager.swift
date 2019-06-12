//
//  GoalManager.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class GoalManager: ApiManager {
	static let sharedInstance : GoalManager = {
		let instance = GoalManager()
		return instance
	}()
	
	var goalMap = [String: [Goal]]()
	
	public func clear() {
		self.goalMap = [String: [Goal]]()
	}
	
	private func addGoal(_ goal: Goal?) {
		if (goal == nil || goal?.objectId == nil) {
			return
		}
		
		var results = self.goalMap[goal!.name] == nil ? [Goal]() : self.goalMap[goal!.name]
		
		let contains = results?.contains(where: { (temp) -> Bool in
			return temp.objectId == goal?.objectId
		})
		
		if contains! {
			return
		}
		
		results?.append(goal!)
		self.goalMap[goal!.name] = results
	}
	
	private func deleteGoal(_ goal: Goal?) {
		if (goal == nil || goal?.objectId == nil) {
			return
		}
		
		var results = self.goalMap[goal!.name] == nil ? [Goal]() : self.goalMap[goal!.name]
		results?.removeAll(where: { (temp) -> Bool in
			return temp.objectId == goal?.objectId
		})
		self.goalMap[goal!.name] = results
	}
	
	public func goalsByType(_ type: String) -> [Goal] {
		if let results = self.goalMap[type] {
			return results
		}
		
		return [Goal]()
	}
	
	public func allNames() -> [String] {
		let defaultNames = Goal.defaults()
		var results = defaultNames
		for name in self.goalMap.keys {
			if defaultNames.contains(name) {
				continue
			}
			
			results.append(name)
		}
		
		return results
	}
	
	public func goalsByName(_ name: String) -> [Goal] {
		if let results = self.goalMap[name] {
			return results
		}
		
		return [Goal]()
	}
	
	public func load() {
		self.clear()
		
		do {
			let query = PFQuery(className: Goal.parseClassName())
			query.whereKey(Goal.Key.UserId, equalTo: User.sharedInstance.userId())
			query.order(byAscending: State.Key.Date)
			if let results = try query.findObjects() as? [Goal] {
				for result in results {
					self.addGoal(result)
				}
			}
		} catch let error {
			print(error)
		}
	}
	
	public func add(_ goal: Goal, _ callback: @escaping ((_ error: Error?) -> Void)) {
		goal.saveInBackground { (success, error) in
			if error == nil {
				self.addGoal(goal)
			}
			
			self.runCallback(callback, error)
		}
	}
	
	public func save(_ goal: Goal, _ callback: @escaping ((_ error: Error?) -> Void)) {
		goal.saveInBackground { (success, error) in
			self.runCallback(callback, error)
		}
	}
	
	public func delete(_ goal: Goal) {
		self.deleteGoal(goal)
		goal.deleteInBackground()
	}
}
