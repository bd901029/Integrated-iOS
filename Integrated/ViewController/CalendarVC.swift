//
//  CalendarVC.swift
//  Integrated
//
//  Created by developer on 2019/5/31.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalendarVCDelegate {
	func calendarVCDidSelectDate(_ date: Date)
}

class CalendarVC: UIViewController {
	
	var dates = [Date]()
	let imgCalendar = UIImage(named: "calendar")?.scaleToWidth(20)
	var delegate: CalendarVCDelegate? = nil
	
	@IBOutlet weak var calendarView: FSCalendar!
	
	static func instance() -> CalendarVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
		return vc
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		initUI()
    }
	
	@IBAction func onBackBtnTapped(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func initUI() {
		self.calendarView.appearance.weekdayTextColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
		
		self.calendarView.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
		self.calendarView.appearance.selectionColor = UIColor.primary()
		self.calendarView.appearance.headerDateFormat = "MMMM yyyy"
		self.calendarView.appearance.headerTitleColor = UIColor(red: 14/255.0, green: 69/255.0, blue: 221/255.0, alpha: 1.0)
		
		self.calendarView.appearance.todayColor = UIColor.clear
		self.calendarView.appearance.titleTodayColor = UIColor.rgb(0x2962ff)
		
		self.calendarView.appearance.borderRadius = 1.0
		self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.2
	}
	
	private func updateUI() {
		
	}
}

extension CalendarVC: FSCalendarDataSource, FSCalendarDelegate {
	func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
		self.calendarView.frame = CGRect(origin: self.calendarView.frame.origin, size: bounds.size)
		self.calendarView.invalidateIntrinsicContentSize()
	}
	
	func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
		for tmpDate in self.dates {
			if DateHelper.isSameDay(tmpDate, date) {
				return imgCalendar
			}
		}

		return nil
	}
	
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		if monthPosition == .previous || monthPosition == .next {
			calendar.setCurrentPage(date, animated: true)
		}
		
		self.delegate?.calendarVCDidSelectDate(date)
		
		self.dismiss(animated: true, completion: nil)
	}
}
