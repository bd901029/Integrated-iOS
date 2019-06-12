//
//  ProgressTrackerGraphVC.swift
//  Integrated
//
//  Created by developer on 2019/6/12.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Charts

class ProgressTrackerGraphVC: UIViewController {

	@IBOutlet weak var stateChart: LineChartView!
	@IBOutlet weak var goalChart: LineChartView!
	
	var stateColorMap = [String: UIColor]()
	var goalColorMap = [String: UIColor]()
	
	static func instance() -> ProgressTrackerGraphVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "ProgressTrackerGraphVC") as! ProgressTrackerGraphVC
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
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	func initUI() {
		stateChart.backgroundColor = UIColor.white
		stateChart.chartDescription?.enabled = false
		stateChart.isUserInteractionEnabled = true
		stateChart.setScaleEnabled(true);
		stateChart.dragEnabled = true
		stateChart.pinchZoomEnabled = true
		stateChart.xAxis.enabled = false
		stateChart.getAxis(YAxis.AxisDependency.left).enabled = false
		stateChart.getAxis(YAxis.AxisDependency.right).enabled = false
		
		goalChart.backgroundColor = UIColor.white
		goalChart.chartDescription?.enabled = false
		goalChart.isUserInteractionEnabled = true
		goalChart.setScaleEnabled(true);
		goalChart.dragEnabled = true
		goalChart.pinchZoomEnabled = true
		goalChart.xAxis.enabled = false
		goalChart.getAxis(YAxis.AxisDependency.left).enabled = false
		goalChart.getAxis(YAxis.AxisDependency.right).enabled = false
		
		stateColorMap = [String: UIColor]()
		let stateNames = StateManager.sharedInstance.allNames()
		for name in stateNames {
			stateColorMap[name] = State.color(name)
		}
		
		goalColorMap = [String: UIColor]()
		let goalNames = GoalManager.sharedInstance.allNames()
		for name in goalNames {
			goalColorMap[name] = Goal.color(name)
		}
	}
	
	func updateUI() {
		updateStateChart()
		updateGoalChart()
	}
	
	func updateStateChart() {
		var dataSets = [LineChartDataSet]()
		let stateNames = StateManager.sharedInstance.allNames()
		for name in stateNames {
			var dataEntries: [ChartDataEntry] = []
			let states = StateManager.sharedInstance.statesByName(name)
			for state in states {
				let entry = ChartDataEntry(x: Double(states.index(of: state)!), y: Double(state.value()), data: name)
				dataEntries.append(entry)
			}
			
			let color = stateColorMap[name]
			
			let dataSet = LineChartDataSet(entries: dataEntries, label: name)
			dataSet.drawIconsEnabled = false
			dataSet.setColor(color!)
			dataSet.setCircleColor(color!)
			dataSet.lineWidth = 1
			dataSet.circleRadius = 3
			dataSet.drawCircleHoleEnabled = false
			dataSets.append(dataSet)
		}
		
		let chartData = LineChartData(dataSets: dataSets)
		stateChart.data = chartData
	}
	
	func updateGoalChart() {
		var dataSets = [LineChartDataSet]()
		let goalNames = GoalManager.sharedInstance.allNames()
		for name in goalNames {
			var dataEntries: [ChartDataEntry] = []
			let goals = GoalManager.sharedInstance.goalsByName(name)
			for goal in goals {
				let entry = ChartDataEntry(x: Double(goals.index(of: goal)!), y: Double(goal.value), data: name)
				dataEntries.append(entry)
			}
			
			let color = goalColorMap[name]
			
			let dataSet = LineChartDataSet(entries: dataEntries, label: name)
			dataSet.drawIconsEnabled = false
			dataSet.setColor(color!)
			dataSet.setCircleColor(color!)
			dataSet.lineWidth = 1
			dataSet.circleRadius = 3
			dataSet.drawCircleHoleEnabled = false
			dataSets.append(dataSet)
		}
		
		let chartData = LineChartData(dataSets: dataSets)
		goalChart.data = chartData
	}
}
