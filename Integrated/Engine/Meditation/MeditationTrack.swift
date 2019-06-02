//
//  MeditationTrack.swift
//  Integrated
//
//  Created by developer on 2019/5/31.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class MeditationTrack: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "MeditationTrack"
	}
	
	@NSManaged var sectionId: String
	@NSManaged var title: String
	@NSManaged var duration: Int
	@NSManaged var audio: PFFileObject
	
	class Key {
		static let Date = "createdAt"
		static let SectionId = "sectionId"
		static let Title = "title"
		static let Duration = "duration"
		static let Audio = "audio"
	}
	
	func localFileURL() -> URL {
		let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(self.objectId! + ".mp3")
		return url
	}
}
