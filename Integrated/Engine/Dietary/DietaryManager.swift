//
//  DietaryManager.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class DietaryManager: ApiManager {
	static let sharedInstance : DietaryManager = {
		let instance = DietaryManager()
		return instance
	}()
	
	let NUTRITIONIX_ID = "2b7eb7fc"
	let NUTRITIONIX_KEY = "7ff2633984803ffd3e48b0e4ff03ab88"
	
	func searchByName(_ name: String?, _ callback: @escaping ((_ results: [Any]?, _ error: Error?) -> Void)) {
		if name == nil || name == "" {
			self.runCallback(callback, [Any](), nil)
			return
		}
		
		let url = "https://trackapi.nutritionix.com/v2/search/instant"
		let params: [String: Any] = ["query": name!, "branded": true, "detailed": true]
		let header: HTTPHeaders = ["Content-Type": "application/json", "x-app-id": NUTRITIONIX_ID, "x-app-key": NUTRITIONIX_KEY]
		let request = Alamofire.request(url, method: HTTPMethod.post, parameters: params, headers: header)
		request.responseJSON { (response) in
			guard response.result.isSuccess, let jsonInfo = response.result.value as? [String: Any] else {
				print("Error while fetching colors: \(String(describing: response.result.error))")
				self.runCallback(callback, nil, response.result.error)
				return
			}
			
			guard let branded = jsonInfo["branded"] as? [[String: Any]] else {
				self.runCallback(callback, nil, nil)
				return
			}
			
			var results = [Dietary]()
			for brand in branded {
				results.append(Dietary.create(brand))
			}
			
			self.runCallback(callback, results, nil)
		}
	}
	
	func searchByBarcode(_ barcode: String?, _ callback: @escaping ((_ results: [Any]?, _ error: Error?) -> Void)) {
		if barcode == nil || barcode == "" {
			self.runCallback(callback, [Any](), nil)
			return
		}
		
		let url = "https://trackapi.nutritionix.com/v2/search/item?upc=" + barcode!
//		let params: [String: Any] = ["upc": (barcode! as NSString).intValue]
		let header: HTTPHeaders = ["Content-Type": "application/json",
								   "x-app-id": NUTRITIONIX_ID,
								   "x-app-key": NUTRITIONIX_KEY]
		let request = Alamofire.request(url, method: HTTPMethod.get, headers: header)
		request.responseJSON { (response) in
			guard response.result.isSuccess, let jsonInfo = response.result.value as? [String: Any] else {
				print("Error while fetching colors: \(String(describing: response.result.error))")
				self.runCallback(callback, nil, response.result.error)
				return
			}
			
			guard let foods = jsonInfo["foods"] as? [[String: Any]] else {
				self.runCallback(callback, nil, nil)
				return
			}
			
			var results = [Dietary]()
			for food in foods {
				results.append(Dietary.create(food))
			}
			
			self.runCallback(callback, results, nil)
		}
	}
	
	func fetchInformation(_ nixId: String?, _ callback: @escaping ((_ results: [Any]?, _ error: Error?) -> Void)) {
		if nixId == nil || nixId == "" {
			self.runCallback(callback, [Any](), nil)
			return
		}
		
		let url = "https://trackapi.nutritionix.com/v2/search/item?nix_item_id=" + nixId!
		let header: HTTPHeaders = ["Content-Type": "application/json", "x-app-id": NUTRITIONIX_ID, "x-app-key": NUTRITIONIX_KEY]
		let request = Alamofire.request(url, method: HTTPMethod.get, headers: header)
		request.responseJSON { (response) in
			guard response.result.isSuccess, let jsonInfo = response.result.value as? [String: Any] else {
				print("Error while fetching colors: \(String(describing: response.result.error))")
				self.runCallback(callback, nil, response.result.error)
				return
			}
			
			guard let foods = jsonInfo["foods"] as? [[String: Any]] else {
				self.runCallback(callback, nil, nil)
				return
			}
			
			var results = [Dietary]()
			for food in foods {
				results.append(Dietary.create(food))
				break
			}
			
			self.runCallback(callback, results, nil)
		}
	}
	
	var dietaries = [Dietary]()
	func clear() {
		self.dietaries = [Dietary]()
	}
	
	func add(_ dietary: Dietary) {
		for temp in dietaries {
			if temp.nixId != dietary.nixId {
				continue
			}
			
			if temp.date.timeIntervalSince1970 == dietary.date.timeIntervalSince1970 {
				temp.setCount(dietary.count)
				return
			}
		}
		
		dietaries.append(dietary)
	}
	
	func dietariesByDate(_ date: Date?) -> [Dietary] {
		if date == nil {
			return [Dietary]()
		}
		
		var results = [Dietary]()
		for dietary in dietaries {
			if DateHelper.isSameDay(date, dietary.date) {
				results.append(dietary)
			}
		}
		
		return results
	}
	
	func caloriesConsumed() -> Float {
		return self.caloriesConsumed(Date())
	}
	
	func caloriesConsumed(_ date: Date?) -> Float {
		if date == nil {
//			date = Date()
			return 0
		}
		
		let dietariesByDate = self.dietariesByDate(date)
		var calorieConsumed: Float = 0
		for dietary in dietariesByDate {
			calorieConsumed += dietary.caloriesInKCal() * Float(dietary.count)
		}
		
		return calorieConsumed
	}
	
	func load() {
		do {
			self.clear()
			
			let query = PFQuery(className: Dietary.parseClassName())
			query.whereKey(Dietary.Key.UserId, equalTo: User.sharedInstance.userId())
			query.order(byAscending: State.Key.Date)
			if let results = try query.findObjects() as? [Dietary] {
				for dietary in results {
					self.dietaries.append(dietary)
				}
			}
		} catch let error {
			print(error)
		}
	}
	
	func add(_ dietary: Dietary, _ callback: @escaping ((_ error: Error?) -> Void)) {
		dietary.saveInBackground { (success, error) in
			if error == nil {
				self.add(dietary)
			}
			
			self.runCallback(callback, error)
		}
	}
	
	func delete(_ dietary: Dietary, _ callback: @escaping ((_ error: Error?) -> Void)) {
		dietary.deleteInBackground { (success, error) in
			if error == nil {
				if let index = self.dietaries.index(of: dietary) {
					self.dietaries.remove(at: index)
				}
			}
			
			self.runCallback(callback, error)
		}
	}
}
