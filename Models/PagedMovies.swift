//
//  PagedMovies.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation



struct PagedMovies : Codable {
	
	
	struct Movie : Codable {
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
	
	
	let page: Int
	let total_pages: Int
	
	let results: [Movie]
}


enum QueryType : String {
	case NowPlaying =  "now_playing"  // 55 pages
	case Popular =  "popular"  // 990 pages
	case TopRated = "top_rated"  // 357 pages
	case Upcoming = "upcoming"  // 10 pages
	
}



