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
        case top = 0, news, ask, show, jobs
    }

    let MaximumStoriesToDownload = 200
    
    static let supportedNewsType: Int = 5

    var topStories: NSMutableArray? = nil
    var detailedStories = [Int: NSDictionary]()
    
    var firebaseAPIString: String?

    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var didFinishLoadingTopStories: ((_ storyIDs: NSMutableArray?, _ stories: [Int: NSDictionary]) ->())?
    var didFailedLoadingTopStories: (() ->())?
    
    var pendingDownloads: Int = 0 {
        didSet {
//            println(pendingDownloads)
            if (pendingDownloads == 0){
                OperationQueue.main.addOperation {
                    self.didFinishLoadingTopStories?(self.topStories, self.detailedStories)
                }
                
            }
        }
    }

    // MARK: Init

    init(type: NewsType)
    {
        switch type {
        case .top:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/topstories"

        case .news:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/newstories"

        case .ask:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/askstories"

        case .show:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/showstories"

        case .jobs:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/jobstories"
        }
    }

    // MARK: Retrieve Top Stories Methods
    
    func retrieveTopStories()
    {
        let topStoriesRef = Firebase(url:firebaseAPIString)
        topStoriesRef?.observeSingleEvent(of: .value, with: { snapshot in
            
            self.topStories = snapshot?.value as? NSMutableArray
            self.detailedStories = [Int: NSDictionary]()

            if let topStories = self.topStories {
                let storiesToDownload = min(self.MaximumStoriesToDownload, topStories.count)
                self.retrieveStories(startingIndex: 0, endingIndex: storiesToDownload)
            }

            }, withCancel: { error in
                OperationQueue.main.addOperation {
                    if let closure = self.didFailedLoadingTopStories {
                        closure()
                    }
                }
                print(String(describing: error))
        })
    }
    
    func retrieveStories(startingIndex from:Int, endingIndex to:Int)
    {
        assert(from <= to, "From should be less than To")
        guard let topStories = self.topStories else { return }

        self.pendingDownloads = to-from
        
        for i in from...to {
            let item = topStories.object(at: i) as! Int
            self.retrieveStoryWithId(item)
        }
    }
    
    // MARK: Retrieve single story methods
    
    func retrieveStoryWithId(_ storyId: Int)
    {
        // 10483024
        let itemURL = retrieveItemAPIString + String(storyId)
        let storyRef = Firebase(url:itemURL)
        
        storyRef?.observeSingleEvent(of: .value,
            with: { snapshot in
                if snapshot?.exists() == true {

                    let details = snapshot?.value as? [NSString: AnyObject]

                    if let details = details {
                        let keyNumber = details["id"] as? NSNumber

                        if let key = keyNumber?.intValue {
                            self.pendingDownloads -= 1
                            self.detailedStories[key] = details as NSDictionary?
                        }
                    }
                } else {
                    print("FIREBASE FAILED TO RETRIEVE SNAPSHOT")
                    self.cleanStoryIdFromPendingDownloads(storyId)
                }
            },
            withCancel: { error in
                print(String(describing: error))
                self.cleanStoryIdFromPendingDownloads(storyId)
        })
    }
    
    func cleanStoryIdFromPendingDownloads(_ storyId: Int) {
        self.topStories!.remove(storyId)
        self.pendingDownloads -= 1
    }
}

