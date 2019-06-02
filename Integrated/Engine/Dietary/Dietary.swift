//
//  Dietary.swift
//  Integrated
//
//  Created by developer on 2019/5/20.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class Dietary: PFObject, PFSubclassing {
	static func parseClassName() -> String {
		return "Dietary"
	}
	
	@NSManaged var userId: String
	@NSManaged var count: Int
	
	@NSManaged var nix_item_id: String
	@NSManaged var food_name: String
	@NSManaged var thumb: String
	@NSManaged var quantity: Int
	@NSManaged var unit: String
	@NSManaged var calories: Float

	@NSManaged var date: Date?
	@NSManaged var nix_date: Date
	
	@NSManaged var nutritionInfo: String
	
	class Key {
		static let UserId = "userId";
		static let Count = "count";
		
		static let NixId = "nix_item_id";
		static let Name = "food_name";
		static let Thumb = "thumb";
		static let ServingQuantity = "quantity";
		static let ServingUnit = "unit";
		static let Calories = "calories";
		static let NutritionInfo = "nutritionInfo";
		static let Date = "date";
		static let NixDate = "nix_date";
		
		static let VitaminB1 = "vitaminB1";
		static let VitaminB2 = "vitaminB2";
		static let VitaminB3 = "vitaminB3";
		static let VitaminB5 = "vitaminB5";
		static let VitaminB6 = "vitaminB6";
		static let VitaminB9 = "vitaminB9";
		static let VitaminB12 = "vitaminB12";
		static let VitaminA = "vitaminA";
		static let VitaminC = "vitaminC";
		static let VitaminD = "vitaminD";
		static let VitaminE = "vitaminE";
		static let VitaminK = "vitaminK";
		
		static let Calcium = "calcium";
		static let Copper = "copper";
		static let Iron = "iron";
		static let Magnesium = "magnesium";
		static let Manganese = "manganese";
		static let Phosphorus = "phosphorus";
		static let Potassium = "potassium";
		static let Selenium = "selenium";
		static let Sodium = "sodium";
		static let Zinc = "zinc";
		
		static let Carbohydrate = "carbohydrate";
		static let Fiber = "fiber";
		static let Sugar = "sugar";
		static let Starch = "starch";
		static let NetCarbohydrates = "netCarbohydrates";
		
		static let Protein = "protein";
		static let Cystine = "cystine";
		static let Histidine = "histidine";
		static let Isoleucine = "isoleucine";
		static let Leucine = "leucine";
		static let Lysine = "lysine";
		static let Methionine = "methionine";
		static let Phenylalanine = "phenylalanine";
		static let Threonine = "threonine";
		static let Tryptophan = "tryptophan";
		static let Tyrosine = "tyrosine";
		static let Valine = "valine";
		
		static let Fat = "fat";
		static let Monounsaturated = "monounsaturated";
		static let Polyunsaturated = "polyunsaturated";
		static let Saturated = "saturated";
		static let TransFat = "transFat";
		static let Cholesterol = "cholesterol";
		static let Omega3 = "omega3";
		static let Omega6 = "omega6";
	}
	
	class NutritionIxKey {
		static let Id = "nix_item_id";
		static let Name = "food_name";
		static let Photo = "photo";
		static let Thumb = "thumb";
		static let ServingQuantity = "serving_qty";
		static let ServingUnit = "serving_unit";
		static let Calories = "nf_calories";
		static let BrandId = "nix_brand_id";
		static let BrandName = "brand_name";
		static let BrandItemName = "brand_name_item_name";
		static let BrandType = "brand_type";
		static let Date = "updated_at";
		
		static let NutritionInfo = "full_nutrients";
		static let NutrientId = "attr_id";
		static let NutrientValue = "value";
		
		static let VitaminB1 = "404";
		static let VitaminB2 = "405";
		static let VitaminB3 = "406";
		static let VitaminB5 = "410";
		static let VitaminB6 = "415";
		static let VitaminB9 = "417";
		static let VitaminB12 = "418";
		static let VitaminA = "318";
		static let VitaminC = "401";
		static let VitaminD = "324";
		static let VitaminE = "323";
		static let VitaminK = "430";
		
		static let Calcium = "301";
		static let Copper = "312";
		static let Iron = "303";
		static let Magnesium = "304";
		static let Manganese = "315";
		static let Phosphorus = "305";
		static let Potassium = "306";
		static let Selenium = "317";
		static let Sodium = "307";
		static let Zinc = "309";
		
		static let Carbohydrate = "205";
		static let Fiber = "291";
		static let Sugar = "269";
		static let Starch = "209";
		static let NetCarbohydrates = "";
		
		static let Protein = "203";
		static let Cystine = "507";
		static let Histidine = "512";
		static let Isoleucine = "503";
		static let Leucine = "504";
		static let Lysine = "505";
		static let Methionine = "506";
		static let Phenylalanine = "508";
		static let Threonine = "502";
		static let Tryptophan = "501";
		static let Tyrosine = "509";
		static let Valine = "510";
		
		static let Fat = "204";
		static let Monounsaturated = "645";
		static let Polyunsaturated = "646";
		static let Saturated = "606";
		static let TransFat = "605";
		static let Cholesterol = "601";
		static let Omega3 = "851";
		static let Omega6 = "Omega6";
	}
	
	private static let nutritionKeys: [String: String] = [NutritionIxKey.VitaminB1: Key.VitaminB1,
														  NutritionIxKey.VitaminB2: Key.VitaminB2,
														  NutritionIxKey.VitaminB3: Key.VitaminB3,
														  NutritionIxKey.VitaminB5: Key.VitaminB5,
														  NutritionIxKey.VitaminB6: Key.VitaminB6,
														  NutritionIxKey.VitaminB9: Key.VitaminB9,
														  NutritionIxKey.VitaminB12: Key.VitaminB12,
														  NutritionIxKey.VitaminA: Key.VitaminA,
														  NutritionIxKey.VitaminC: Key.VitaminC,
														  NutritionIxKey.VitaminD: Key.VitaminD,
														  NutritionIxKey.VitaminE: Key.VitaminE,
														  NutritionIxKey.VitaminK: Key.VitaminK,
														  
														  NutritionIxKey.Calcium: Key.Calcium,
														  NutritionIxKey.Copper: Key.Copper,
														  NutritionIxKey.Iron: Key.Iron,
														  NutritionIxKey.Magnesium: Key.Magnesium,
														  NutritionIxKey.Manganese: Key.Manganese,
														  NutritionIxKey.Phosphorus: Key.Phosphorus,
														  NutritionIxKey.Potassium: Key.Potassium,
														  NutritionIxKey.Selenium: Key.Selenium,
														  NutritionIxKey.Sodium: Key.Sodium,
														  NutritionIxKey.Zinc: Key.Zinc,
														  
														  NutritionIxKey.Carbohydrate: Key.Carbohydrate,
														  NutritionIxKey.Fiber: Key.Fiber,
														  NutritionIxKey.Sugar: Key.Sugar,
														  NutritionIxKey.Starch: Key.Starch,
														  NutritionIxKey.NetCarbohydrates: Key.NetCarbohydrates,
														  
														  NutritionIxKey.Protein: Key.Protein,
														  NutritionIxKey.Cystine: Key.Cystine,
														  NutritionIxKey.Histidine: Key.Histidine,
														  NutritionIxKey.Isoleucine: Key.Isoleucine,
														  NutritionIxKey.Leucine: Key.Leucine,
														  NutritionIxKey.Lysine: Key.Lysine,
														  NutritionIxKey.Methionine: Key.Methionine,
														  NutritionIxKey.Phenylalanine: Key.Phenylalanine,
														  NutritionIxKey.Threonine: Key.Threonine,
														  NutritionIxKey.Tryptophan: Key.Tryptophan,
														  NutritionIxKey.Tyrosine: Key.Tyrosine,
														  NutritionIxKey.Valine: Key.Valine,
														  
														  NutritionIxKey.Fat: Key.Fat,
														  NutritionIxKey.Monounsaturated: Key.Monounsaturated,
														  NutritionIxKey.Polyunsaturated: Key.Polyunsaturated,
														  NutritionIxKey.Saturated: Key.Saturated,
														  NutritionIxKey.TransFat: Key.TransFat,
														  NutritionIxKey.Cholesterol: Key.Cholesterol,
														  NutritionIxKey.Omega3: Key.Omega3,
														  NutritionIxKey.Omega6: Key.Omega6]
	
	public static func create(_ info: [String: Any]) -> Dietary {
		let dietary = Dietary()
		
		if let nixId = info[NutritionIxKey.Id] as? String {
			dietary.setNixId(nixId)
		}
		
		if let name = info[NutritionIxKey.Name] as? String {
			dietary.setName(name)
		}
		
		if let photo = info[NutritionIxKey.Photo] as? [String: Any] {
			dietary.setThumb(photo[NutritionIxKey.Thumb] as! String)
		}
		
		if let servingQuantity = info[NutritionIxKey.ServingQuantity] as? Int {
			dietary.setServingQuantity(servingQuantity)
		}
		
		if let servingUnit = info[NutritionIxKey.ServingUnit] as? String {
			dietary.setServingUnit(servingUnit);
		}
		
		if let calories = info[NutritionIxKey.Calories] as? Float {
			dietary.setCalories(calories)
		}
		
		if let nixDate = info[NutritionIxKey.Date] as? String {
			dietary.setNixDate(nixDate)
		}
		
		if let nutritionInfo = info[NutritionIxKey.NutritionInfo] as? [[String: Any]] {
			dietary.loadNutritionInfo(nutritionInfo)
		}
		
		return dietary
	}
	
	static var units: [String] {
		return ["g", "oz"]
	}
	
	var nutritionDict: [String: Any]? = nil
	private func loadNutritionInfo(_ infos: [[String: Any]]) {
		self.nutritionDict = [String: Any]()
		for info in infos {
			guard (info[NutritionIxKey.NutrientId] != nil) else {
				continue
			}
			
			let nixKey = String(info[NutritionIxKey.NutrientId] as! Int)
			
			guard let key = Dietary.nutritionKeys[nixKey] else {
				continue
			}
			
			guard let value = info[NutritionIxKey.NutrientValue] as? Float else {
				continue
			}
			
			nutritionDict![key] = value
		}
		let strNutritionInfo = Helper.JSONStringify(value: self.nutritionDict as AnyObject)
		self.nutritionInfo = strNutritionInfo
	}
		
	private func getNutritionInfo() -> [String: Any] {
		do {
			if self.nutritionDict == nil || self.nutritionDict!.isEmpty {
				let data: Data? = self.nutritionInfo.data(using: .utf8)
				self.nutritionDict = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: Any]
			}
		} catch let error {
			print(error)
			self.nutritionDict = [String: Any]()
		}
		return self.nutritionDict!
	}
	
	func hasBeenSaved() -> Bool {
		return (objectId != nil && objectId != "")
	}
	
	func setUserId(_ userId: String) {
		self.userId = userId
	}
	
	func setNixId(_ id: String) {
		self.nix_item_id = id
	}
	
	func name() -> String {
		return food_name
	}
	
	func setName(_ name: String) {
		self.food_name = name
	}
	
	func setThumb(_ imagePath: String) {
		self.thumb = imagePath
	}
	
	func setServingQuantity(_ servingQuantity: Int) {
		self.quantity = servingQuantity
	}
	
	func isG() -> Bool {
		return self.unit == "g"
	}
	
	func isOZ() -> Bool {
		return self.unit == "oz"
	}
	
	func isGorOZ() -> Bool {
		return (isG() || isOZ())
	}
	
	func setServingUnit(_ servingUnit: String) {
		self.unit = servingUnit
	}
	
	func caloriesInKCal() -> Float {
		return calories
	}
	
	func caloriesFromNutrientsInKCal() -> Float {
		let carboCalories = NutrientCalculator.calories(carbohydrateInG(), NutrientCalculator.CALORIES_PER_CARBO_ING)
		let proteinCalories = NutrientCalculator.calories(proteinInG(), NutrientCalculator.CALORIES_PER_PROTEIN_ING);
		let fatCalories = NutrientCalculator.calories(fatInG(), NutrientCalculator.CALORIES_PER_FAT_ING);
	
		return carboCalories + proteinCalories + fatCalories;
	}
	
	func setCalories(_ calories: Float) {
		self.calories = calories
	}
	
	func setDate(_ date: Date) {
		self.date = date
	}
	
	func nixDateText() -> String {
		guard (self.date != nil) else {
			return ""
		}
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.string(from: self.date!)
	}
	
	func setNixDate(_ strDate: String) {
		var strDate = strDate.substring(18)
		strDate = strDate.replacingOccurrences(of: "T", with: " ")
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		self.date = dateFormatter.date(from: strDate)!
	}
	
	func setCount(_ count: Int) {
		self.count = count
	}
	
	func nutrientValue(_ key: String) -> Float {
		guard let result = self.getNutritionInfo()[key] as? Float else { return 0 }
		return result
	}
	
	func vitaminB1InMG() -> Float {
		return self.nutrientValue(Key.VitaminB1)
	}
	
	func vitaminB2InMG() -> Float {
		return self.nutrientValue(Key.VitaminB2)
	}
	
	func vitaminB3InMG() -> Float {
		return self.nutrientValue(Key.VitaminB3)
	}
	
	func vitaminB5InMG() -> Float {
		return self.nutrientValue(Key.VitaminB5)
	}
	
	func vitaminB6InMG() -> Float {
		return self.nutrientValue(Key.VitaminB6)
	}
	
	func vitaminB9InAMG() -> Float {
		return self.nutrientValue(Key.VitaminB9)
	}
	
	func vitaminB12InAMG() -> Float {
		return self.nutrientValue(Key.VitaminB12)
	}
	
	func vitaminAInIU() -> Float {
		return self.nutrientValue(Key.VitaminA)
	}
	
	func vitaminCInMG() -> Float {
		return self.nutrientValue(Key.VitaminC)
	}
	
	func vitaminDInIU() -> Float {
		return self.nutrientValue(Key.VitaminD)
	}
	
	func vitaminEInMG() -> Float {
		return self.nutrientValue(Key.VitaminE)
	}
	
	func vitaminKInAMG() -> Float {
		return self.nutrientValue(Key.VitaminK)
	}
	
	func calciumInMG() -> Float { 			return self.nutrientValue(Key.Calcium)		}
	
	func copperInMG() -> Float {			return self.nutrientValue(Key.Copper)		}
	
	func ironInMG() -> Float {				return self.nutrientValue(Key.Iron)			}
	
	func magnesiumInMG() -> Float {			return self.nutrientValue(Key.Magnesium)		}
	
	func manganeseInMG() -> Float {			return self.nutrientValue(Key.Manganese)		}
	
	func phosphorusInMG() -> Float {		return self.nutrientValue(Key.Phosphorus)	}
	
	func potassiumInMG() -> Float {			return self.nutrientValue(Key.Potassium)		}
	
	func seleniumInAMG() -> Float {			return self.nutrientValue(Key.Selenium)		}
	
	func sodiumInMG() -> Float {			return self.nutrientValue(Key.Sodium)		}
	
	func zincInMG() -> Float {				return self.nutrientValue(Key.Zinc)			}
	
	func carbohydrateInG() -> Float {		return self.nutrientValue(Key.Carbohydrate)	}
	
	func carbohydrateInKCal() -> Float {
		return NutrientCalculator.calories(carbohydrateInG(), NutrientCalculator.CALORIES_PER_CARBO_ING)
	}
	
	func fiberInG() -> Float {				return self.nutrientValue(Key.Fiber)			}
	
	func sugarInG() -> Float {				return self.nutrientValue(Key.Sugar)			}
	
	func starchInG() -> Float {				return self.nutrientValue(Key.Starch)		}
	
	func netCarbohydrates() -> Float {		return self.nutrientValue(Key.NetCarbohydrates) }
	
	func proteinInG() -> Float {			return self.nutrientValue(Key.Protein)		}
	
	func proteinInKCal() -> Float {
		return NutrientCalculator.calories(proteinInG(), NutrientCalculator.CALORIES_PER_PROTEIN_ING)
	}
	
	func cystineInG() -> Float {			return self.nutrientValue(Key.Cystine)		}
	
	func histidineInG() -> Float {			return self.nutrientValue(Key.Histidine)		}
	
	func isoleucineInG() -> Float {			return self.nutrientValue(Key.Isoleucine)	}
	
	func leucineInG() -> Float {			return self.nutrientValue(Key.Leucine)		}
	
	func lysineInG() -> Float {				return self.nutrientValue(Key.Lysine)		}
	
	func methionineInG() -> Float {			return self.nutrientValue(Key.Methionine)	}
	
	func phenylalanineInG() -> Float {		return self.nutrientValue(Key.Phenylalanine)	}
	
	func threonineInG() -> Float {			return self.nutrientValue(Key.Threonine)		}
	
	func tryptophanInG() -> Float {			return self.nutrientValue(Key.Tryptophan)	}
	
	func tyrosineInG() -> Float {			return self.nutrientValue(Key.Tyrosine)		}
	
	func valineInG() -> Float {				return self.nutrientValue(Key.Valine)		}
	
	func fatInG() -> Float {				return self.nutrientValue(Key.Fat)			}
	
	func totalFatInG() -> Float {
		return fatInG() * Float(count)
	}
	
	func fatInKCal() -> Float {
		return NutrientCalculator.calories(fatInG(), NutrientCalculator.CALORIES_PER_FAT_ING)
	}
	
	func totalFatInKCal() -> Float {
		return fatInKCal() * Float(count)
	}
	
	func monounsaturatedInG() -> Float {	return self.nutrientValue(Key.Monounsaturated)	}
	
	func polyunsaturatedInG() -> Float {	return self.nutrientValue(Key.Polyunsaturated)	}
	
	func saturatedInG() -> Float {			return self.nutrientValue(Key.Saturated)			}
	
	func transFatInG() -> Float {			return self.nutrientValue(Key.TransFat)			}
	
	func cholesterolInMG() -> Float {		return self.nutrientValue(Key.Cholesterol)		}
	
	func omega3InG() -> Float {				return self.nutrientValue(Key.Omega3)			}
	
	func omega6() -> Float {				return self.nutrientValue(Key.Omega6)			}

}
