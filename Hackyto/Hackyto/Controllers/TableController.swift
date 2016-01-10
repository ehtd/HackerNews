//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class TableController: UITableViewController {

    let retriever: RetrieverManager
    var topStories: NSMutableArray?
    var detailedStories = [Int: NSDictionary]()

    let pullToRefresh = UIRefreshControl()

    let cellIdentifier = "StoryCell"

    static var colorIndex = 0

    let contentType: RetrieverManager.NewsType
    
    // MARK: Init

    init(type: RetrieverManager.NewsType) {
        self.retriever = RetrieverManager(type: type)
        self.contentType = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.retriever = RetrieverManager(type: RetrieverManager.NewsType.Top)
        self.contentType = RetrieverManager.NewsType.Top
        super.init(coder: aDecoder)
    }
    
    // MARK: View Controller Life Cycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.retriever.didFinishLoadingTopStories = didFinishLoadingTopStories
        self.retriever.didFailedLoadingTopStories = didFailedLoading

        addStylesToTableView()
        addPullToRefresh()

        self.retrieveStories()
    }
    
    // MARK: Styles Configuration

    func addStylesToTableView() {
        self.view.backgroundColor = ColorFactory.darkGrayColor()
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = ColorFactory.darkGrayColor()

        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 130.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: Pull to Refresh

    func addPullToRefresh() {
        self.pullToRefresh.backgroundColor = ColorFactory.colorFromNumber(TableController.colorIndex)
        self.pullToRefresh.tintColor = UIColor.whiteColor()
        self.pullToRefresh.addTarget(self, action: "retrieveStories", forControlEvents: UIControlEvents.ValueChanged)

        self.tableView.addSubview(pullToRefresh)
        self.tableView.contentOffset = CGPointMake(0, -self.pullToRefresh.frame.size.height)
        self.pullToRefresh.beginRefreshing()
    }

    func stopPullToRefresh() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                strongSelf.pullToRefresh.endRefreshing()
                strongSelf.updatePullToRefreshColor()
            }
        }
    }

    func updatePullToRefreshColor() {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                TableController.colorIndex++
                strongSelf.pullToRefresh.backgroundColor = ColorFactory.colorFromNumber(TableController.colorIndex)
            }
        }
    }

    func retrieveStories() {
        self.retriever.retrieveTopStories()
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
                    cell.configureCell(title: String(titleObject), author: String(authorObject), storyKey: storyId, number: indexPath.row + 1)
                }
                else {
                    cell.configureCell(title: String(titleObject), author: "", storyKey: storyId, number: indexPath.row + 1)
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
                    strongSelf.stopPullToRefresh()

                    print("All data is ready")
                    print("Total stories: \(strongSelf.detailedStories.count)")
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
                    strongSelf.stopPullToRefresh()
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

                let webViewController = SVModalWebViewController(URLRequest: request)
                webViewController.barsTintColor = ColorFactory.darkGrayColor()
                
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    if let strongSelf = self {
                        strongSelf.presentViewController(webViewController, animated: true, completion: nil)
                    }
                })
            }
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}

