//
//  YogaSection.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class YogaSection: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "YogaSection"
	}
	
	@NSManaged var title: String
	@NSManaged var subtitle: String
	@NSManaged var cover: PFFileObject
	
	class Key {
		static let Date = "createdAt"
		static let Title = "title"
		static let Subtitle = "subtitle"
		static let Cover = "cover"
	}	
}
