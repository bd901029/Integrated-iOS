//
//  AnalysisVitamin.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class AnalysisMineralsView: UIView {
	
	@IBOutlet var chartContainers: [UIView]!
	var charts: [KNCirclePercentView] = [KNCirclePercentView]()
	@IBOutlet var percentViews: [UILabel]!

	static func create() -> AnalysisMineralsView! {
		let view = UINib(nibName: "AnalysisMineralsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnalysisMineralsView
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.initUI()
		self.updateUI()
	}
	
	func initUI() {
		let strokeColor = UIColor(red:16/255, green: 119/255, blue: 234/255, alpha: 1.0)
		for container in self.chartContainers {
			let chart = KNCirclePercentView(frame: container.bounds)
			chart.fillColor = UIColor.clear
			chart.strokeColor = strokeColor
			chart.percentLabel.isHidden = true
			container.addSubview(chart)
			self.charts.append(chart)
		}
	}
	
	func updateUI() {
		let dietaries = DietaryManager.sharedInstance.dietariesByDate(Date())
		var calcium: Float = 0, copper: Float = 0, iron: Float = 0, magnesium: Float = 0, manganese: Float = 0, phosphorus: Float = 0, potassium: Float = 0, selenium: Float = 0, sodium: Float = 0, zinc: Float = 0
		for dietary in dietaries {
			calcium		+= dietary.calciumInMG()	* Float(dietary.count)
			copper		+= dietary.copperInMG()		* Float(dietary.count)
			iron		+= dietary.ironInMG()		* Float(dietary.count)
			magnesium	+= dietary.magnesiumInMG()	* Float(dietary.count)
			manganese	+= dietary.manganeseInMG()	* Float(dietary.count)
			potassium	+= dietary.potassiumInMG()	* Float(dietary.count)
			selenium	+= dietary.seleniumInAMG()	* Float(dietary.count)
			sodium		+= dietary.sodiumInMG()		* Float(dietary.count)
			zinc		+= dietary.zincInMG()		* Float(dietary.count)
		}
		
		let percents: [Int] = [Int(NutrientCalculator.percentCalcium(calcium)),
			Int(NutrientCalculator.percentCopper(copper)),
			Int(NutrientCalculator.percentIron(iron)),
			Int(NutrientCalculator.percentMagnesium(magnesium)),
			Int(NutrientCalculator.percentManganese(manganese)),
			Int(NutrientCalculator.percentPhosphorus(phosphorus)),
			Int(NutrientCalculator.percentPotassium(potassium)),
			Int(NutrientCalculator.percentSelenium(selenium)),
			Int(NutrientCalculator.percentSodium(sodium)),
			Int(NutrientCalculator.percentZinc(zinc))]
		
		for i in 0 ..< percents.count {
			let percent = percents[i]
			let chart = self.charts[i]
			
			if (percent < Int(NutrientCalculator.MAX_PERCENT)) {
				chart.strokeColor = UIColor.notFull()
				chart.updatePercent(CGFloat(percent))
			} else {
				chart.strokeColor = UIColor.full()
				chart.updatePercent(CGFloat(percent))
			}
			
			let percentView = self.percentViews[i]
			percentView.text = String(percent) + "%"
		}
	}
}
