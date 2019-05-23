//
//  Blog.swift
//  Integrated
//
//  Created by developer on 2019/5/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Blog: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Blog"
	}
	
	@NSManaged var title: String
	@NSManaged var comment: String
	@NSManaged var kind: String
	@NSManaged var link: String
	@NSManaged var image: PFFileObject
	@NSManaged var thumb: PFFileObject
	@NSManaged var tags: String
	
	class Key {
		static let Title = "title"
		static let Comment = "comment"
		static let Kind = "kind"
		static let Link = "link"
		static let Image = "image"
		static let Thumb = "thumb"
		static let Tags = "tags"
	}
	
	class Kind {
		static let Image = "Thumb"
		static let Link = "Link"
		static let Video = "Video"
	}
	
	public func isMatched(_ tag: String) -> Bool {
		let arrTag = self.tags.components(separatedBy: ",")
		for temp in arrTag {
			if temp == tag {
				return true
			}
		}
		
		return false
	}
	
	public func getDateText() -> String {
		if updatedAt == nil {
			return ""
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		return dateFormatter.string(from: updatedAt!)
	}
}
