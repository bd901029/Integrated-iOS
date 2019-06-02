//
//  MeditationSectionHeader.swift
//  Integrated
//
//  Created by developer on 2019/6/1.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MeditationSectionHeader: UIView {

	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var commentView: UILabel!
	
	var section: MeditationSection? = nil {
		didSet {
			self.titleView.text = self.section!.title
			self.commentView.text = self.section!.comment
			
			let commentHeight = self.section!.comment.heightWithConstrainedWidth(width: self.commentView.frame.width,
																			  font: self.commentView.font)
			
			self.commentView.frame = CGRect(x: self.commentView.frame.origin.x,
											y: self.commentView.frame.origin.y,
											width: self.commentView.frame.width,
											height: commentHeight)
			
			self.frame = CGRect(x: self.frame.origin.x,
								y: self.frame.origin.y,
								width: self.frame.width,
								height: self.commentView.frame.origin.y + self.commentView.frame.height + 5)
		}
	}
	
	static func create() -> MeditationSectionHeader! {
		let view = UINib(nibName: "MeditationSectionHeader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MeditationSectionHeader
		return view
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}

}
