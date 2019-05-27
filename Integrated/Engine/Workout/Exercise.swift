//
//  Exercise.swift
//  Integrated
//
//  Created by developer on 2019/5/25.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Exercise: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Exercise"
	}
	
	@NSManaged var workoutId: String
	@NSManaged var no: Int
	@NSManaged var title: String
	@NSManaged var subtitle: String
	@NSManaged var thumb: PFFileObject
	@NSManaged var video: PFFileObject
	@NSManaged var durationInSec: Int
	
	class Key {
		static let WorkoutId = "workoutId"
		static let No = "no"
		static let Title = "title"
		static let Subtitle = "subtitle"
		static let Thumb = "thumb"
		static let Video = "video"
		static let DurationInSec = "durationInSec"
	}
}
