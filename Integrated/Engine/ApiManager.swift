//
//  ApiManager.swift
//  Integrated
//
//  Created by developer on 2019/5/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class ApiManager: NSObject {
	public func runCallback(_ callback: @escaping ((_ error: Error?) -> Void), _ error: Error?) {
		DispatchQueue.main.async {
			callback(error)
		}
	}
	
	public func runCallback(_ callback: @escaping ((_ results: [Any]?, _ error: Error?) -> Void), _ results: [Any]?, _ error: Error?) {
		DispatchQueue.main.async {
			callback(results == nil ? [Any]() : results!, error)
		}
	}
}
