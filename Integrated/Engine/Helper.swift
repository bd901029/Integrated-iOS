//
//  Helper.swift
//  Chatripp
//
//  Created by Famousming on 2019/01/24.
//  Copyright © 2019 Famous Ming. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MBProgressHUD

public class Helper {
	
	static let colorBlueBG      = UIColor.rgb(0x3425A7)
	static let colorBlueAC      = UIColor.rgb(0x2225C7)
	
	static let colorRedBG       = UIColor.rgb(0xFF657E)
	static let colorRedAC       = UIColor.rgb(0xFF6592)
	static let colorRedLight    = UIColor.rgb(0xE73956)
	
	static let colorWhite       = UIColor.rgb(0xFFFFFF)
	static let colorTransparent = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
	
	static let colorLightGray   = UIColor.rgb(0xF4F4F4)
	static let colorGrayDark    = UIColor.rgb(0x333333)
	static let colorGray        = UIColor.rgb(0x777777)
	static let colorGreenBG     = UIColor.rgb(0x20DF91)
	
	static let colorBlack       = UIColor.rgb(0x25272D)
    
    static let appAlertTitle = "Green Nomad"
    
    static let sharedInstance : Helper = {
        
        let instance = Helper()
        return instance
    }()
    
    
    static func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func showAlert(target: UIViewController, title:String, message: String, completion: (()->())?=nil){
        
        let _title = title == "" ?  appAlertTitle : title
        
        let alert = UIAlertController(title: _title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            (result : UIAlertAction) -> Void in
            if(completion != nil){
                completion!()
            }
        }
        alert.addAction(okAction)
        target.present(alert, animated: true, completion: nil)
    }
	
	static func showErrorAlert(target: UIViewController, message: String, completion: (()->())?=nil){
		
		let _title = "Error"
		
		let alert = UIAlertController(title: _title, message: message, preferredStyle: UIAlertController.Style.alert)
		let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
		{
			(result : UIAlertAction) -> Void in
			if(completion != nil){
				completion!()
			}
		}
		alert.addAction(okAction)
		target.present(alert, animated: true, completion: nil)
	}
    
    static func showLoading(target: UIViewController){
        let hub = MBProgressHUD.showAdded(to: target.view, animated: true)
        hub.bezelView.color = Helper.colorWhite
        hub.contentColor = Helper.colorBlueBG
        hub.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
    }
    
    static func hideLoading(target: UIViewController) {
		DispatchQueue.main.async {
			MBProgressHUD.hide(for: target.view, animated: true)
		}		
    }
    
    static func thumbnailImage() -> UIImage {
        return UIImage(named: "bg_thumbnail")!
    }
    
	static func birthdayFormatter() -> DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}
}

extension String {
	func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
		return boundingBox.height
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat! {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect,
											options: .usesLineFragmentOrigin,
											attributes: [NSAttributedString.Key.font: font], context: nil)
		
		return ceil(boundingBox.width)
	}
	
	func substring(_ lastIndex: Int) -> String {
		if self.count <= lastIndex {
			return ""
		}
		
		let index = self.index(startIndex, offsetBy: lastIndex)
		let result = self[..<index] // Hello
		return String(result)
	}
	
	var floatValue: Float {
		return (self as NSString).floatValue
	}
	
	func isNumeric() -> Bool {
		if let floatValue = Float(self) {
			if floatValue >= 0 {
				return true
			}
		}
		return false
	}
}


extension UIButton {
	func setBackgroundColor(color: UIColor, forState: UIControl.State) {
		self.clipsToBounds = true  // add this to maintain corner radius
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		if let context = UIGraphicsGetCurrentContext() {
			context.setFillColor(color.cgColor)
			context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
			let colorImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			self.setBackgroundImage(colorImage, for: forState)
		}
	}
}

extension UIImage {
	func fixedOrientation() -> UIImage? {
		
		guard imageOrientation != UIImage.Orientation.up else {
			//This is default orientation, don't need to do anything
			return self.copy() as? UIImage
		}
		
		guard let cgImage = self.cgImage else {
			//CGImage is not available
			return nil
		}
		
		guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
			return nil //Not able to create CGContext
		}
		
		var transform: CGAffineTransform = CGAffineTransform.identity
		
		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: size.height)
			transform = transform.rotated(by: CGFloat.pi)
			break
		case .left, .leftMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.rotated(by: CGFloat.pi / 2.0)
			break
		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: size.height)
			transform = transform.rotated(by: CGFloat.pi / -2.0)
			break
		case .up, .upMirrored:
			break
		}
		
		//Flip image one more time if needed to, this is to prevent flipped image
		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
			break
		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)
		case .up, .down, .left, .right:
			break
		}
		
		ctx.concatenate(transform)
		
		switch imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
		default:
			ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
			break
		}
		
		guard let newCGImage = ctx.makeImage() else { return nil }
		return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
	}
}
