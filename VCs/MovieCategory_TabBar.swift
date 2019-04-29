//
//  CustomTabBarController.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit


class MovieCategory_TabBar: UITabBarController {
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var tabBarList = [UINavigationController]()
		
		let categories = MovieDB_App.shared.categoriesToDisplay()
		for (index, c) in categories.enumerated() {
			let vc = makeVCAndNavController(category: c, title: c.rawValue, tag: index)
			tabBarList.append(vc)
			
		}
		
		viewControllers = tabBarList
	}
	
	
	
	func makeVCAndNavController(category:MovieCategory, title:String, tag:Int) -> UINavigationController {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
		let vc = storyboard.instantiateViewController(withIdentifier: "MovieInfo_Table_VC") as! MovieInfo_Table
		vc.category = category
		vc.queryService = MovieDB_DataServer(queryType: category)
		vc.startDownload()

		let navController = UINavigationController()
		navController.viewControllers = [vc]
		navController.tabBarItem = UITabBarItem(title: title, image: nil, tag: tag)
		
		return navController
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

