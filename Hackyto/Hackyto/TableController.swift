//
//  TableController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class TableController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var topStories: NSArray? = nil
    var detailedStories = [String: NSDictionary]()
    
    var pendingDownloads: Int = 0 {
        didSet {
            if (pendingDownloads == 0){
                self.hud?.hide(true)
                println("All data is ready")
                println("Total stories: \(self.detailedStories.count)")
//                println("Detailed stories: \(self.detailedStories)")
                self.tableView.reloadData()
            }
        }
    }
    
    var hud: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.mode = MBProgressHUDModeIndeterminate
        
        retrieveTopStories();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func retrieveTopStories()
    {
        var topStoriesRef = Firebase(url:"https://hacker-news.firebaseio.com/v0/topstories")
        
        topStoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            self.topStories = snapshot.value as? NSArray

            if (self.topStories != nil && self.topStories?.count > 0){
                
                self.retrieveStories(startingIndex: 0, endingIndex: 100)

            }
            
            }, withCancelBlock: { error in
                self.hud?.hide(true)
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

    // MARK: TableView Controller 
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailedStories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:StoryCell = self.tableView.dequeueReusableCellWithIdentifier("StoryCell") as StoryCell
        
        var storyId: AnyObject = topStories!.objectAtIndex(indexPath.row)

        let key = "\(storyId)"
        var story = detailedStories[key]

        let titleObject: AnyObject? = story?.objectForKey("title")
        let authorObject: AnyObject? = story?.objectForKey("by")
        
        cell.configureCell(title: "\(indexPath.row+1). \(titleObject!)", author: "\(authorObject!)")
        
        return cell
    }
    
}

