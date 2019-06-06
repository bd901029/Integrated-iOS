//
//  AnalysisVitamin.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class AnalysisFatsView: UIView {

	@IBOutlet var chartContainers: [UIView]!
	var charts: [KNCirclePercentView] = [KNCirclePercentView]()
	@IBOutlet var percentViews: [UILabel]!
	
	static func create() -> AnalysisFatsView! {
		let view = UINib(nibName: "AnalysisFatsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnalysisFatsView
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
		
		var calories: Float = 0, fatInKCal: Float = 0,
		monounsaturated: Float = 0,
		polyunsaturated: Float = 0,
		saturated: Float = 0,
		transFat: Float = 0,
		cholesterol: Float = 0,
		omega3: Float = 0,
		omega6: Float = 0;
		for dietary in dietaries {
			calories += dietary.caloriesFromNutrientsInKCal() * Float(dietary.count)
			fatInKCal += dietary.fatInKCal() * Float(dietary.count)
			
			monounsaturated += dietary.monounsaturatedInG() * Float(dietary.count)
			polyunsaturated += dietary.polyunsaturatedInG() * Float(dietary.count)
			saturated += dietary.saturatedInG() * Float(dietary.count)
			transFat += dietary.transFatInG() * Float(dietary.count)
			omega3 += dietary.omega3InG() * Float(dietary.count)
			omega6 += dietary.omega6() * Float(dietary.count)
		}
		
		let percents = [Int(NutrientCalculator.percentFat(fatInKCal)),
			Int(NutrientCalculator.percentMonounsaturated(monounsaturated)),
			Int(NutrientCalculator.percentPolyunsaturated(polyunsaturated)),
			Int(NutrientCalculator.percentSaturated(saturated)),
			Int(NutrientCalculator.percentTransFat(transFat)),
			Int(NutrientCalculator.percentCholesterol(cholesterol)),
			Int(NutrientCalculator.percentOmega3(omega3)),
			Int(NutrientCalculator.percentOmega6(omega6))]
		
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
