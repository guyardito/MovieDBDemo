//
//  MovieDBQueryService.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation



class MovieDBQueryService {
	
	typealias QueryResult = ([PagedMovies.Movie]?, Int, Int, String) -> ()
	
	
	let apiKey = "b4f08cc8d958e1b0f9f17de17a588d3a"
	let language = "en-US"
	
	
	
	let defaultSession = URLSession(configuration: .default)
	
	var dataTask: URLSessionDataTask?
	var movies: [PagedMovies.Movie] = []
	var errorMessage = ""
	
	var queryType:QueryType
	
	
	
	init(queryType:QueryType) {
		self.queryType = queryType
	}
	
	
	
	
	func getSearchResults(page:Int, pageLoaded: @escaping QueryResult) {
		//print("get page \(page)")
		
		dataTask?.cancel()
		
		var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/\(queryType.rawValue)")
		urlComponents?.query = "?language=\(language)&api_key=\(apiKey)&page=\(page)"
		
		guard let url = urlComponents?.url else { return }
		
		//print("do \(url)")
		
		dataTask = defaultSession.dataTask(with: url) { data, response, error in
			defer { self.dataTask = nil }
			
			if let error = error {
				self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				print("ERROR: \(self.errorMessage)")
				
			} else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				
				let decoder = JSONDecoder()
				let pagedMovies = try! decoder.decode(PagedMovies.self, from: data)
				
				self.movies = self.movies + pagedMovies.results
				
				if pagedMovies.page < pagedMovies.total_pages {
					DispatchQueue.main.async {
						pageLoaded(pagedMovies.results, pagedMovies.page, pagedMovies.total_pages, self.errorMessage)
					}
					
					self.getSearchResults(page: pagedMovies.page + 1, pageLoaded: pageLoaded )
					return
					
				} else {
					print("all done, \(self.movies.count) movies")
					DispatchQueue.main.async { pageLoaded(pagedMovies.results, pagedMovies.page, pagedMovies.total_pages, self.errorMessage) }
				}
				
			} else {
				if let delayString:String = (response as? HTTPURLResponse)?.allHeaderFields["Retry-After"] as? String {
					print("delay for \(delayString) seconds...")
					
					//print(response)
					let delay:Double = Double(delayString) as! Double
					DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
						self.getSearchResults(page: page, pageLoaded: pageLoaded )
					}
				}
			}
		}
		
		dataTask?.resume()
	}
	
}







