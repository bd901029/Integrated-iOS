//
//  ReflectionManager.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class ReflectionManager: ApiManager {
	static let sharedInstance : ReflectionManager = {
		let instance = ReflectionManager()
		return instance
	}()
	
	var reflections = [Reflection]()
	
	public func clear() {
		self.reflections = [Reflection]()
	}
	
	private func addReflection(_ reflection: Reflection?) {
		if (reflection == nil || reflection?.objectId == nil) {
			return
		}
		
		let contains = self.reflections.contains { (temp) -> Bool in
			return temp.objectId == reflection?.objectId
		}
		
		if contains {
			return
		}
		
		self.reflections.append(reflection!)
	}
	
	public func reflectionByDate(_ date: Date?) -> Reflection? {
		if date == nil {
			return nil
		}
		
		for reflection in self.reflections {
			if DateHelper.isSameDay(date, reflection.date) {
				return reflection
			}
		}
		
		return nil
	}
	
	public func load() {
		self.clear()
		
		do {
			let query = PFQuery(className: Reflection.parseClassName())
			query.whereKey(Reflection.Key.UserId, equalTo: User.sharedInstance.userId())
			query.order(byAscending: Reflection.Key.Date)
			if let results = try query.findObjects() as? [Reflection] {
				self.reflections.append(contentsOf: results)
			}
		} catch let error {
			print(error)
		}
	}
	
	public func save(_ reflection: Reflection, _ callback: @escaping ((_ error: Error?) -> Void)) {
		reflection.saveInBackground { (success, error) in
			if error == nil {
				self.addReflection(reflection)
			}
			self.runCallback(callback, error)
		}
	}
}
