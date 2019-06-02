//
//  AddDietaryVC.swift
//  Integrated
//
//  Created by developer on 2019/5/24.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Charts

protocol AddDietaryVCDelegate {
	func addDietaryCompleted(_ vc: AddDietaryVC)
}

class AddDietaryVC: UIViewController {
	
	var dietary: Dietary?
	var selectedDate: Date?
	var delegate: AddDietaryVCDelegate? = nil

	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var caloriesChart: PieChartView!
	@IBOutlet weak var caloriesValueView: UILabel!
	@IBOutlet weak var fatLabelView: UILabel!
	@IBOutlet weak var fatValueView: UILabel!
	@IBOutlet weak var carbosLabelView: UILabel!
	@IBOutlet weak var carbosValueView: UILabel!
	@IBOutlet weak var proteinLabelView: UILabel!
	@IBOutlet weak var proteinValueView: UILabel!
	
	@IBOutlet weak var countView: RoundTextField!
	@IBOutlet weak var unitView: UILabel!
	@IBOutlet weak var btnAdd: CustomButton!
	
	var selectedUnitIndex: Int = 0 {
		didSet {
			self.unitView.text = Dietary.units[self.selectedUnitIndex]
		}
	}
	
	static func instance(_ dietary: Dietary?) -> AddDietaryVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "AddDietaryVC") as! AddDietaryVC
		vc.modalPresentationStyle = .overCurrentContext
		vc.dietary = dietary
		return vc
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateUI()
	}
	
	@IBAction func onUnitViewTapped(_ sender: UITapGestureRecognizer) {
		self.showUnitSelectionAlert()
	}
	
	@IBAction func onAddBtnTapped(_ sender: UIButton) {
		let strCount = countView.text
		if strCount == nil || !strCount!.isNumeric() || Float(strCount!)! <= 0 {
			Helper.showErrorAlert(target: self, message: "Please input correct information.")
			return
		}
		
		let count = Float(strCount!)!
		if self.dietary!.isGorOZ() {
			if self.dietary!.isG() {
				self.dietary!.setCount((selectedUnitIndex == 0) ? Int(count) : Int(UnitHelper.gramFromOz(count)))
			} else {
				self.dietary!.setCount((selectedUnitIndex == 1) ? Int(count) : Int(UnitHelper.ozFromGram(count)))
			}
		} else {
			self.dietary!.setCount(Int(count))
		}
		
		if !self.dietary!.hasBeenSaved() {
			self.dietary?.setUserId(User.sharedInstance.userId())
			self.dietary?.setDate((self.selectedDate == nil) ? Date() : self.selectedDate!)
		}
		
		Helper.showLoading(target: self)
		DietaryManager.sharedInstance.add(self.dietary!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.delegate?.addDietaryCompleted(self)
			
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func onCancelBtnTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc func onCountViewTextChanged(_ sender: UITextField) {
		self.updateUI()
	}
	
	func initUI() {
		self.initCaloriesChart()
		
		self.countView.addTarget(self, action: #selector(onCountViewTextChanged(_:)), for: UIControlEvents.editingChanged)
		
		self.nameView.text = self.dietary?.name()
		if self.dietary!.count > 0 {
			self.countView.text = String(self.dietary!.count)
		}
		self.unitView.text = self.dietary?.unit
		self.unitView.isUserInteractionEnabled = self.dietary!.isGorOZ()
		
		if self.dietary!.hasBeenSaved() {
			self.btnAdd.setTitle("Save", for: UIControlState.normal)
		}
	}
	
	func initCaloriesChart() {
		caloriesChart.usePercentValuesEnabled = true
		caloriesChart.chartDescription?.enabled = false
		caloriesChart.drawHoleEnabled = true
		caloriesChart.isUserInteractionEnabled = false
		caloriesChart.holeColor = UIColor.clear
		caloriesChart.legend.enabled = false
	}
	
	func updateUI() {
		if self.dietary == nil {
			return
		}
		
		var count: Int = 1
		let strCount = countView.text ?? "1"
		if strCount.isNumeric() {
			count = Int(strCount)!
		}
		
		if self.dietary!.isG() && self.selectedUnitIndex == 1 {
			count = Int(UnitHelper.gramFromOz(Float(count)) + 0.5)
		}
		
		if self.dietary!.isOZ() && self.selectedUnitIndex == 0 {
			count = Int(UnitHelper.ozFromGram(Float(count)) + 0.5)
		}
		
		caloriesValueView.text = String(format: "%.1f", dietary!.caloriesInKCal() * Float(count))
		fatValueView.text = String(format: "%.1fg", dietary!.fatInG() * Float(count))
		carbosValueView.text = String(format: "%.1fg", dietary!.carbohydrateInG() * Float(count))
		proteinValueView.text = String(format: "%.1fg", dietary!.proteinInG() * Float(count))
		
		let carboCalories = NutrientCalculator.calories(dietary!.carbohydrateInG(), NutrientCalculator.CALORIES_PER_CARBO_ING)
		let proteinCalories = NutrientCalculator.calories(dietary!.proteinInG(), NutrientCalculator.CALORIES_PER_PROTEIN_ING)
		let fatCalories = NutrientCalculator.calories(dietary!.fatInG(), NutrientCalculator.CALORIES_PER_FAT_ING)
		
		let totalCalories = carboCalories + proteinCalories + fatCalories
		let fatPercent = Int(fatCalories / totalCalories * 100.0 + 0.5)
		let carbosPercent = Int(carboCalories / totalCalories * 100.0 + 0.5)
		let proteinPercent = Int(proteinCalories / totalCalories * 100.0 + 0.5)
		
		fatLabelView.text		= String(format: "Fat (%d%) - ", fatPercent)
		carbosLabelView.text	= String(format: "Carbs (%d%) - ", carbosPercent)
		proteinLabelView.text	= String(format: "Protein (%d%) - ", proteinPercent)
		
		fatLabelView.text		= "Fat (\(String(format: "%d", fatPercent))%) - "
		carbosLabelView.text	= "Carbs (\(String(format: "%d", carbosPercent))%) - "
		proteinLabelView.text	= "Protein (\(String(format: "%d", proteinPercent))%) - "

		var dataEntries: [ChartDataEntry] = []
		dataEntries.append(ChartDataEntry(x: 0, y: Double(carboCalories), data: ""))
		dataEntries.append(ChartDataEntry(x: 1, y: Double(proteinCalories), data: ""))
		dataEntries.append(ChartDataEntry(x: 2, y: Double(fatCalories), data: ""))
		
		let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
		pieChartDataSet.selectionShift = 0
		
		let pieChartData = PieChartData(dataSet: pieChartDataSet)
		pieChartData.setValueTextColor(UIColor.clear)
		caloriesChart.data = pieChartData
		
		let colors: [UIColor] = [UIColor.fat(), UIColor.protein(), UIColor.carbohydrate()]
		pieChartDataSet.colors = colors
	}
	
	private func showUnitSelectionAlert() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		let units = Dietary.units
		for index in 0 ..< units.count {
			let action = UIAlertAction(title: units[index], style: .default) { (action: UIAlertAction) in
				self.selectedUnitIndex = index
			}
			alertController.addAction(action)
		}
		self.present(alertController, animated: true, completion: nil)
	}
}
