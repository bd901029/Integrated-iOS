//
//  GalleryManager.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class GalleryManager: ApiManager {
	static let sharedInstance : GalleryManager = {
		let instance = GalleryManager()
		return instance
	}()
	
	var items = [Gallery]()
	
	func clear() {
		self.items = [Gallery]()
	}
	
	public func add(_ item: Gallery, _ callback: @escaping ((_ error: Error?) -> Void)) {
		item.saveInBackground { (success, error) in
			if error == nil {
				self.items.append(item)
			}
			
			self.runCallback(callback, error)
		}
	}
	
	public func load() {
		self.clear()
		
		do {
			let query = PFQuery(className: Gallery.parseClassName())
			query.whereKey(Gallery.Key.UserId, equalTo: User.sharedInstance.userId())
			query.order(byAscending: Gallery.Key.Date)
			if let results = try query.findObjects() as? [Gallery] {
				self.items.append(contentsOf: results)
			}
		} catch let error {
			print(error)
		}
	}
	
	public func delete(_ item: Gallery, _ callback: @escaping ((_ error: Error?) -> Void)) {
		item.deleteInBackground { (success, error) in
			if error == nil {
				self.items.removeAll(where: { (temp) -> Bool in
					return temp.objectId == item.objectId
				})
			}
			
			self.runCallback(callback, error)
		}
	}
}
