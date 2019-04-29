//
//  MovieDB_App.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/29/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation



/*
NOTE  this class consolidates global state and functionality beyond data services.
In this app that's limited to which movie categories will be displayed.
*/


class MovieDB_App {
	
	static var shared = MovieDB_App()
	
	
	func categoriesToDisplay() -> [MovieCategory] {
		return [ .NowPlaying, .Popular, .TopRated, .Upcoming ]
		
	}
}

