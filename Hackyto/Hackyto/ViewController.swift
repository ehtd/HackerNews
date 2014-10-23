//
//  ViewController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var topStories: NSArray? = nil;
    var detailedStories = [String: NSDictionary]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                self.retrieveStories(startingIndex: 0, endingIndex: 20)

            }
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
    func retrieveStoryWithId(storyId: String!)
    {
        var itemURL = "https://hacker-news.firebaseio.com/v0/item/" + storyId
        var storyRef = Firebase(url:itemURL)
        
        storyRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var details = snapshot.value as NSDictionary
            
            let key: AnyObject? = details["id"]

            self.detailedStories[("\(key)")] = details
            
            println("Total stories: \(self.detailedStories.count)")
            
            }, withCancelBlock: { error in
                println(error.description)
        })
        
    }
    
    func retrieveStories(startingIndex from:Int, endingIndex to:Int)
    {
        assert(from <= to, "From should be less than To")
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

}

