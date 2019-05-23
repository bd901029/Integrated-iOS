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
	
	@NSManaged var nixId: String
	@NSManaged var name: String
	@NSManaged var thumb: String
	@NSManaged var servingQuantity: Int
	@NSManaged var servingUnit: String
	@NSManaged var calories: Float

	@NSManaged var date: Date
	@NSManaged var nixDate: Date
	
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
		static let Omega6 = "";
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
	
	var nutritionDict: [String: Any]? = nil
	private func loadNutritionInfo(_ infos: [[String: Any]]) {
		self.nutritionDict = [String: Any]()
		for info in infos {
			guard let nixKey = info[NutritionIxKey.NutrientId] as? String else {
				continue
			}
			
			guard let key = Dietary.nutritionKeys[nixKey] else {
				continue
			}
			
			guard let value = info[NutritionIxKey.NutrientValue] as? Float else {
				continue
			}
			
			nutritionDict![key] = value
		}
		let strNutritionInfo = String(describing: self.nutritionDict)
		self.nutritionInfo = strNutritionInfo
	}
		
	private func getNutritionInfo() -> [String: Any] {
		do {
			let data = (self[Key.NutritionInfo] as? String)?.data(using: .utf8)
			self.nutritionDict = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as? [String: Any]
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
		self.nixId = id
	}
	
	func setName(_ name: String) {
		self.name = name
	}
	
	func setThumb(_ imagePath: String) {
		self.thumb = imagePath
	}
	
	func setServingQuantity(_ servingQuantity: Int) {
		self.servingQuantity = servingQuantity
	}
	
	func isG() -> Bool {
		return self.servingUnit == "g"
	}
	
	func isOZ() -> Bool {
		return self.servingUnit == "oz"
	}
	
	func isGorOZ() -> Bool {
		return (isG() || isOZ())
	}
	
	func setServingUnit(_ servingUnit: String) {
		self.servingUnit = servingUnit
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
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
		return dateFormatter.string(from: self.date)
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
	
	func vitaminB1InMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB1] as! Float
	}
	
	func vitaminB2InMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB2] as! Float
	}
	
	func vitaminB3InMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB3] as! Float
	}
	
	func vitaminB5InMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB5] as! Float
	}
	
	func vitaminB6InMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB6] as! Float
	}
	
	func vitaminB9InAMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB9] as! Float
	}
	
	func vitaminB12InAMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminB12] as! Float
	}
	
	func vitaminAInIU() -> Float {
		return self.getNutritionInfo()[Key.VitaminA] as! Float
	}
	
	func vitaminCInMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminC] as! Float
	}
	
	func vitaminDInIU() -> Float {
		return self.getNutritionInfo()[Key.VitaminD] as! Float
	}
	
	func vitaminEInMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminE] as! Float
	}
	
	func vitaminKInAMG() -> Float {
		return self.getNutritionInfo()[Key.VitaminK] as! Float
	}
	
	func calciumInMG() -> Float {
		return self.getNutritionInfo()[Key.Calcium] as! Float
	}
	
	func copperInMG() -> Float {
		return self.getNutritionInfo()[Key.Copper] as! Float
	}
	
	func ironInMG() -> Float {
		return self.getNutritionInfo()[Key.Iron] as! Float
	}
	
	func magnesiumInMG() -> Float {
		return self.getNutritionInfo()[Key.Magnesium] as! Float
	}
	
	func manganeseInMG() -> Float {
		return self.getNutritionInfo()[Key.Manganese] as! Float
	}
	
	func phosphorusInMG() -> Float {
		return self.getNutritionInfo()[Key.Phosphorus] as! Float
	}
	
	func potassiumInMG() -> Float {
		return self.getNutritionInfo()[Key.Potassium] as! Float
	}
	
	func seleniumInAMG() -> Float {
		return self.getNutritionInfo()[Key.Selenium] as! Float
	}
	
	func sodiumInMG() -> Float {
		return self.getNutritionInfo()[Key.Sodium] as! Float
	}
	
	func zincInMG() -> Float {
		return self.getNutritionInfo()[Key.Zinc] as! Float
	}
	
	func carbohydrateInG() -> Float {
		return self.getNutritionInfo()[Key.Carbohydrate] as! Float
	}
	
	func carbohydrateInKCal() -> Float {
		return NutrientCalculator.calories(carbohydrateInG(), NutrientCalculator.CALORIES_PER_CARBO_ING)
	}
	
	func fiberInG() -> Float {
		return self.getNutritionInfo()[Key.Fiber] as! Float
	}
	
	func sugarInG() -> Float {
		return self.getNutritionInfo()[Key.Sugar] as! Float
	}
	
	func starchInG() -> Float {
		return self.getNutritionInfo()[Key.Starch] as! Float
	}
	
	func netCarbohydrates() -> Float {
		return self.getNutritionInfo()[Key.NetCarbohydrates] as! Float
	}
	
	func proteinInG() -> Float {
		return self.getNutritionInfo()[Key.Protein] as! Float
	}
	
	func proteinInKCal() -> Float {
		return NutrientCalculator.calories(proteinInG(), NutrientCalculator.CALORIES_PER_PROTEIN_ING)
	}
	
	func cystineInG() -> Float {
		return self.getNutritionInfo()[Key.Cystine] as! Float
	}
	
	func histidineInG() -> Float {
		return self.getNutritionInfo()[Key.Histidine] as! Float
	}
	
	func isoleucineInG() -> Float {
		return self.getNutritionInfo()[Key.Isoleucine] as! Float
	}
	
	func leucineInG() -> Float {
		return self.getNutritionInfo()[Key.Leucine] as! Float
	}
	
	func lysineInG() -> Float {
		return self.getNutritionInfo()[Key.Lysine] as! Float
	}
	
	func methionineInG() -> Float {
		return self.getNutritionInfo()[Key.Methionine] as! Float
	}
	
	func phenylalanineInG() -> Float {
		return self.getNutritionInfo()[Key.Phenylalanine] as! Float
	}
	
	func threonineInG() -> Float {
		return self.getNutritionInfo()[Key.Threonine] as! Float
	}
	
	func tryptophanInG() -> Float {
		return self.getNutritionInfo()[Key.Tryptophan] as! Float
	}
	
	func tyrosineInG() -> Float {
		return self.getNutritionInfo()[Key.Tyrosine] as! Float
	}
	
	func valineInG() -> Float {
		return self.getNutritionInfo()[Key.Valine] as! Float
	}
	
	func fatInG() -> Float {
		return self.getNutritionInfo()[Key.Fat] as! Float
	}
	
	func totalFatInG() -> Float {
		return fatInG() * Float(count)
	}
	
	func fatInKCal() -> Float {
		return NutrientCalculator.calories(fatInG(), NutrientCalculator.CALORIES_PER_FAT_ING)
	}
	
	func totalFatInKCal() -> Float {
		return fatInKCal() * Float(count)
	}
	
	func monounsaturatedInG() -> Float {
		return self.getNutritionInfo()[Key.Monounsaturated] as! Float
	}
	
	func polyunsaturatedInG() -> Float {
		return self.getNutritionInfo()[Key.Polyunsaturated] as! Float
	}
	
	func saturatedInG() -> Float {
		return self.getNutritionInfo()[Key.Saturated] as! Float
	}
	
	func transFatInG() -> Float {
		return self.getNutritionInfo()[Key.TransFat] as! Float
	}
	
	func cholesterolInMG() -> Float {
		return self.getNutritionInfo()[Key.Cholesterol] as! Float
	}
	
	func omega3InG() -> Float {
		return self.getNutritionInfo()[Key.Omega3] as! Float
	}
	
	func omega6() -> Float {
		return self.getNutritionInfo()[Key.Omega6] as! Float
	}

}
