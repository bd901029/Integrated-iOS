//
//  DateHelper.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class DateHelper: NSObject {
	public static func dateToText(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.string(from: date)
	}
	
	public static func textToDate(_ strDate: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.date(from: strDate)
	}
	
	public static func birthdayToDate(_ strDate: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		return dateFormatter.date(from: strDate)
	}
	
	public static func birthdayToText(_ date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		return dateFormatter.string(from: date)
	}
	
	public static func year(_ date: Date) -> Int {
		let calendar = Calendar.current
		return calendar.component(Calendar.Component.year, from: date)
	}
	
	public static func month(_ date: Date) -> Int {
		let calendar = Calendar.current
		return calendar.component(Calendar.Component.month, from: date)
	}
	
	public static func day(_ date: Date) -> Int {
		let calendar = Calendar.current
		return calendar.component(Calendar.Component.day, from: date)
	}
	
	public static func prevDay(_ date: Date) -> Date {
		let date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
		return date
	}
	
	public static func nextDay(_ date: Date) -> Date {
		let date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
		return date
	}
	
	public static func isStartOfMonth(_ date: Date) -> Bool {
		let month = DateHelper.month(date)
		let tempMonth = DateHelper.month(DateHelper.prevDay(date))
		return month != tempMonth
	}
	
	public static func isEndOfMonth(_ date: Date) -> Bool {
		let month = DateHelper.month(date)
		let tempMonth = DateHelper.month(DateHelper.nextDay(date))
		return month != tempMonth
	}
	
	public static func isSameDay(_ date1: Date?, _ date2: Date?) -> Bool {
		if (date1 == nil || date2 == nil) {
			return false
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		let strDate1 = dateFormatter.string(from: date1!)
		let strDate2 = dateFormatter.string(from: date2!)
		
		return strDate1 == strDate2
	}
}
