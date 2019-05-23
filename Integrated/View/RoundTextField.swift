//
//  RoundButton.swift
//  Integrated
//
//  Created by developer on 2019/5/21.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextField: UITextField {
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width - 10, height: bounds.height)
	}
}
