//
//  MeditationSection.swift
//  Integrated
//
//  Created by developer on 2019/5/31.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class MeditationSection: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "MeditationSection"
	}
	
	@NSManaged var title: String
	@NSManaged var comment: String
	@NSManaged var coverImage: PFFileObject
	
	class Key {
		static let Date = "createdAt"
		static let Title = "title"
		static let Comment = "comment"
		static let Cover = "coverImage"
	}
	
	func date() -> Date {
		return self.createdAt!
	}
}
