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
            println(self.topStories)
            
            }, withCancelBlock: { error in
                println(error.description)
        })
    }

}

