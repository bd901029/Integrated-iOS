//
//  AnalysisVitamin.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class AnalysisVitaminView: UIView {

	@IBOutlet var chartContainers: [UIView]!
	var charts: [KNCirclePercentView] = [KNCirclePercentView]()
	@IBOutlet var percentViews: [UILabel]!
	
	static func create() -> AnalysisVitaminView! {
		let view = UINib(nibName: "AnalysisVitaminView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnalysisVitaminView
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
		var vB1: Float = 0.0, vB2: Float = 0.0, vB3: Float = 0.0, vB5: Float = 0.0, vB6: Float = 0.0, vB9: Float = 0.0, vB12: Float = 0.0, vA: Float = 0.0, vC: Float = 0.0, vD: Float = 0.0, vE: Float = 0.0, vK: Float = 0.0
		for dietary in dietaries {
			vA += dietary.vitaminAInIU() * Float(dietary.count)
			vB1 += dietary.vitaminB1InMG() * Float(dietary.count)
			vB2 += dietary.vitaminB2InMG() * Float(dietary.count)
			vB3 += dietary.vitaminB3InMG() * Float(dietary.count)
			vB5 += dietary.vitaminB5InMG() * Float(dietary.count)
			vB6 += dietary.vitaminB6InMG() * Float(dietary.count)
			vB9 += dietary.vitaminB9InAMG() * Float(dietary.count)
			vB12 += dietary.vitaminB12InAMG() * Float(dietary.count)
			vC += dietary.vitaminCInMG() * Float(dietary.count)
			vD += dietary.vitaminDInIU() * Float(dietary.count)
			vE += dietary.vitaminEInMG() * Float(dietary.count)
			vK += dietary.vitaminKInAMG() * Float(dietary.count)
		}
		
		let percents: [Int] = [Int(NutrientCalculator.percentVA(vA)),
			Int(NutrientCalculator.percentVB1(vB1)),
			Int(NutrientCalculator.percentVB2(vB2)),
			Int(NutrientCalculator.percentVB3(vB3)),
			Int(NutrientCalculator.percentVB5(vB5)),
			Int(NutrientCalculator.percentVB6(vB6)),
			Int(NutrientCalculator.percentVB9(vB9)),
			Int(NutrientCalculator.percentVB12(vB12)),
			Int(NutrientCalculator.percentVC(vC)),
			Int(NutrientCalculator.percentVD(vD)),
			Int(NutrientCalculator.percentVE(vE)),
			Int(NutrientCalculator.percentVK(vK))]
		
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
