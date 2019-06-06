//
//  NutritionStatisticsVC.swift
//  Integrated
//
//  Created by developer on 2019/6/2.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Charts

class NutritionStatisticsVC: UIViewController {

	@IBOutlet weak var mainChart: PieChartView!
	@IBOutlet weak var caloriesConsumedView: UILabel!
	@IBOutlet weak var caloriesBurnedView: UILabel!
	
	@IBOutlet weak var calorieBar: UIView!
	@IBOutlet weak var carbohydratesValueView: UILabel!
	@IBOutlet weak var proteinValueView: UILabel!
	@IBOutlet weak var fatValueView: UILabel!
	
	@IBOutlet weak var calorieGoalView: UILabel!
	
	@IBOutlet weak var viewPager: ViewPager!
	@IBOutlet var nutrientsButtons: [UIButton]!
	@IBOutlet var pageButtons: [CustomButton]!
	
	let vitaminView			= AnalysisVitaminView.create()
	let mineralsView		= AnalysisMineralsView.create()
	let carbohydratesView	= AnalysisCarbohydratesView.create()
	let proteinsView		= AnalysisProteinsView.create()
	let fatsView			= AnalysisFatsView.create()
	
	static func instance() -> NutritionStatisticsVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let workoutVC = storyboard.instantiateViewController(withIdentifier: "NutritionStatisticsVC") as! NutritionStatisticsVC
		return workoutVC
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.initUI()
		self.updateUI()
    }
	
	@IBAction func onBackBtnTapped(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onPageLabelBtnTapped(_ sender: UIButton) {
		let index = self.nutrientsButtons.index(of: sender)!
		self.viewPager.scrollToPage(index: index+1)
		
		for button in self.nutrientsButtons {
			button.isSelected = button == sender
		}
		
		for i in 0 ..< self.pageButtons.count {
			self.pageButtons[i].isSelected = i == index
		}
	}
	
	private func initUI() {
		self.initChart()
		
		let pageColors = [UIColor.vitamin(), UIColor.mineral(), UIColor.carbohydrate(), UIColor.protein(), UIColor.fat()]
		for i in 0 ..< self.nutrientsButtons.count {
			let button = self.nutrientsButtons[i]
			button.setTitleColor(pageColors[i], for: UIControlState.selected)
		}
		
		for i in 0 ..< self.pageButtons.count {
			let button = self.pageButtons[i]
			button.setTitleColor(pageColors[i], for: UIControlState.selected)
		}
		
		self.viewPager.dataSource = self
		self.viewPager.delegate = self
		self.viewPager.pageControl.isHidden = true
		self.viewPager.scrollToPage(index: 0)
	}
	
	private func initChart() {
		self.mainChart.usePercentValuesEnabled = true
		self.mainChart.chartDescription?.enabled = false
		self.mainChart.drawHoleEnabled = true
		self.mainChart.isUserInteractionEnabled = false
		self.mainChart.holeColor = UIColor.clear
		self.mainChart.legend.enabled = false
	}
	
	private func updateUI() {
		let dietaries = DietaryManager.sharedInstance.dietariesByDate(Date())
		
		var calories: Float = 0
		var fatsInG: Float = 0, fatsInKCal: Float = 0, carbsInG: Float = 0, carbsInKCal: Float = 0, proteinsInG: Float = 0, proteinsInKCal: Float = 0
		for dietary in dietaries {
			calories		+= dietary.caloriesInKCal()		* Float(dietary.count)
			fatsInKCal		+= dietary.fatInKCal()			* Float(dietary.count)
			carbsInKCal		+= dietary.carbohydrateInKCal() * Float(dietary.count)
			proteinsInKCal	+= dietary.proteinInKCal()		* Float(dietary.count)
			
			carbsInG		+= dietary.carbohydrateInG()	* Float(dietary.count)
			proteinsInG		+= dietary.proteinInG()			* Float(dietary.count)
			fatsInG			+= dietary.fatInG()				* Float(dietary.count)
		}
		
		let totalCalorieInKCal = fatsInKCal + carbsInKCal + proteinsInKCal
		let fatPercent = totalCalorieInKCal == 0 ? 0 : Int(fatsInKCal / totalCalorieInKCal * 100.0 + 0.5)
		let carbsPercent = totalCalorieInKCal == 0 ? 0 : Int(carbsInKCal / totalCalorieInKCal * 100.0 + 0.5)
		let proteinPercent = totalCalorieInKCal == 0 ? 0 : Int(proteinsInKCal / totalCalorieInKCal * 100.0 + 0.5)
		
		/// Main Chart
		let caloriesChartColors = [UIColor.fat(), UIColor.carbohydrate(), UIColor.protein()]
		
		var dataEntries: [ChartDataEntry] = []
		dataEntries.append(ChartDataEntry(x: 0, y: Double(fatPercent), data: ""))
		dataEntries.append(ChartDataEntry(x: 1, y: Double(carbsPercent), data: ""))
		dataEntries.append(ChartDataEntry(x: 2, y: Double(proteinPercent), data: ""))
		
		let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
		pieChartDataSet.selectionShift = 0
		pieChartDataSet.colors = caloriesChartColors
		
		let pieChartData = PieChartData(dataSet: pieChartDataSet)
		pieChartData.setValueTextColor(UIColor.clear)
		self.mainChart.data = pieChartData
		
		/// Calorie Values
		self.caloriesConsumedView.text = String(Int(calories))
		self.caloriesBurnedView.text = String(Int(User.sharedInstance.calorieBurned()))
		
		/// Line Chart
		let percentSum = carbsPercent + proteinPercent + fatPercent
		self.calorieBar.subviews[0].frame = CGRect(x: 0, y: 0,
												   width: percentSum == 0 ? 0 : self.calorieBar.frame.width * CGFloat(carbsPercent) / CGFloat(percentSum),
												   height: self.calorieBar.frame.height)
		
		self.calorieBar.subviews[1].frame = CGRect(x: self.calorieBar.subviews[0].frame.origin.x + self.calorieBar.subviews[0].frame.width, y: 0,
												   width: percentSum == 0 ? 0 : self.calorieBar.frame.width * CGFloat(carbsPercent) / CGFloat(percentSum),
												   height: self.calorieBar.frame.height)
		
		self.calorieBar.subviews[2].frame = CGRect(x: self.calorieBar.subviews[1].frame.origin.x + self.calorieBar.subviews[1].frame.width, y: 0,
												   width: percentSum == 0 ? 0 : self.calorieBar.frame.width * CGFloat(carbsPercent) / CGFloat(percentSum),
												   height: self.calorieBar.frame.height)
		
		/// Individual Values
		self.carbohydratesValueView.text = String(Int(carbsInG)) + "g"
		self.proteinValueView.text = String(Int(proteinsInG)) + "g"
		self.fatValueView.text = String(Int(fatsInG)) + "g"
		
		/// Calories View
		self.calorieGoalView.text = User.sharedInstance.isOverride() ? String(Int(User.sharedInstance.customGoal())) : String(Int(User.sharedInstance.calorieGoal()))
	}
}

extension NutritionStatisticsVC: ViewPagerDataSource, ViewPagerDelegate {
	func numberOfItems(viewPager:ViewPager) -> Int {
		return 5;
	}
	
	func viewAtIndex(viewPager: ViewPager, index: Int, view: UIView?) -> UIView {
		if index == 0 {
			return self.vitaminView!
		} else if index == 1 {
			return self.mineralsView!
		} else if index == 2 {
			return self.carbohydratesView!
		} else if index == 3 {
			return self.proteinsView!
		} else if index == 4 {
			return self.fatsView!
		}
		
		return view!
	}
	
	func viewPager(_ viewPager: ViewPager, didSelectedItem itemIndex: Int) {
		for index in 0 ..< self.nutrientsButtons.count {
			self.nutrientsButtons[index].isSelected = itemIndex == index
		}
		
		for index in 0 ..< self.pageButtons.count {
			self.pageButtons[index].isSelected = itemIndex == index
		}
	}
}
