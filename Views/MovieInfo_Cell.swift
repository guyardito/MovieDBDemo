//
//  MovieCell.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit
import Kingfisher


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
	
	
	func populateFrom(movie:MovieInfo) {
		title?.text = movie.title
		posterPath?.text = movie.poster_path
		overview?.text = movie.overview
		poster?.image = nil  // make sure we start fresh  :)
		
		
		guard let urlAsString = movie.posterURL(width: 200) else {
			return
		}
		
		guard let url = URL(string: urlAsString) else {
			print("ERROR error creating URL from \(urlAsString)")
			return
		}
		
		DispatchQueue.main.async {
			self.poster?.kf.setImage(with:url)  // use Kingfisher: will use cache and also update imageView on the main thread
		}
		
	}
	
}
