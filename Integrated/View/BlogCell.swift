//
//  BlogCell.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class BlogCell: UITableViewCell {
	
	@IBOutlet weak var imgView: PFImageView!
	@IBOutlet weak var titleView: UILabel!
	@IBOutlet weak var dateView: UILabel!
	
	var blog: Blog? = nil {
		didSet {
			self.imgView.file = self.blog?.thumb
			self.imgView.loadInBackground()
			
			self.titleView.text = self.blog?.title
			
			self.dateView.text = self.blog?.getDateText()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	@IBAction func onBtnTapped(_ sender: UIButton) {
		let blogDetailVC = BlogDetailVC.instance()
		blogDetailVC.blog = self.blog
		self.parentViewController?.present(blogDetailVC, animated: true, completion: nil)
	}
}
