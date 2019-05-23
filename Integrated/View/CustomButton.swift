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
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
		}
	}
}
