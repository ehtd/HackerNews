//
//  RetrieverManager.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class RetrieverManager {
    
    var topStories: NSMutableArray? = nil
    var detailedStories = [String: NSDictionary]()
    
    let firebaseAPIString = "https://hacker-news.firebaseio.com/v0/topstories"
    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var didFinishLoadingTopStories: ((storyIDs: NSMutableArray?, stories: [String: NSDictionary]) ->())?
    var didFailedLoadingTopStories: (() ->())?
    
    var pendingDownloads: Int = 0 {
        didSet {
//            println(pendingDownloads)
            if (pendingDownloads == 0){
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.didFinishLoadingTopStories?(storyIDs: topStories, stories: detailedStories)
                }
                
            }
        }
    }
    
    // MARK: Retrieve Top Stories Methods
    
    func retrieveTopStories()
    {
        var topStoriesRef = Firebase(url:firebaseAPIString)
        topStoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            self.topStories = snapshot.value as? NSMutableArray
            self.detailedStories = [String: NSDictionary]()
            
            if (self.topStories != nil && self.topStories?.count > 0){
                self.retrieveStories(startingIndex: 0, endingIndex: 500)
            }
            
            }, withCancelBlock: { error in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.didFailedLoadingTopStories
                }
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
    
    // MARK: Retrieve single story methods
    
    func retrieveStoryWithId(storyId: String!)
    {
        var itemURL = retrieveItemAPIString + storyId
        var storyRef = Firebase(url:itemURL)
        
        storyRef.observeSingleEventOfType(.Value,
            withBlock: { snapshot in
                if snapshot.exists() == true {
                    var details = snapshot.value as! [NSString: AnyObject]
                    let key: AnyObject? = details["id"]
                    if key != nil {
                        let url = details["url"] as? String
                        
                        if (url == nil) // Ask HN does not provide base URL, use id to generate URL
                        {
                            details["url"] = Constants.hackerNewsBaseURLString+"\(key!)"
                        }

                        self.detailedStories[("\(key!)")] = details
                        self.pendingDownloads--
                    }
                } else {
                    println("FIREBASE FAILED TO RETRIEVE SNAPSHOT")
                    self.cleanStoryIdFromPendingDownloads(storyId)
                }
            },
            withCancelBlock: { error in
                println(error.description)
                self.cleanStoryIdFromPendingDownloads(storyId)
        })
    }
    
    func cleanStoryIdFromPendingDownloads(storyId: String){
        var item = "\(storyId)".toInt()
        self.topStories!.removeObject(item!)
        self.pendingDownloads--
    }
}

