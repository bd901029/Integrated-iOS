//
//  StateManager.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class StateManager: ApiManager {
	static let sharedInstance : StateManager = {
		let instance = StateManager()
		return instance
	}()
	
	var states = [String: [State]]()
	
	public func clear() {
		self.states = [String: [State]]()
	}
	
	private func addState(_ state: State?) {
		if (state == nil || state!.objectId == nil) {
			return
		}
		
		var results = (self.states[state!.type] == nil) ? [State]() : self.states[state!.type]
		
		let contains = results?.contains(where: { (temp) -> Bool in
			return temp.objectId == state?.objectId
		})
		
		if contains! {
			return
		}
		
		results?.append(state!)
		self.states[state!.type] = results
	}
	
	public func statesByType(_ type: String) -> [State] {
		if let results = self.states[type] {
			return results
		}
		
		return [State]()
	}
	
	public func customNames() -> [String] {
		var results = [String]()
		let customStates = statesByType(State.Kind.Custom)
		for state in customStates {
			if results.contains(state.name) {
				continue
			}
			
			results.append(state.name)
		}
		
		return results
	}
	
	public func allNames() -> [String] {
		var results = State.types();
		results.remove(at: results.index(of: State.Kind.Custom)!)
		
		results.append(contentsOf: customNames())
		return results
	}
	
	public func statesByName(_ name: String) -> [State] {
		if let results = self.states[name] {
			return results
		}
		
		var results = [State]()
		let customStates = self.statesByType(State.Kind.Custom)
		for state in customStates {
			if state.name == name {
				results.append(state)
			}
		}
		
		return results
	}
	
	public func load() {
		self.clear();
		
		do {
			let query = PFQuery(className: State.parseClassName())
			query.whereKey(State.Key.UserId, equalTo: User.sharedInstance.userId())
			query.order(byAscending: State.Key.Date)
			if let results = try query.findObjects() as? [State] {
				for state in results {
					self.addState(state)
				}
			}
		} catch let error {
			print(error)
		}
	}
	
	public func add(_ state: State, _ callback: @escaping ((_ error: Error?) -> Void)) {
		state.saveInBackground { (success, error) in
			if error == nil {
				self.addState(state)
			}
			
			self.runCallback(callback, error)
		}
	}
	
	public func save(_ state: State, _ callback: @escaping ((_ error: Error?) -> Void)) {
		state.saveInBackground { (success, error) in
			self.runCallback(callback, error)
		}
	}
}
