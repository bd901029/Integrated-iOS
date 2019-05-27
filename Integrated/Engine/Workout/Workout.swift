//
//  Workout.swift
//  Integrated
//
//  Created by developer on 2019/5/25.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Workout: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Workout"
	}
	
	@NSManaged var title: String
	@NSManaged var subtitle: String
	@NSManaged var thumb: PFFileObject
	
	class Key {
		static let ClassName = "Workout";
		static let Title = "title";
		static let Subtitle = "subtitle";
		static let Thumb = "thumb";
	}
}
