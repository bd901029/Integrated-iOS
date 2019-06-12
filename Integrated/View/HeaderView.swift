//
//  HeaderView.swift
//  Integrated
//
//  Created by developer on 2019/6/10.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

@IBDesignable
class HeaderView: UIView {

	override func awakeFromNib() {
		super.awakeFromNib()
		self.superview?.bringSubview(toFront: self)
		applySketchShadow()
	}

	func applySketchShadow(
		color: UIColor = .black,
		alpha: Float = 0.5,
		x: CGFloat = 0,
		y: CGFloat = 2,
		blur: CGFloat = 4,
		spread: CGFloat = 0)
	{
		layer.shadowColor = color.cgColor
		layer.shadowOpacity = alpha
		layer.shadowOffset = CGSize(width: x, height: y)
		layer.shadowRadius = blur / 2.0
		if spread == 0 {
			layer.shadowPath = nil
		} else {
			let dx = -spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			layer.shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}
