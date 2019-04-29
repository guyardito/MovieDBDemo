//
//  CustomTabBarController.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit


class MovieCategory_TabBar: UITabBarController {
	
	
	func makeVCAndNavController(queryType:QueryType, title:String, tag:Int) -> UINavigationController {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		let vc = storyboard.instantiateViewController(withIdentifier: "MovieList_VC") as! MovieInfo_Table
		vc.queryService = MovieDB_DataServer(queryType: queryType)
		vc.startDownload()
		let navController = UINavigationController()
		navController.viewControllers = [vc]
		navController.tabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
		
		return navController
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		let nowPlaying = makeVCAndNavController(queryType: .NowPlaying, title: "Now Playing", tag: 0)
		
		let upcoming = makeVCAndNavController(queryType: .Upcoming, title: "Upcoming", tag: 1)
		
		let topRated = makeVCAndNavController(queryType: .TopRated, title: "Top Rated", tag: 2)
		
		let popular = makeVCAndNavController(queryType: .Popular, title: "Popular", tag: 3)
		
		
		
		let tabBarList = [nowPlaying, upcoming, topRated, popular]
		
		viewControllers = tabBarList
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}

