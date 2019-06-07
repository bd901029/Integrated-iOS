//
//  LinedTextView.swift
//  Integrated
//
//  Created by developer on 2019/6/8.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

@IBDesignable
class LinedTextView: UITextView {
	@IBInspectable
	var lineHeight: CGFloat = 20 {
		didSet {
			let style = NSMutableParagraphStyle()
			style.lineSpacing = self.lineHeight
			let attributes = [NSAttributedStringKey.paragraphStyle : style, NSAttributedStringKey.font: self.font]
			self.attributedText = NSAttributedString(string: self.text, attributes: attributes)
		}
	}
	
	@IBInspectable
	var lineSpace: CGFloat = 20 {
		didSet {
			self.setNeedsDisplay()
		}
	}
	
	override func draw(_ rect: CGRect) {
		print(String(format: "Font Line Height: %f", self.font!.lineHeight))
		
		let screen = self.window != nil ? self.window!.screen : UIScreen.main
		let lineWidth = 1.0 / screen.scale
		
		let context = UIGraphicsGetCurrentContext()
		context?.setLineWidth(lineWidth)
		
		context?.beginPath()
		context?.setStrokeColor(UIColor.gray.cgColor)
		
		// Create un-mutated floats outside of the for loop.
		// Reduces memory access.
		let baseOffset: CGFloat = 0
		let boundsX = self.bounds.origin.x
		let boundsWidth = self.bounds.size.width
		
		// Only draw lines that are visible on the screen.
		// (As opposed to throughout the entire view's contents)
		let firstVisibleLine = 0
		let lastVisibleLine = 999
		for index in firstVisibleLine ... lastVisibleLine {
			let linePointY = (baseOffset + ((lineSpace + 1.0) * CGFloat(index)))
			context?.move(to: CGPoint(x: boundsX, y: linePointY))
			context?.addLine(to: CGPoint(x: boundsWidth, y: linePointY))
		}
		
		context?.closePath()
		context?.strokePath()
	}
}
