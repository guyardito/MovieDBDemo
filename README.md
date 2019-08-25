# MovieDBDemo
simple demo of accessing the public APIs of TheMovieDB.org

![](MovieDB.gif)

### V2.0.3 Change Log
* Refactor names to improve consistency and clarity
* Add new class MovieDB_App to encapsulate global values (such as which categories to display)
* Add entry point to the storyboard
* Change data service to load by page number, on demand
* Change tableView to conform to UITableViewDataSourcePrefetching to enhance performance on large tables
* Add Cocoapods: Alamofire for networking, Kingfisher for image caching (including auto-saving images to a persistent store)
* Change loading so that data for a given table doesn't start loading until 'viewDidLoad' gets called on said table.


### Error Handling
Errors and exceptions are caught but, with lack of directive and in the interest of time, generally only result in an appropriate message being sent to the console.
However, should the data request have a "Retry-After" directive, that *will* be heeded and another request will be made after the specified number of seconds.

