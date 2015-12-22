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
    var detailedStories = [String: NSDictionary]()

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

        self.view.backgroundColor = ColorFactory.darkColor()
        self.tableView.backgroundView = nil
        self.tableView.backgroundColor = ColorFactory.darkColor()

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                        selector: "onContentSizeChange:",
                                                        name: UIContentSizeCategoryDidChangeNotification,
                                                        object: nil)
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.estimatedRowHeight = 136.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.tableView.registerNib(UINib(nibName: "StoryCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

        assert(self.retriever != nil, "self.retriever should not be nil, call convenience init")

        retriever!.didFinishLoadingTopStories = didFinishLoadingTopStories
        retriever!.didFailedLoadingTopStories = didFailedLoading
        
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {

                self.retriever!.retrieveTopStories();
            }
            }, withAnimator: BeatAnimator())
        
        self.tableView.startPullToRefresh()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
        return self.basicCellAtIndexPath(indexPath)
    }
    
    func basicCellAtIndexPath(indexPath: NSIndexPath) -> StoryCell {
        let cell: StoryCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! StoryCell
        
        self.configureBasicCell(cell, indexPath: indexPath)

        // Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();

        return cell
    }
    
    func configureBasicCell(cell: StoryCell, indexPath: NSIndexPath){
        let storyId: AnyObject = topStories!.objectAtIndex(indexPath.row)
        
        let key = "\(storyId)"
        let story = detailedStories[key]
        
        if let titleObject: AnyObject = story?.objectForKey("title") {
            if let authorObject: AnyObject = story?.objectForKey("by") {
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "\(authorObject)", storyKey: key)
            }
            else {
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "", storyKey: key)
            }
        }
        
        if let kids: NSArray = story?.objectForKey("kids") as! NSArray? {
//            println(kids.count)
            cell.configureComments(comments: kids)
        }
        
        cell.launchComments = openStoryComments
    }
    
    // MARK: TableView Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let index: Int = indexPath.row
        let storyId: AnyObject = topStories!.objectAtIndex(index)
        
        let key = "\(storyId)"
        let story = detailedStories[key]
        let url = story?.objectForKey("url") as? String
        let title = story?.objectForKey("title") as? String
        
        if let url = url {
            if let title = title {
                self.openWebBrowser(title: title, url: url)
            } else {
                self.openWebBrowser(title: "", url: url)
            }
        }
    }

    // MARK: Open Comments Closure
    
    var openStoryComments: ((key: String) -> ()) {
        get {
            return { [weak self] (key: String) ->() in
                if let strongSelf = self {
                    
                    let story = strongSelf.detailedStories[key]

                    let url = Constants.hackerNewsBaseURLString+"\(key)"
                    let title = story?.objectForKey("title") as? String
                    let hnComments = "HN comments"
                    
                    if let title = title {
                        strongSelf.openWebBrowser(title: title + " - " + hnComments, url: url)
                    } else {
                        strongSelf.openWebBrowser(title: hnComments, url: url)
                    }
                    

                }
            }
        }
    }
    
    // MARK: Retrieved data Closures
    
    var didFinishLoadingTopStories: ((storyIDs: NSMutableArray?, stories: [String: NSDictionary]) ->()) {
        get {
            return { [weak self] (storyIDs: NSMutableArray?, stories: [String: NSDictionary]) ->() in
                if let strongSelf = self {
                    strongSelf.topStories = storyIDs
                    strongSelf.detailedStories = stories
                    strongSelf.tableView.stopPullToRefresh()
                    print("All data is ready", terminator: "")
                    print("Total stories: \(strongSelf.detailedStories.count)", terminator: "")
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
    
    func openWebBrowser(title title: String, url: String) {
        let request:NSURLRequest = NSURLRequest(URL: NSURL(string: url)!)
        let webViewController = SVWebViewController(URLRequest: request, title: title)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}

