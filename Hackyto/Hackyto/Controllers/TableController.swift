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

    var topStories: NSMutableArray? = nil
    var detailedStories = [String: NSDictionary]()

    let cellIdentifier = "StoryCell"
    let firebaseAPIString = "https://hacker-news.firebaseio.com/v0/topstories"
    
    var pendingDownloads: Int = 0 {
        didSet {
//            println(pendingDownloads)
            if (pendingDownloads == 0){
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                    println("All data is ready")
                    println("Total stories: \(self.detailedStories.count)")
                    //                println("Detailed stories: \(self.detailedStories)")
                    self.tableView.reloadData()
                    
                    // For some reason, the first displayed rows may not have
                    // the correct sizing. Reload them.
                    self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections())), withRowAnimation: .None)
                }

            }
        }
    }
    
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
        
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                self.retrieveTopStories();

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
    
    func retrieveTopStories()
    {
        var topStoriesRef = Firebase(url:firebaseAPIString)
        topStoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            self.topStories = snapshot.value as? NSMutableArray
            self.detailedStories = [String: NSDictionary]()

            if (self.topStories != nil && self.topStories?.count > 0){
                self.retrieveStories(startingIndex: 0, endingIndex: 100)
            }
            
            }, withCancelBlock: { error in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
                println(error.description)
        })
    }
    
    func retrieveStoryWithId(storyId: String!)
    {
        var itemURL = "https://hacker-news.firebaseio.com/v0/item/" + storyId
        var storyRef = Firebase(url:itemURL)
        
        storyRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var details = snapshot.value as! [NSString: AnyObject]

            let key: AnyObject? = details["id"]

            if key != nil {
                self.detailedStories[("\(key!)")] = details
                self.pendingDownloads--
            }

            }, withCancelBlock: { error in
                println(error.description)
                var item = "\(storyId)".toInt()
                self.topStories!.removeObject(item!)
                self.pendingDownloads--
        })
    }
    
    func retrieveStories(startingIndex from:Int, endingIndex to:Int)
    {
        assert(from <= to, "From should be less than To")
        self.pendingDownloads = to-from
        if (self.topStories == nil)
        {
            return;
        }
        
        for (var i = from; i < to; i++)
        {
            let item: AnyObject = self.topStories!.objectAtIndex(i)
            let itemId = ("\(item)")
            self.retrieveStoryWithId(itemId)
        }
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
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "\(authorObject)")
            }
            else {
                cell.configureCell(title: "\(indexPath.row+1). \(titleObject)", author: "")
            }
        }
        
        if let kids: NSArray = story?.objectForKey("kids") as! NSArray? {
            println(kids.count)
            cell.configureComments(comments: kids)
        }
        
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

}

