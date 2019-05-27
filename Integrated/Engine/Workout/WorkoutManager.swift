//
//  WorkoutManager.swift
//  Integrated
//
//  Created by developer on 2019/5/25.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class WorkoutManager: ApiManager {
	static let sharedInstance : WorkoutManager = {
		let instance = WorkoutManager()
		return instance
	}()
	
	var workouts = [Workout]()
	var excercies = [Exercise]()
	
	func load(_ callback: @escaping ((_ error: Error?) -> Void)) {
		self.workouts.removeAll()
		
		DispatchQueue.global().async {
			do {
				let query = PFQuery(className: Workout.parseClassName())
				if let results = try query.findObjects() as? [Workout] {
					self.workouts.append(contentsOf: results)
				}
			} catch let error {
				print(error)
				self.runCallback(callback, error)
				return
			}
			
			self.runCallback(callback, nil)
		}
	}
	
	func loadExercise(_ workout: Workout, _ callback: @escaping ((_ error: Error?) -> Void)) {
		self.excercies.removeAll()
		
		DispatchQueue.global().async {
			do {
				let query = PFQuery(className: Exercise.parseClassName())
				query.whereKey(Exercise.Key.WorkoutId, equalTo: workout.objectId!)
				query.order(byAscending: Exercise.Key.No)
				if let results = try query.findObjects() as? [Exercise] {
					self.excercies.append(contentsOf: results)
				}
				self.runCallback(callback, nil)
			} catch let error {
				print(error)
				self.runCallback(callback, error)
			}
		}
	}
}
