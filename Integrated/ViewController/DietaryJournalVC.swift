//
//  DietaryJournalVC.swift
//  Integrated
//
//  Created by developer on 2019/5/29.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import PINRemoteImage
import BarcodeScanner
import IQKeyboardManagerSwift

class DietaryJournalVC: UIViewController {

	@IBOutlet weak var btnPrev: UIButton!
	@IBOutlet weak var btnNext: UIButton!
	@IBOutlet weak var dateView: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var searchKeyView: RoundTextField!
	@IBOutlet weak var searchResultTableView: UITableView!
	
	@IBOutlet weak var totalCalorieView: UILabel!
	var currentDate = Date()
	
	var dietaries = [Dietary]()
	var searchResults = [Dietary]()
	
	static func instance() -> DietaryJournalVC {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "DietaryJournalVC") as! DietaryJournalVC
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
	
	@IBAction func onBackBtnClicked(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onScanInBtnClicked(_ sender: UIButton) {
		openBarcodeScanner()
	}
	
	@IBAction func onPrevBtnClicked(_ sender: UIButton) {
		self.currentDate = DateHelper.prevDay(self.currentDate)
		self.updateUI()
	}
	
	@IBAction func onNextBtnClicked(_ sender: UIButton) {
		self.currentDate = DateHelper.nextDay(self.currentDate)
		self.updateUI()
	}
	
	@IBAction func onCalendarBtnClicked(_ sender: UIButton) {
		var dates = [Date]()
		for dietary in DietaryManager.sharedInstance.dietaries {
			dates.append(dietary.date!)
		}
		
		let calendarVC = CalendarVC.instance()
		calendarVC.dates = dates
		calendarVC.delegate = self
		self.present(calendarVC, animated: true, completion: nil)
	}
	
	@objc func onSearchKeyTextChanged(_ sender: UITextField) {
		DietaryManager.sharedInstance.searchByName(self.searchKeyView.text!) { (results, error) in
			if error != nil {
				return
			}
			
			self.searchResults = results as! [Dietary]
			self.updateSearchResult()
		}
	}
	
	private func initUI() {
		self.searchKeyView.addTarget(self, action: #selector(onSearchKeyTextChanged(_:)), for: UIControlEvents.editingChanged)
	}
	
	private func updateUI() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMMM dd, yyyy"
		self.dateView.text = dateFormatter.string(from: self.currentDate)
		
		btnPrev.isHidden = DateHelper.isStartOfMonth(self.currentDate)
		btnNext.isHidden = DateHelper.isEndOfMonth(self.currentDate)
		
		self.dietaries = DietaryManager.sharedInstance.dietariesByDate(currentDate)
		self.tableView.reloadData()
		
		var totalCalorie: Float = 0
		for dietary in dietaries {
			totalCalorie += dietary.caloriesInKCal() * Float(dietary.count)
		}
		self.totalCalorieView.text = String(format: "%d", Int(totalCalorie))
	}
	
	private func updateSearchResult() {
		self.searchResultTableView.reloadData()
		
		self.showSearchResult(self.searchResults.count > 0)
	}
	
	func openBarcodeScanner() {
		let viewController = BarcodeScannerViewController()
		viewController.codeDelegate = self
		viewController.errorDelegate = self
		viewController.dismissalDelegate = self
		
		present(viewController, animated: true, completion: nil)
	}
	
	func openAddDietary(_ dietary: Dietary) {
		self.showSearchResult(false)
		
		if dietary.hasBeenSaved() {
			let vc = AddDietaryVC.instance(dietary)
			vc.selectedDate = dietary.createdAt
			vc.delegate = self
			self.present(vc, animated: true, completion: nil)
			return
		}
		
		Helper.showLoading(target: self)
		DietaryManager.sharedInstance.fetchInformation(dietary.nix_item_id) { (results, error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			if results!.count > 0 {
				let vc = AddDietaryVC.instance(results!.first as? Dietary)
				vc.delegate = self
				self.present(vc, animated: true, completion: nil)
			}
		}
	}
	
	func showSearchResult(_ show: Bool) {
		self.searchResultTableView.isHidden = !show
		self.tableView.isHidden = show
	}
}

extension DietaryJournalVC: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableView == self.tableView ? self.dietaries.count : self.searchResults.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "DietaryCell", for: indexPath) as! DietaryCell
		cell.dietary = tableView == self.tableView ? self.dietaries[indexPath.row] : self.searchResults[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let dietary = tableView == self.tableView ? self.dietaries[indexPath.row] : self.searchResults[indexPath.row]
		self.openAddDietary(dietary)
	}
}

extension DietaryJournalVC: BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
	func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
		self.dismiss(animated: true, completion: nil)
		print(code)
		
		Helper.showLoading(target: self)
		DietaryManager.sharedInstance.searchByBarcode(code) { (results, error) in
			Helper.hideLoading(target: self)
			if error != nil {
				Helper.showErrorAlert(target: self, message: error!.localizedDescription)
				return
			}
			
			if results!.count > 0 {
				self.openAddDietary(results?.first as! Dietary)
			}
		}
	}
	
	func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
		print(error)
	}
	
	func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension DietaryJournalVC: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if textField == searchKeyView {
			self.showSearchResult(true)
		}
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == searchKeyView {
			self.showSearchResult(false)
		}
	}
}

extension DietaryJournalVC: AddDietaryVCDelegate {
	func addDietaryCompleted(_ vc: AddDietaryVC) {
		self.updateUI()
	}
}

extension DietaryJournalVC: CalendarVCDelegate {
	func calendarVCDidSelectDate(_ date: Date) {
		self.currentDate = date
		self.updateUI()
	}
}

class DietaryCell: UITableViewCell {
	
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var nameView: UILabel!
	@IBOutlet weak var timeConsumedView: UILabel!
	@IBOutlet weak var caloriesView: UILabel!
	
	var dietary: Dietary? = nil {
		didSet {
			self.imgView.pin_setImage(from: URL(string: self.dietary!.thumb))
			self.nameView.text = self.dietary?.name()
			self.caloriesView.text = String(format: "%d", Int(self.dietary!.caloriesInKCal()))
			
			if self.dietary!.date != nil {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = self.dietary!.hasBeenSaved() ? "h:mm a" : "yyyy-MM-dd HH:mm:ss"
				self.timeConsumedView.text = dateFormatter.string(from: (self.dietary!.hasBeenSaved() ? self.dietary!.createdAt : self.dietary!.date)!)
			} else {
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = self.dietary!.hasBeenSaved() ? "h:mm a" : "yyyy-MM-dd HH:mm:ss"
				self.timeConsumedView.text = self.dietary!.hasBeenSaved() ? dateFormatter.string(from: self.dietary!.createdAt!) : ""
			}
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
