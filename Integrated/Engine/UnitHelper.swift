//
//  UnitHelper.swift
//  Integrated
//
//  Created by developer on 2019/5/19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class UnitHelper {
	public static func round(_ value: Float) -> Float {
		return Float((value * 100).rounded() / 100)
	}
	
	public static func kgFromLBS(_ lbs: Float) -> Float {
		return round(lbs * 0.45359237);
	}
	
	public static func lbsFromKG(_ kg: Float) -> Float {
		return round(kg * 2.2046226218);
	}
	
	public static func feetFromCM(_ cm: Float) -> Float {
		return round(cm * 0.03280839895);
	}
	
	public static func cmFromFeet(_ feet: Float) -> Float {
		return round(feet * 30.48);
	}
	
	public static func inchFromCM(_ cm: Float) -> Float {
		let feet = feetFromCM(cm);
		let inch = round((cm - cmFromFeet(feet)) * 0.393701);
		return inch;
	}
	
	public static func cmFromInch(_ inch: Float) -> Float {
		return round(inch * 2.54);
	}
	
	public static func cmFromFeetAndInch(_ feet: Float, _ inch: Float) -> Float {
		let cmFromFeet = UnitHelper.cmFromFeet(feet)
		let cmFromInch = UnitHelper.cmFromInch(inch)
		let cm = cmFromFeet + cmFromInch
		return cm;
	}
	
	public static func gramFromOz(_ oz: Float) -> Float {
		return oz * 28.3495;
	}
	
	public static func ozFromGram(_ gram: Float) -> Float {
		return gram * 0.035274;
	}

}
