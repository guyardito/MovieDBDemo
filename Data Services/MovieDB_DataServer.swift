//
//  MovieDBQueryService.swift
//  MovieDBDemo
//
//  Created by Guy (main) on 4/22/19.
//  Copyright © 2019 Rich Life LLC. All rights reserved.
//

import Foundation
import Alamofire




//•Now Playing <https://developers.themoviedb.org/3/movies/get-now-playing>
//•Popular <https://developers.themoviedb.org/3/movies/get-popular-movies>
//•Top Rated <https://developers.themoviedb.org/3/movies/get-top-rated-movies>
//•Upcoming <https://developers.themoviedb.org/3/movies/get-upcoming>


enum MovieCategory : String {
	case NowPlaying = "Now Playing"
	case Popular = "Popular"
	case TopRated = "Top Rated"
	case Upcoming = "Upcoming"
	
}







class MovieDB_DataServer {
	
	
	typealias FetchCompletion = () -> ()

	
	
	static var shared = MovieDB_DataServer()
	
	private var loadersByCategory = [MovieCategory:MovieDB_PageLoader]()
	
	
	
	private func getCategoryLoaderFor(category:MovieCategory) -> MovieDB_PageLoader {
		var categoryLoader = loadersByCategory[category]
		
		if categoryLoader == nil {
			categoryLoader = MovieDB_PageLoader(category: category)
			loadersByCategory[category] = categoryLoader
		}
		
		return categoryLoader!
	}
	
	
	func numberOfEntriesFor(category:MovieCategory) -> Int {
		let categoryLoader = getCategoryLoaderFor(category: category)
		return categoryLoader.numberOfMovies
	}
	
	
	private func pageFor(category:MovieCategory, index:Int) -> Int {
		let categoryLoader = getCategoryLoaderFor(category: category)
		return categoryLoader.pageFor(itemIndex: index)
	}
	
	
	
	func fetch(category:MovieCategory, page:Int, doSynchronously:Bool=false, completion:FetchCompletion?=nil) {
		let categoryLoader = getCategoryLoaderFor(category: category)
		
		//categoryLoader.fetch_via_native(page: page, doSynchronously: doSynchronously, completion: completion)
		categoryLoader.fetch_via_Alamofire(page: page, doSynchronously: doSynchronously, completion: completion)
	}
	
	
	
	//	 this assumes that the first item is at index 0
	func fetch(category:MovieCategory, index:Int) {
		let categoryLoader = getCategoryLoaderFor(category: category)
		categoryLoader.fetch(at: index)
	}
	
	
	
	func getMovieFrom(category:MovieCategory, at index:Int) -> MovieInfo {
		let categoryLoader = getCategoryLoaderFor(category: category)
		return categoryLoader.item(at: index)
	}
}



/*
This class is intended to load the pages of data for one of the MovieDB categories.
Pages are requested on-demand and can be requested/loaded in any order

Note that the current requirements and design of the app are such that there is not a danger of multiple threads simultaneously making requests for data from the same category/URL.  Therefore method 'fetch' does not need any special protection.
*/

fileprivate class MovieDB_PageLoader {
	
	let apiKey = "b4f08cc8d958e1b0f9f17de17a588d3a"
	let language = "en-US"
	
	
	var category:MovieCategory
	
	let moviesPerPage = 20  // this defined by MovieDBAPI.  NB the last page may have less than 20
	
	var numberOfPages = 0
	var numberOfMovies = 0
	
	var slugMovie = MovieInfo(title: "(none)", posterPath: "(none)", overview: "(none)")
	
	var moviesByPage = [Int:[MovieInfo]]()
	
	
	let regionFilter:String? = nil  // NB use "US" for United States
	
	
	
	init(category:MovieCategory) {
		self.category = category
	}
	
	
	
	func pageFor(itemIndex:Int) -> Int {
		return 1 + (itemIndex / moviesPerPage)
	}
	
	
	
	
	func apiForCategory(category:MovieCategory) -> String {
		
		let baseURL = "https://api.themoviedb.org/3/movie/"
		var command = ""
		
		switch category {
		case .NowPlaying:
			command = "now_playing"
			
		case .Popular:
			command = "popular"
			
		case .TopRated:
			command = "top_rated"
			
		case .Upcoming:
			command = "upcoming"
		}
		
		let rv = baseURL + command
		
		return rv
	}
	
	
	
	func fetch_via_Alamofire(page:Int, doSynchronously:Bool=false, completion:MovieDB_DataServer.FetchCompletion?=nil)  {
		
		if moviesByPage[page] != nil {
			// we either already have the data or are already fetching it, so ignore request
			return
		}
		self.moviesByPage[page] = [MovieInfo]()
		
		
		let api = apiForCategory(category: category)
		
		let semaphore = DispatchSemaphore(value: 0)
		
		let parameters:[String:Any] = ["language": language, "api_key": apiKey, "page":page]
		
		Alamofire.request(api, method: .get, parameters: parameters /*, encoding: URLEncoding(destination: .queryString) */ )
			
			.validate { request, response, data in
				if response.statusCode >= 300 {
					if let delayString:String = response.allHeaderFields["Retry-After"] as? String {
						print("delay for \(delayString) seconds...")
						
						//print(response)
						if let delay = Double(delayString)  {
							DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
								self.fetch_via_Alamofire(page: page)
							}
						}
					}
					return .success
					
				} else {
					/*
					beyond scope of this project to do much error handling
					*/
					return .success
				}
			}
			
			.response {
				response in
				let data = response.data
				
				let decoder = JSONDecoder()
				do {
					let pagedMovies = try decoder.decode(PagedMovies.self, from: data!)
					
					self.numberOfPages = pagedMovies.numberOfPages
					self.numberOfMovies = pagedMovies.numberOfMovies
					
					self.moviesByPage[page] = pagedMovies.movies
					
					if completion != nil {
						completion!()
					}
					
					if doSynchronously {
						semaphore.signal()
					}
					
				} catch let error {
					print("ERROR JSON not formed according to expected schema from PagedMovies")
					print(error)
				}
				
		}
		
		
		if doSynchronously {
			_ = semaphore.wait(timeout: .distantFuture)
		}
	}
	
	
	
	
	
	let defaultSession = URLSession(configuration: .default)
	var errorMessage = ""
	
	
	func fetch_via_native(page:Int, doSynchronously:Bool=false, completion:MovieDB_DataServer.FetchCompletion?=nil)  {
		
		if moviesByPage[page] != nil {
			// we either already have the data or are already fetching it, so ignore request
			return
		}
		self.moviesByPage[page] = [MovieInfo]()
		
		var dataTask: URLSessionDataTask?
		
		let api = apiForCategory(category: category)
		var urlComponents = URLComponents(string:api)
		
		if regionFilter != nil {
			urlComponents?.query = "language=\(language)&region=\(regionFilter!)&api_key=\(apiKey)&page=\(page)"
		} else {
			urlComponents?.query = "language=\(language)&api_key=\(apiKey)&page=\(page)"
		}
		
		guard let url = urlComponents?.url else {
			print("ERROR error creating URLComponents from \(api)")
			return }
		
		//print("do \(url)")
		
		let semaphore = DispatchSemaphore(value: 0)
		
		
		dataTask = defaultSession.dataTask(with: url) { data, response, error in
			defer { dataTask = nil }
			
			if let error = error {
				self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
				print("ERROR: \(self.errorMessage)")
				
			} else if let data = data,
				let response = response as? HTTPURLResponse,
				response.statusCode == 200 {
				
				print("loaded \(data.count) bytes")
				
				let decoder = JSONDecoder()
				do {
					let pagedMovies = try decoder.decode(PagedMovies.self, from: data)
					
					self.numberOfPages = pagedMovies.numberOfPages
					self.numberOfMovies = pagedMovies.numberOfMovies
					
					self.moviesByPage[page] = pagedMovies.movies
					
					if completion != nil {
						completion!()
					}
					
				} catch let error {
					print("ERROR JSON not formed according to expected schema from PagedMovies")
					print(error)
				}
				
			} else {
				if let delayString:String = (response as? HTTPURLResponse)?.allHeaderFields["Retry-After"] as? String {
					print("delay for \(delayString) seconds...")
					
					//print(response)
					if let delay = Double(delayString)  {
						DispatchQueue.main.asyncAfter(deadline: .now() + delay ) {
							self.fetch_via_native(page: page)
						}
					}
				}
			}
			
			if doSynchronously {
				semaphore.signal()
			}
		}
		
		dataTask?.resume()
		
		if doSynchronously {
			_ = semaphore.wait(timeout: .distantFuture)
		}
	}
	
	
	
	// this assumes that the first item is at index 0
	func fetch(at index:Int) {
		let page = pageFor(itemIndex: index)
		
		fetch_via_native(page: page)
	}
	
	
	
	func item(at index:Int) -> MovieInfo {
		let page = pageFor(itemIndex: index)
		
		let numberOfMoviesOnPreviousPages = ( page - 1 ) * moviesPerPage
		
		guard let list = moviesByPage[page] else {
			slugMovie.overview = "no page loaded for movie at index \(index)"
			return slugMovie
		}
		
		
		let offset = index - numberOfMoviesOnPreviousPages
		
		
		guard list.count > offset else {
			slugMovie.overview = "index \(index) > page size \(list.count)"
			return slugMovie
		}
		
		
		return list[offset]
	}
	
	
	
}



