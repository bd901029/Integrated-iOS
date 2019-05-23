//
//  Reflection.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Reflection: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Reflection"
	}
	
	@NSManaged var date: Date
	@NSManaged var userId: String
	@NSManaged var text: String
	
	class Key {
		static let Date = "date"
		static let UserId = "userId"
		static let Text = "text"
	}
	
	static func create() -> Reflection {
		let reflection = Reflection()
		reflection.setUserId(User.sharedInstance.userId())
		return reflection
	}
	
	public func setUserId(_ userId: String) {
		self.userId = userId
	}
	
	public func setText(_ text: String) {
		self.text = text
	}
	
	public func setDate(_ date: Date) {
		self.date = date
	}
}
