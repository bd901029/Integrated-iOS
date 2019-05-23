//
//  BlogDetailVC.swift
//  Integrated
//
//  Created by developer on 2019/5/23.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Parse

class BlogDetailVC: UIViewController {
	
	var blog: Blog?

	@IBOutlet weak var imageView: PFImageView!
	@IBOutlet weak var commentView: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.initUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.updateUI()
	}
	
	@IBAction func onBackBtnClicked(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	private func initUI() {
	}
	
	private func updateUI() {
		if self.blog == nil {
			return
		}
		
		self.imageView.file = self.blog?.image
		self.imageView.loadInBackground()
		
		self.commentView.text = self.blog?.comment

		let commentHeight = self.blog!.comment.heightWithConstrainedWidth(width: self.commentView.frame.width,
																	   font: self.commentView.font) + 20
		
		self.commentView.frame = CGRect(x: self.commentView.frame.origin.x,
										y: self.view.frame.size.height - commentHeight,
										width: self.commentView.frame.width,
										height: commentHeight)
		self.imageView.frame = CGRect(x: 0,
									  y: self.imageView.frame.origin.y,
									  width: self.imageView.frame.width,
									  height: self.commentView.frame.origin.y - self.imageView.frame.origin.y)
	}
}
