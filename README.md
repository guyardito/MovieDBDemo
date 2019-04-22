# MovieDBDemo
simple demo of accessing the public APIs of TheMovieDB.org



##CHALLENGES
Originally considered using a cocoapod for API access but the one that I found had an empty "Demo" directory, and given it was quite a large library it seemed like it would take more time to figure out how to use it than to just write code to go against the API

API didn't work when page # was the first parameter

API for image rejects most sizes



##NOTES
Created the viewControllers programmatically rather than thru storyboard b/c app is such that same view controller class is used four time, and includes a custom tableViewCell.  Going through storyboard would necessitate four viewController classes and four custom tableViewCells.  So, that's not great for maintenance.

Designed app so that all VCs begin loading when the app starts up, and pushed the longer ones down the tabbar so they can have a "head start" loading while the user is initially brought to one of the shorter lists.

Also, the title is periodically changed while loading to show progress; this is also reflected in the related tabBarItems.



##AREAS FOR EXTENSION / IMPROVEMENT
right now the UI is prone to jump/jitter while the user scrolls because the data takes a long time to load and (under current design) the table is given a 'reload' command after every page (typically 20 entries) is downloaded.  An effort has been made to mitigate this by only reloading after every 15 update signals

The data doesn't come back in any obvious order.  Sorting according to some criteria, perhaps user-specified, would be useful.  This would, however, present certain UI issues while the data is still being loaded.

caching of image to reduce data usage on subsequent runs

caching of movie lists to reduce lag on subsequent runs

not clear if it's better to start *all* downloads when app starts or just to start relevant download when ViewController is navigated to.  Pros and cons of each approach, would need to know more about goals and constraints.

code is fairly resilient but not absolutely bullet-proof; this could be improved (e.g. handling various download errors)

auto-layout seems good but didn't go crazy with it.  Actual layout OK on an iPhone X, but highly variable length of overview text makes the UI less-than-great.

might move the movie title over to the left but personally the benefit of that (not having title cut off) didn't outweigh the loss of text alignment symmetry to my eye

there might be a better way to download so many pages of data.  Considered a dispatch queue but for the scope of this assignment recursion seemed both sufficient and simpler.  There might be yet better approach; however, I don't personally have experience with that problem and my searching didn't yield any ideas so I just went with the straight-forward approach.
