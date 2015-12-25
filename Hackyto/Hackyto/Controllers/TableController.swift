//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit
import Refresher

class TableController: UITableViewController {

    var retriever: RetrieverManager?
    var topStories: NSMutableArray?
    var detailedStories = [Int: NSDictionary]()

    let cellIdentifier = "StoryCell"

    // MARK: Init

    convenience init(type: RetrieverManager.NewsType) {
        self.init()
        self.retriever = RetrieverManager(type: type)

        switch type {
        case .Top:
            self.title = "Top"

        case .News:
            self.title = "News"

        case .Ask:
            self.title = "Ask"

        case .Show:
            self.title = "Show"

        case .Jobs:
            self.title = "Jobs"
        }
    }

    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let retriever = self.retriever
        else {
            print("self.retriever should not be nil, call convenience init")
            return
        }

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onContentSizeChange:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)

        self.view.backgroundColor = ColorFactory.darkColor()
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = ColorFactory.darkColor()

        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 136.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.registerNib(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        retriever.didFinishLoadingTopStories = didFinishLoadingTopStories
        retriever.didFailedLoadingTopStories = didFailedLoading
        
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {

                retriever.retrieveTopStories();
            }
            }, withAnimator: BeatAnimator())
        
        self.tableView.startPullToRefresh()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func onContentSizeChange(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    // MARK: TableView Controller data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedStories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: StoryCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! StoryCell

        self.configureBasicCell(cell, indexPath: indexPath)

        // Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();

        return cell
    }

    func configureBasicCell(cell: StoryCell, indexPath: NSIndexPath){
        guard let topStories = topStories else { return }

        let storyId = topStories[indexPath.row] as? Int

        if let storyId = storyId {
            let story = detailedStories[storyId]

            if let titleObject: AnyObject = story?.objectForKey("title") {
                if let authorObject: AnyObject = story?.objectForKey("by") {
                    cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "\(authorObject)", storyKey: storyId)
                }
                else {
                    cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "", storyKey: storyId)
                }
            }

            if let kids = story?.objectForKey("kids") as? NSArray {
                cell.configureComments(comments: kids)
            }
        }

        cell.launchComments = openStoryComments
    }
    
    // MARK: TableView Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let topStories = topStories else { return }

        let storyId = topStories[indexPath.row] as? Int

        if let storyId = storyId {
            let story = detailedStories[storyId]

            var url = story?.objectForKey("url") as? String
            let title = story?.objectForKey("title") as? String
            let keyNumber = story?.objectForKey("id") as? NSNumber

            if url == nil { // Ask HN stories have this field empty
                if let key = keyNumber?.integerValue {
                    url = Constants.hackerNewsBaseURLString + String(key)
                }
            }

            self.openWebBrowser(title: title, urlString: url)
        }
    }

    // MARK: Open Comments Closure
    
    var openStoryComments: ((key: Int) -> ()) {
        get {
            return { [weak self] (key: Int) ->() in
                if let strongSelf = self {
                    
                    let story = strongSelf.detailedStories[key]

                    let url = Constants.hackerNewsBaseURLString + String(key)
                    let title = story?.objectForKey("title") as? String
                    let hnComments = "HN comments"
                    
                    if let title = title {
                        strongSelf.openWebBrowser(title: title + " - " + hnComments, urlString: url)
                    } else {
                        strongSelf.openWebBrowser(title: hnComments, urlString: url)
                    }
                }
            }
        }
    }
    
    // MARK: Retrieved data Closures
    
    var didFinishLoadingTopStories: ((storyIDs: NSMutableArray?, stories: [Int: NSDictionary]) ->()) {
        get {
            return { [weak self] (storyIDs: NSMutableArray?, stories: [Int: NSDictionary]) ->() in
                if let strongSelf = self {
                    strongSelf.topStories = storyIDs
                    strongSelf.detailedStories = stories
                    strongSelf.tableView.stopPullToRefresh()

                    if let title = strongSelf.title {
                        print("All data is ready (" + title + ")")
                    }

                    print("Total stories: \(strongSelf.detailedStories.count)")
                    //                println("Detailed stories: \(self.detailedStories)")
                    strongSelf.tableView.reloadData()
                    
                    // For some reason, the first displayed rows may not have
                    // the correct sizing. Reload them.
                    strongSelf.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, strongSelf.tableView.numberOfSections)), withRowAnimation: .None)
                }
            }
        }
    }
    
    var didFailedLoading: (() ->()) {
        get {
            return { [weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.stopPullToRefresh()
                    print("Failed to download data", terminator: "")
                }
            }
        }
    }
    
    // MARK: Helper Methods
    
    func openWebBrowser(title title: String?, urlString: String?) {
        if let urlString = urlString {
            let url = NSURL(string: urlString)

            if let url = url {
                let request:NSURLRequest = NSURLRequest(URL: url)
                let webViewController = SVWebViewController(URLRequest: request, title: title)
                self.navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }
}

