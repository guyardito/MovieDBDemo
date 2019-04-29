//
//  PagedMovies.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation




struct MovieInfo : Codable {
	var title = "(none)"
	var poster_path:String?	// make optional becvause not always present
	var overview = "(none)"
	
	func posterURL(width:Int) -> String? {
		if poster_path == nil {
			return nil
		}
		return "https://image.tmdb.org/t/p/w\(width)" + poster_path!
	}
	
	init(title:String, posterPath:String, overview:String) {
		self.title = title
		self.poster_path = posterPath
		self.overview = overview
	}
}



struct PagedMovies : Codable {
	
	let page: Int
	let numberOfPages: Int
	let numberOfMovies: Int
	
	let movies: [MovieInfo]
	
	
	private enum CodingKeys: String, CodingKey {
		case page
		case numberOfPages = "total_pages"
		case numberOfMovies = "total_results"
		case movies = "results"
		
	}
	
}




