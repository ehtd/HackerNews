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
                
                let firstObject: AnyObject = self.topStories!.objectAtIndex(0)
                
                let itemId = ("\(firstObject)")

                self.retrieveStoryWithId(itemId)
                
            }
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }
    
    func retrieveStoryWithId(storyId: String!)
    {
        println(storyId)
        
        var itemURL = "https://hacker-news.firebaseio.com/v0/item/" + storyId
        var storyRef = Firebase(url:itemURL)
        
        storyRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var details = snapshot.value as NSDictionary
            println(details)
            
            let key: AnyObject? = details["id"]

            self.detailedStories[("\(key)")] = details
            
            println(self.detailedStories)
            
            }, withCancelBlock: { error in
                println(error.description)
        })
        
    }

}

