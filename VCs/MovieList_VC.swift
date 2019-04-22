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
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 400.0 // set to whatever your "average" cell height is

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
		
		cell.title?.text = movie.title
		cell.posterPath?.text = movie.poster_path
		cell.overview?.text = movie.overview
		
		
		DispatchQueue.global(qos: .userInitiated).async {
			if movie.posterURL(width: 200) != nil {
				let url = URL(string: movie.posterURL(width: 200)!)
				do {
					if let data = try? Data(contentsOf: url!) {
						DispatchQueue.main.async {
							
							cell.poster?.image = UIImage(data: data)
						}
					} else {
						// something wrong with data, not much for us to do here yet
					}
				} catch {
					print(error.localizedDescription)
				}
				
			} else {
				cell.poster?.image = nil
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
