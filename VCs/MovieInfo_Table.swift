//
//  MovieList_VC.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit



class MovieInfo_Table: UITableViewController {
	
	
	var category:MovieCategory = .NowPlaying
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		self.title = category.rawValue
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 300.0 // set to whatever your "average" cell height is
		
		tableView.prefetchDataSource = self
		
		MovieDB_DataServer.shared.fetch(category: category, page: 1, doSynchronously: false, completion: {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		} )
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let total = MovieDB_DataServer.shared.numberOfEntriesFor(category: category)
		return total
	}
	
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieInfo_Cell
		
		let movie = MovieDB_DataServer.shared.getMovieFrom(category: category, at: indexPath.row)
		
		cell.populateFrom(movie:movie)
		

		return cell
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




extension  MovieInfo_Table: UITableViewDataSourcePrefetching {
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach {
			MovieDB_DataServer.shared.fetch(category: category, index: $0.row)
		}
	}
	
	
	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		for i in  indexPaths {
			// we're not worrying about cancelling in this app because each download is fairly small (about 12k)
			print("NOTE  request to cancel fetch of movie at index \(i.row), ignoring...")
		}
	}
}

