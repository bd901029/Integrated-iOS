//
//  RoundButton.swift
//  Integrated
//
//  Created by developer on 2019/5/21.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
	
	@IBInspectable
	var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
	
	@IBInspectable
	var textAlignment:NSTextAlignment = NSTextAlignment.center {
		didSet {
			self.titleLabel?.textAlignment = self.textAlignment
		}
	}
	
	@IBInspectable
	var selectedBackgroundColor: UIColor = UIColor.clear {
		didSet {
			setBackgroundColor(color: self.selectedBackgroundColor, forState: UIControl.State.focused)
		}
	}
}

extension UIButton {
	func setBackgroundColor(color: UIColor, forState: UIControl.State) {
		self.clipsToBounds = true  // add this to maintain corner radius
		UIGraphicsBeginImageContext(CGSize(width: self.bounds.width, height: self.bounds.height))
		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.fill(CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
			let colorImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			self.setBackgroundImage(colorImage, for: forState)
		}
	}
}
