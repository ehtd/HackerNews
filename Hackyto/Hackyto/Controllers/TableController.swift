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
    var offscreenCells: NSDictionary!
    var cellIdentifier = "StoryCell"

    var pendingDownloads: Int = 0 {
        didSet {
//            println(pendingDownloads)
            if (pendingDownloads == 0){
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.stopPullToRefresh()
                }
                println("All data is ready")
                println("Total stories: \(self.detailedStories.count)")
//                println("Detailed stories: \(self.detailedStories)")
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offscreenCells = NSDictionary()
        self.setNeedsStatusBarAppearanceUpdate()
        
        tableView.separatorColor = UIColor.clearColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                
                self.retrieveTopStories();

            }
            }, withAnimator: BeatAnimator())
        
        
        self.tableView.startPullToRefresh()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func retrieveTopStories()
    {

        println("R")
        var topStoriesRef = Firebase(url:"https://hacker-news.firebaseio.com/v0/topstories")
        
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
            
            var details = snapshot.value as [NSString: AnyObject]

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
        var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as StoryCell
        self.configureBasicCell(cell, indexPath: indexPath)

        //Seems sometimes the cell didn't update its height. Use to layout again.
        cell.layoutIfNeeded();
        
        return cell
    }
    
    func configureBasicCell(cell: StoryCell, indexPath: NSIndexPath){
        var storyId: AnyObject = topStories!.objectAtIndex(indexPath.row)
        
        let key = "\(storyId)"
        var story = detailedStories[key]
        
        let titleObject: AnyObject? = story?.objectForKey("title")
        let authorObject: AnyObject? = story?.objectForKey("by")
        
        cell.configureCell(title: "\(indexPath.row+1). \(titleObject!)", author: "\(authorObject!)")
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


        var controller = segue.destinationViewController as WebViewController
        controller.story = story


    }
    
    // MARK: Refresher
    
//    func 
}

