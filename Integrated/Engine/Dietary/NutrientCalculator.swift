//
//  NutrientCalculator.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class NutrientCalculator: NSObject {
	static let MAX_PERCENT = Float(100)
	
	static let CALORIES_PER_CARBO_ING = Float(4)
	static let CALORIES_PER_PROTEIN_ING = Float(4)
	static let CALORIES_PER_FAT_ING = Float(9)
	
	static func calories(_ nutrientInG: Float, _ factor: Float) -> Float {
		return nutrientInG * factor;
	}
	
	/// Vitamin
	public static func percentVA(_ value: Float) -> Float {
		return (value / Float(2333) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB1(_ value: Float) -> Float {
	return (value / Float(1.1) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB2(_ value: Float) -> Float {
		return (value / Float(1.1) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB3(_ value: Float) -> Float {
		return (value / Float(14) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB5(_ value: Float) -> Float {
		return (value / Float(5) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB6(_ value: Float) -> Float {
		return (value / Float(1.3) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVB9(_ value: Float) -> Float {
	//		return (value / 2333) * 100.))
		return Float(0)
	}
	
	public static func percentVB12(_ value: Float) -> Float {
		return (value / Float(2.4) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVC(_ value: Float) -> Float {
	return (value / Float(75) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVD(_ value: Float) -> Float {
	return (value / Float(600) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVE(_ value: Float) -> Float {
	return (value / Float(15) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentVK(_ value: Float) -> Float {
	return (value / Float(90) * MAX_PERCENT + Float(0.5))
	}
	
	/// Minerals
	public static func percentCalcium(_ value: Float) -> Float {
	return (value / Float(1000) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentCopper(_ value: Float) -> Float {
	return (value / Float(0.9) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentIron(_ value: Float) -> Float {
	return (value / Float(18) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentMagnesium(_ value: Float) -> Float {
	return (value / Float(310) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentManganese(_ value: Float) -> Float {
	return (value / Float(1.8) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentPhosphorus(_ value: Float) -> Float {
	return (value / Float(700) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentPotassium(_ value: Float) -> Float {
	return (value / Float(2600) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentSelenium(_ value: Float) -> Float {
	return (value / Float(55) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentSodium(_ value: Float) -> Float {
	return (value / Float(1500) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentZinc(_ value: Float) -> Float {
	return (value / Float(8) * MAX_PERCENT + Float(0.5))
	}
	
	/// Carbohydrates
	public static func percentFiber(_ value: Float) -> Float {
	return (value / Float(25) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentSugar(_ value: Float) -> Float {
	return (value / Float(37.5) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentStarch(_ value: Float) -> Float {
	return (value / Float(8) * MAX_PERCENT + Float(0.5))
	}
	
	/// Protein
	public static func percentProtein(_ value: Float) -> Float {
	//		return (value / 8) * 100.))
	return Float(0)
	}
	
	public static func percentCystine(_ value: Float) -> Float {
	return (value / Float(0.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentHistidine(_ value: Float) -> Float {
	return (value / Float(1) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentIsoleucine(_ value: Float) -> Float {
	return (value / Float(1.3) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentLeucine(_ value: Float) -> Float {
	return (value / Float(2.9) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentLysine(_ value: Float) -> Float {
	return (value / Float(2.6) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentMethionine(_ value: Float) -> Float {
	return (value / Float(0.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentPhenylalanine(_ value: Float) -> Float {
	return (value / Float(1.1) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentThreonine(_ value: Float) -> Float {
	return (value / Float(1.4) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentTryptophan(_ value: Float) -> Float {
	return (value / Float(0.3) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentTyrosine(_ value: Float) -> Float {
	return (value / Float(1.1) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentValine(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	/// Fats
	public static func percentFat(_ value: Float) -> Float {
	return (value / 77.4 * MAX_PERCENT + 0.5)
	}
	public static func percentMonounsaturated(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentPolyunsaturated(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentSaturated(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentTransFat(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentCholesterol(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentOmega3(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
	
	public static func percentOmega6(_ value: Float) -> Float {
	return (value / Float(1.7) * MAX_PERCENT + Float(0.5))
	}
}
