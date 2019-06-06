//
//  CustomLineTextView.swift
//  Integrated
//
//  Created by developer on 2019/6/4.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLineTextView: UITextView {
	
	var lineHeight: CGFloat = 13.8
	
	override var font: UIFont? {
		didSet {
			if let newFont = font {
				self.lineHeight = newFont.lineHeight
			}
		}
	}

	override func draw(_ rect: CGRect) {
		let ctx = UIGraphicsGetCurrentContext()
		ctx?.setStrokeColor(UIColor.black.cgColor)
		let numberOfLines = Int(rect.height / lineHeight)
		let topInset = textContainerInset.top
		
		for i in 1...numberOfLines {
			let y = topInset + CGFloat(i) * lineHeight
			
			let line = CGMutablePath()
			line.move(to: CGPoint(x: 0.0, y: y))
			line.addLine(to: CGPoint(x: rect.width, y: y))
			ctx?.addPath(line)
		}
		
		ctx?.strokePath()
		
		super.draw(rect)
	}
}
