//
//  MovieList_VC.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import UIKit


class MovieList_VC: UITableViewController {
	
	
	var movies: [PagedMovies.Movie] = []
	
	
	var queryService:MovieDBQueryService?
	
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		queryService = MovieDBQueryService(queryType: .Popular)

		queryService?.getSearchResults(page:1, pageLoaded: { [ weak self ] movies, currentPage, totalPages, errorStr in
			self?.movies += movies!
			
			if currentPage == 1  ||  currentPage == totalPages  ||  currentPage % 15 == 0 {
				self?.tableView.reloadData()
			}
		} )

	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
		
		let movie = movies[indexPath.row]
		
		cell.textLabel?.text = movie.title

		
		
		// Configure the cell...
		
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
