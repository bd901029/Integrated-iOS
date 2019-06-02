//
//  AnalysisVitamin.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class AnalysisProteinsView: UIView {

	@IBOutlet var chartContainers: [UIView]!
	var charts = [CircleProgress]()
	@IBOutlet var percentViews: [UILabel]!
	
	static func create() -> AnalysisProteinsView! {
		let view = UINib(nibName: "AnalysisProteinsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AnalysisProteinsView
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
		
		var calories: Float = 0, protein: Float = 0,
		cystine: Float = 0,
		histidine: Float = 0,
		isoleucine: Float = 0,
		leucine: Float = 0,
		lysine: Float = 0,
		methionine: Float = 0,
		phenylalanine: Float = 0,
		threonine: Float = 0,
		tryptophan: Float = 0,
		tyrosine: Float = 0,
		valine: Float = 0
		
		for dietary in dietaries {
			calories += dietary.caloriesFromNutrientsInKCal() * Float(dietary.count)
			protein += dietary.proteinInKCal() * Float(dietary.count)
			
			cystine += dietary.cystineInG() * Float(dietary.count)
			histidine += dietary.histidineInG() * Float(dietary.count)
			isoleucine += dietary.isoleucineInG() * Float(dietary.count)
			leucine += dietary.leucineInG() * Float(dietary.count)
			methionine += dietary.methionineInG() * Float(dietary.count)
			phenylalanine += dietary.phenylalanineInG() * Float(dietary.count)
			threonine += dietary.threonineInG() * Float(dietary.count)
			tryptophan += dietary.tryptophanInG() * Float(dietary.count)
			tyrosine += dietary.tyrosineInG() * Float(dietary.count)
			valine += dietary.valineInG() * Float(dietary.count)
		}
		
		let percents = [Int(NutrientCalculator.percentProtein(protein)),
			Int(NutrientCalculator.percentCystine(cystine)),
			Int(NutrientCalculator.percentHistidine(histidine)),
			Int(NutrientCalculator.percentIsoleucine(isoleucine)),
			Int(NutrientCalculator.percentLeucine(leucine)),
			Int(NutrientCalculator.percentLysine(lysine)),
			Int(NutrientCalculator.percentMethionine(methionine)),
			Int(NutrientCalculator.percentPhenylalanine(phenylalanine)),
			Int(NutrientCalculator.percentThreonine(threonine)),
			Int(NutrientCalculator.percentTryptophan(tryptophan)),
			Int(NutrientCalculator.percentTyrosine(tyrosine)),
			Int(NutrientCalculator.percentValine(valine))]
		
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
