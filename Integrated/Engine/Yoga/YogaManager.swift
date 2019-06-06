//
//  YogaManager.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class YogaManager: ApiManager {
	static let sharedInstance : YogaManager = {
		let instance = YogaManager()
		return instance
	}()
	
	var sections = [YogaSection]()
	var items = [YogaItem]()
	
	public func load(_ callback: @escaping ((_ error: Error?) -> Void)) {
		self.sections.removeAll()
		
		let query = PFQuery(className: YogaSection.parseClassName())
		query.order(byAscending: YogaSection.Key.Date)
		query.findObjectsInBackground { (results, error) in
			if let results = results as? [YogaSection] {
				self.sections.append(contentsOf: results)
			}
			
			self.runCallback(callback, error)
		}
	}
	
	public func loadExercise(_ section: YogaSection, _ callback: @escaping ((_ error: Error?) -> Void)) {
		self.items.removeAll()
		
		let query = PFQuery(className: YogaItem.parseClassName())
		query.whereKey(YogaItem.Key.SectionId, equalTo: section.objectId!)
		query.order(byAscending: YogaItem.Key.No)
		query.findObjectsInBackground { (results, error) in
			if let results = results as? [YogaItem] {
				self.items.append(contentsOf: results)
			}
			self.runCallback(callback, error)
		}
	}
}
