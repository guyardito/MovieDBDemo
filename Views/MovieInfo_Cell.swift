//
//  MovieCell.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit

class MovieInfo_Cell: UITableViewCell {
	
	@IBOutlet var title:UILabel?
	@IBOutlet var posterPath:UILabel?
	@IBOutlet var overview:UILabel?
	@IBOutlet var poster:UIImageView?
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
