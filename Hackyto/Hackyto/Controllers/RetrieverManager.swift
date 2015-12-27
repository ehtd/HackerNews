//
//  RetrieverManager.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class RetrieverManager {

    enum NewsType: Int {
        case Top = 0, News, Ask, Show, Jobs
    }

    static let supportedNewsType: Int = 5

    var topStories: NSMutableArray? = nil
    var detailedStories = [Int: NSDictionary]()
    
    var firebaseAPIString: String?

    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var didFinishLoadingTopStories: ((storyIDs: NSMutableArray?, stories: [Int: NSDictionary]) ->())?
    var didFailedLoadingTopStories: (() ->())?
    
    var pendingDownloads: Int = 0 {
        didSet {
//            println(pendingDownloads)
            if (pendingDownloads == 0){
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.didFinishLoadingTopStories?(storyIDs: self.topStories, stories: self.detailedStories)
                }
                
            }
        }
    }

    // MARK: Init

    init(type: NewsType)
    {
        switch type {
        case .Top:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/topstories"

        case .News:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/newstories"

        case .Ask:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/askstories"

        case .Show:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/showstories"

        case .Jobs:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/jobstories"
        }
    }

    // MARK: Retrieve Top Stories Methods
    
    func retrieveTopStories()
    {
        let topStoriesRef = Firebase(url:firebaseAPIString)
        topStoriesRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            self.topStories = snapshot.value as? NSMutableArray
            self.detailedStories = [Int: NSDictionary]()

            if let topStories = self.topStories {
                self.retrieveStories(startingIndex: 0, endingIndex: 10)
            }

            }, withCancelBlock: { error in
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.didFailedLoadingTopStories
                }
                print(error.description, terminator: "")
        })
    }
    
    func retrieveStories(startingIndex from:Int, endingIndex to:Int)
    {
        assert(from <= to, "From should be less than To")
        guard let topStories = self.topStories else { return }

        self.pendingDownloads = to-from
        
        for (var i = from; i < to; i++)
        {
            let item = topStories.objectAtIndex(i) as! Int
            self.retrieveStoryWithId(item)
        }
    }
    
    // MARK: Retrieve single story methods
    
    func retrieveStoryWithId(storyId: Int)
    {
        // 10483024
        let itemURL = retrieveItemAPIString + String(storyId)
        let storyRef = Firebase(url:itemURL)
        
        storyRef.observeSingleEventOfType(.Value,
            withBlock: { snapshot in
                if snapshot.exists() == true {

                    let details = snapshot.value as? [NSString: AnyObject]

                    if let details = details {
                        let keyNumber = details["id"] as? NSNumber

                        if let key = keyNumber?.integerValue {
                            self.pendingDownloads--
                            self.detailedStories[key] = details
                        }
                    }
                } else {
                    print("FIREBASE FAILED TO RETRIEVE SNAPSHOT")
                    self.cleanStoryIdFromPendingDownloads(storyId)
                }
            },
            withCancelBlock: { error in
                print(error.description, terminator: "")
                self.cleanStoryIdFromPendingDownloads(storyId)
        })
    }
    
    func cleanStoryIdFromPendingDownloads(storyId: Int) {
        self.topStories!.removeObject(storyId)
        self.pendingDownloads--
    }
}

