//
//  BlogManager.swift
//  Integrated
//
//  Created by developer on 2019/5/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class BlogManager: ApiManager {
	static let sharedInstance : BlogManager = {
		let instance = BlogManager()
		return instance
	}()
	
	var blogs = [Blog]()
	
	public func clear() {
		blogs = [Blog]()
	}
	
	public func load() {
		blogs.removeAll()
		
		do {
			let query = PFQuery(className: Blog.parseClassName())
			if let results = try query.findObjects() as? [Blog] {
				for blog in results {
					blogs.append(blog)
				}
			}
		} catch let error {
			print(error)
		}
	}
	
	public func loadInBackground(_ callback: @escaping ((_ error: Error?) -> Void)) {
		blogs.removeAll()
		
		DispatchQueue.global().async {
			do {
				let query = PFQuery(className: Blog.parseClassName())
				if let results = try query.findObjects() as? [Blog] {
					for blog in results {
						self.blogs.append(blog)
					}
				}
				
				self.runCallback(callback, nil)
			} catch let error {
				self.runCallback(callback, error)
			}
		}
	}
	
	public func blogsByTags(_ tags: [String]) -> [Blog] {
		let results = self.blogs.filter { (temp) -> Bool in
			for tag in tags {
				if temp.isMatched(tag) {
					return true
				}
			}
			
			return false
		}
		return results
	}
}
