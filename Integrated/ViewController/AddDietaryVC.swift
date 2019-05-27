//
//  AddDietaryVC.swift
//  Integrated
//
//  Created by developer on 2019/5/24.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Charts

class AddDietaryVC: UIViewController {
	
	var dietary: Dietary?

	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var caloriesChart: PieChartView!
	@IBOutlet weak var fatLabelView: UILabel!
	@IBOutlet weak var fatValueView: UILabel!
	@IBOutlet weak var carbosLabelView: UILabel!
	@IBOutlet weak var carbosValueView: UILabel!
	@IBOutlet weak var proteinLabelView: UILabel!
	@IBOutlet weak var proteinValueView: UILabel!
	
	@IBOutlet weak var countView: RoundTextField!
	@IBOutlet weak var unitView: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateUI()
	}
	
	func initUI() {
		self.initCaloriesChart()
	}
	
	func initCaloriesChart() {
		caloriesChart.usePercentValuesEnabled = true
		caloriesChart.drawSlicesUnderHoleEnabled = false
		caloriesChart.holeRadiusPercent = 0.58
		caloriesChart.transparentCircleRadiusPercent = 0.61
		caloriesChart.chartDescription?.enabled = false
		caloriesChart.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
		
		caloriesChart.drawCenterTextEnabled = true
		
		let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
		paragraphStyle.lineBreakMode = .byTruncatingTail
		paragraphStyle.alignment = .center
		
		let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
		centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
								  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
		centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
								  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
		centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
								  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
		caloriesChart.centerAttributedText = centerText;
		
		caloriesChart.drawHoleEnabled = true
		caloriesChart.rotationAngle = 0
		caloriesChart.rotationEnabled = true
		caloriesChart.highlightPerTapEnabled = true
		
		let l = caloriesChart.legend
		l.horizontalAlignment = .right
		l.verticalAlignment = .top
		l.orientation = .vertical
		l.drawInside = false
		l.xEntrySpace = 7
		l.yEntrySpace = 0
		l.yOffset = 0
	}
	
	func updateUI() {
		
	}
}
