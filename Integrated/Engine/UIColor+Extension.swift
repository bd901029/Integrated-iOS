//
//  UIColor+Extension.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
	static func rgb(_ rgbValue: UInt) -> UIColor {
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	static func rgb(_ red: Int, _ green: Int, _ blue: Int) -> UIColor {
		return UIColor(
			red: CGFloat(red) / 255.0,
			green: CGFloat(green) / 255.0,
			blue: CGFloat(blue) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	public static var random: UIColor {
		let r = Int(arc4random_uniform(255))
		let g = Int(arc4random_uniform(255))
		let b = Int(arc4random_uniform(255))
		return UIColor.rgb(r, g, b)
	}
	
	static func primary() -> UIColor {
		return UIColor.rgb(0x333333)
	}
	
	static func nutrition() -> UIColor {
		return UIColor.rgb(0x1f4d2b)
	}
	
	static func physical() -> UIColor {
		return UIColor.rgb(0x991919)
	}
	
	static func mental() -> UIColor {
		return UIColor.rgb(0x55266f)
	}
	
	static func survey() -> UIColor {
		return UIColor.rgb(0x9900ff)
	}
	
	static func vitamin() -> UIColor {
		return UIColor.rgb(0x0741df)
	}
	
	static func mineral() -> UIColor {
		return UIColor.rgb(0xec7616)
	}
	
	static func carbohydrate() -> UIColor {
		return UIColor.rgb(0x339933)
	}
	
	static func protein() -> UIColor {
		return UIColor.rgb(0xdf0f0f)
	}
	
	static func fat() -> UIColor {
		return UIColor.rgb(0xa120e6)
	}
	
	static func notFull() -> UIColor {
		return UIColor.rgb(0x00a651)
	}
	
	static func full() -> UIColor {
		return UIColor.rgb(0xed1c24)
	}
}
