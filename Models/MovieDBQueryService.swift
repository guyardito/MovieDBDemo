//
//  MovieDBQueryService.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation



	
struct Movie : Codable {
		var title = "(none)"
		var poster_path:String?	// make optional becvause not always present
		var overview = "(none)"
		
	}
	


enum QueryType : String {
	case NowPlaying =  "now_playing"  // 55 pages
	case Popular =  "popular"  // 990 pages
	case TopRated = "top_rated"  // 357 pages
	case Upcoming = "upcoming"  // 10 pages
	
}




// Runs query data task, and stores results in array of Tracks
class MovieDBQueryService {
}



