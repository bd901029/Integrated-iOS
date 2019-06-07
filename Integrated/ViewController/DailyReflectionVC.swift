//
//  DailyReflectionVC.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class DailyReflectionVC: UIViewController {

	@IBOutlet weak var dateView: UILabel!
	@IBOutlet weak var textView: LinedTextView!
	@IBOutlet weak var btnPrev: UIButton!
	@IBOutlet weak var btnNext: UIButton!
	@IBOutlet weak var btnSave: UIButton!
	
	var currentDate = Date()
	var currentReflection: Reflection? = nil
	
	static func instance() -> DailyReflectionVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "DailyReflectionVC") as! DailyReflectionVC
		return vc
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	@IBAction func onPrevBtnTapped(_ sender: UIButton) {
		currentDate = DateHelper.prevDay(currentDate)
		updateUI()
	}
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		currentDate = DateHelper.nextDay(currentDate)
		updateUI()
	}
	
	@IBAction func onCalendarBtnTapped(_ sender: UIButton) {
		var dates = [Date]()
		let reflections = ReflectionManager.sharedInstance.reflections
		for reflection in reflections {
			dates.append(reflection.date)
		}
		
		let calendarVC = CalendarVC.instance()
		calendarVC.dates = dates
		calendarVC.delegate = self
		present(calendarVC, animated: true, completion: nil)
	}
	
	@IBAction func onSaveBtnTapped(_ sender: UIButton) {
		let text = textView.text!
		if text == "" {
			Helper.showErrorAlert(target: self, message: "Please fultill all data.")
			return;
		}
		
		if currentReflection == nil {
			currentReflection = Reflection.create()
			currentReflection?.setDate(currentDate)
		}
		currentReflection!.setText(text);
		
		Helper.showLoading(target: self)
		ReflectionManager.sharedInstance.save(currentReflection!) { (error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			self.updateUI()
		}
	}
	
	func initUI() {
		
	}
	
	func updateUI() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		dateView.text = dateFormatter.string(from: currentDate)
		
		btnPrev.isHidden = DateHelper.isStartOfMonth(currentDate)
		btnNext.isHidden = DateHelper.isEndOfMonth(currentDate)
		
		currentReflection = ReflectionManager.sharedInstance.reflectionByDate(currentDate)
		if currentReflection == nil {
			textView.text = Reflection.template
		} else {
			textView.text = currentReflection?.text
		}
	}
}

extension DailyReflectionVC: CalendarVCDelegate {
	func calendarVCDidSelectDate(_ date: Date) {
		currentDate = date
		updateUI()
	}
}
