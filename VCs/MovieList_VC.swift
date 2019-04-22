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
	
	let popularQueryService = MovieDBQueryService(queryType: .Popular)
	
	var queryService:MovieDBQueryService?
	
	
	
	
	func startDownload() {
		queryService?.getSearchResults(page:1, pageLoaded: { [ weak self ] movies, currentPage, totalPages, errorStr in
			self?.movies += movies!
			
			if currentPage != totalPages {
				self?.title = "\(100 * currentPage / totalPages)% " + (self?.queryService?.queryType)!.rawValue
			} else {
				self?.title = (self?.queryService?.queryType)!.rawValue
			}
			
			if currentPage == 1  ||  currentPage == totalPages  ||  currentPage % 15 == 0 {
				self?.tableView.reloadData()
			}
		} )
	}
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 125.0 // set to whatever your "average" cell height is
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
		
		cell.title?.text = movie.title
		cell.posterPath?.text = movie.poster_path
		cell.overview?.text = movie.overview
		
		cell.poster?.image = nil  // make sure we start fresh  :)

		
		guard let urlAsString = movie.posterURL(width: 200) else {
			return cell
		}
		
		DispatchQueue.global(qos: .userInitiated).async {
			if let url = URL(string: urlAsString) {
				guard let data = try? Data(contentsOf: url ) else {
					return
				}
				
				DispatchQueue.main.async {
					cell.poster?.image = UIImage(data: data)
				}
			}
		}
		
				
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
