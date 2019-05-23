//
//  Gallery.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Gallery: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Gallery"
	}
	
	@NSManaged var userId: String
	@NSManaged var image: PFFileObject
	@NSManaged var weightInKg: Float
	
	class Key {
		static let UserId = "userId"
		static let Image = "image"
		static let Weight = "weightInKg"
		static let Date = "createdAt"
	}
	
	static func create(_ image: UIImage, _ weightInKG: Float) -> Gallery {
		let gallery = Gallery()
		gallery.setUserId(User.sharedInstance.userId())
		gallery.setImage(image)
		gallery.setWeightInKG(weightInKG)
		return gallery
	}
	
	public func setUserId(_ userId: String) {
		self.userId = userId
	}
	
	public func setImage(_ image: UIImage) {
		let file = PFFileObject(name: "image.jpg", data: image.jpegData(compressionQuality: 0.5)!)
		self.image = file!
	}
	
	public func weightInKG() -> Float {
		return self.weightInKg
	}
	
	public func weightInLbs() -> Float {
		return UnitHelper.lbsFromKG(weightInKG());
	}
	
	public func setWeightInKG(_ weightInKG: Float) {
		self.weightInKg = weightInKG
	}
	
	public func date() -> Date? {
		return self.createdAt
	}
}
