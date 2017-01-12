//
//  RetrieverManager.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class RetrieverManager {

    let retriever: StoryIDRetriever
    var stories = Array<Int>()
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    let MaximumStoriesToDownload = 200
    
    
    var detailedStories = [Int: NSDictionary]()

    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var didFinishLoadingTopStories: ((_ storyIDs: Array<Int>?, _ stories: [Int: NSDictionary]) ->())?
    var didFailedLoadingTopStories: (() ->())?
    
    var retrievedStoryIDsCompleted: ((Array<Int>) -> ())?
    
    var pendingDownloads: Int = 0 {
        didSet {
            if (pendingDownloads == 0){
                OperationQueue.main.addOperation {
                    self.didFinishLoadingTopStories?(self.stories, self.detailedStories)
                }
            }
        }
    }

    // MARK: Init

    init(type: NewsType)
    {
        retriever = StoryIDRetriever(type: type)
    }

    // MARK: Internal
    
    internal func retrieve() {
        retriever.retrievedStoryIDsFailed = { [weak self] (error) in
            if let strongSelf = self {
                strongSelf.completionWithError(error: error)
            }
        }
        
        retriever.retrievedStoryIDsCompleted = { [weak self] (ids) in
            if let strongSelf = self {
                strongSelf.stories = ids
                
                if strongSelf.stories.count > 0 {
                    let storiesToDownload = min(strongSelf.MaximumStoriesToDownload, strongSelf.stories.count)
                    strongSelf.retrieveStories(startingIndex: 0, endingIndex: storiesToDownload)
                }
                else {
                    strongSelf.completionWithError(error: nil)
                }
            }
        }
        
        retriever.retrieve()
    }
    
    // MARK: Private
    
    private func completionWithError(error: Error?) {
        print(String(describing: error))
        if let closure = self.didFailedLoadingTopStories {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    // TODO: Refactor to remove Firebase
    
    // MARK: Retrieve Stories Methods
    
    private func retrieveStories(startingIndex from:Int, endingIndex to:Int) {
        assert(from <= to, "From should be less than To")
        
        self.pendingDownloads = to-from
        
        for i in from..<to {
            self.retrieveStoryWithId(stories[i])
        }
    }
    
    // MARK: Retrieve single story methods
    
    private func retrieveStoryWithId(_ storyId: Int) {
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
    
    private func cleanStoryIdFromPendingDownloads(_ storyId: Int) {
        if let index = stories.index(of: storyId) {
            stories.remove(at: index)
            pendingDownloads -= 1
        }
    }
}

