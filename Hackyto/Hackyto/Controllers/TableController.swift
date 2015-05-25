//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit
import Refresher

class TableController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    let objectsFactory = ObjectsFactory()
    let retriever = RetrieverManager()
    
    var topStories: NSMutableArray? = nil
    var detailedStories = [String: NSDictionary]()

    let cellIdentifier = "StoryCell"

    

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                        selector: "onContentSizeChange:",
                                                        name: UIContentSizeCategoryDidChangeNotification,
                                                        object: nil)
        
        self.setNeedsStatusBarAppearanceUpdate()
        tableView.separatorColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 130.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        retriever.didFinishLoadingTopStories = didFinishLoadingTopStories
        retriever.didFailedLoadingTopStories = didFailedLoading
        
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {

                self.retriever.retrieveTopStories();
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
        var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! StoryCell
        self.configureBasicCell(cell, indexPath: indexPath)

        // Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();
        
        return cell
    }
    
    func configureBasicCell(cell: StoryCell, indexPath: NSIndexPath){
        var storyId: AnyObject = topStories!.objectAtIndex(indexPath.row)
        
        let key = "\(storyId)"
        var story = detailedStories[key]
        
        if let titleObject: AnyObject = story?.objectForKey("title") {
            if let authorObject: AnyObject = story?.objectForKey("by") {
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "\(authorObject)", storyKey: key)
            }
            else {
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "", storyKey: key)
            }
        }
        
        if let kids: NSArray = story?.objectForKey("kids") as! NSArray? {
            println(kids.count)
            cell.configureComments(comments: kids)
        }
        
        cell.launchComments = openStoryComments
    }
    
    // MARK: TableView Delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath = tableView.indexPathForSelectedRow()
        var index: Int = indexPath!.row
        var storyId: AnyObject = topStories!.objectAtIndex(index)
        
        let key = "\(storyId)"
        var story = detailedStories[key]

        var controller = segue.destinationViewController as! WebViewController
        controller.story = story
    }

    // MARK: Open Comments Closure
    
    var openStoryComments: ((key: String) -> ()) {
        get {
            return { [weak self] (key: String) ->() in
                if let strongSelf = self {
                    
                    var story = strongSelf.detailedStories[key]

                    let webViewController = strongSelf.objectsFactory.webViewController
                    webViewController.story = story
                    webViewController.hnCommentsURL = Constants.hackerNewsBaseURLString+"\(key)"
                    strongSelf.navigationController?.pushViewController(webViewController, animated: true)
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
                    println("All data is ready")
                    println("Total stories: \(strongSelf.detailedStories.count)")
                    //                println("Detailed stories: \(self.detailedStories)")
                    strongSelf.tableView.reloadData()
                    
                    // For some reason, the first displayed rows may not have
                    // the correct sizing. Reload them.
                    strongSelf.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, strongSelf.tableView.numberOfSections())), withRowAnimation: .None)
                }
            }
        }
    }
    
    var didFailedLoading: (() ->()) {
        get {
            return { [weak self] in
                if let strongSelf = self {
                    strongSelf.tableView.stopPullToRefresh()
                    println("Failed to download data")
                }
            }
        }
    }
    

}

