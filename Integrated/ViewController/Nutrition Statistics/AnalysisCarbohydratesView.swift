//
//  AnalysisVitamin.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class AnalysisCarbohydratesView: UIView {

	@IBOutlet var chartContainers: [UIView]!
	var charts = [CircleProgress]()
	@IBOutlet var percentViews: [UILabel]!
	
	static func create() -> AnalysisCarbohydratesView! {
		let view = UINib(nibName: "AnalysisCarbohydratesView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnalysisCarbohydratesView
		return view
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		self.initUI()
		self.updateUI()
	}
	
	func initUI() {
		for container in self.chartContainers {
			let chart = CircleProgress(rectframe: container.bounds, type: CircleProgressType.Closed)
			chart.backgroundColor = UIColor.clear
			chart.fillColor = UIColor(red: 16/255, green: 119/255, blue: 234/255, alpha: 1.0)
			chart.strokeColor = UIColor(red:16/255, green: 119/255, blue: 234/255, alpha: 1.0)
			chart.radiusPercent = 0.45
			chart.loadIndicator()
			container.addSubview(chart)
			self.charts.append(chart)
		}
	}
	
	func updateUI() {
		let dietaries = DietaryManager.sharedInstance.dietariesByDate(Date())
		
		var calories: Float = 0, carbohydrate: Float = 0, fiber: Float = 0, sugar: Float = 0, starch: Float = 0
		for  dietary in dietaries {
			calories += dietary.caloriesFromNutrientsInKCal() * Float(dietary.count)
			carbohydrate += dietary.carbohydrateInKCal() * Float(dietary.count)
			
			fiber += dietary.fiberInG() * Float(dietary.count)
			sugar += dietary.sugarInG() * Float(dietary.count)
			starch += dietary.starchInG() * Float(dietary.count)
		}
		
		let percents = [calories == 0 ? 0 : Int(carbohydrate / calories * 100.0 + 0.5),
			Int(NutrientCalculator.percentFiber(fiber)),
			Int(NutrientCalculator.percentSugar(sugar)),
			Int(NutrientCalculator.percentStarch(starch))]
		
		for i in 0 ..< percents.count {
			let percent = percents[i]
			let chart = self.charts[i]
			
			if (percent < Int(NutrientCalculator.MAX_PERCENT)) {
				chart.strokeColor = UIColor.notFull()
				chart.updateWithTotalBytes(bytes: 100.0, downloadedBytes: CGFloat(percent))
			} else {
				chart.strokeColor = UIColor.full()
				chart.updateWithTotalBytes(bytes: CGFloat(percent), downloadedBytes: CGFloat(percent))
			}
			
			let percentView = self.percentViews[i]
			percentView.text = String(percent) + "%"
		}
	}
}
