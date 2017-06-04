//
//  RetrieverManager.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class RetrieverManager {

    let idRetriever: StoryIDRetriever
    let storyDetailsRetriever: StoryDetailsRetriever
    
    var storiesIds = Array<Int>()
    var detailedStories = [Int: Story]()


    let MaximumStoriesToDownload = 200
    
    var didFinishLoadingTopStories: ((_ storyIDs: Array<Int>?, _ stories: [Int: Story]) ->())?
    var didFailedLoadingTopStories: (() ->())?
    
    var retrievedStoryIDsCompleted: ((Array<Int>) -> ())?
    
    var pendingDownloads: Int = 0 {
        didSet {
            if (pendingDownloads == 0){
                OperationQueue.main.addOperation {
                    self.didFinishLoadingTopStories?(self.storiesIds, self.detailedStories)
                }
            }
        }
    }

    // MARK: Init

    init(type: NewsType)
    {
        idRetriever = StoryIDRetriever(type: type)
        storyDetailsRetriever = StoryDetailsRetriever()
    }

    // MARK: Internal
    
    internal func retrieve() {
        idRetriever.retrievedStoryIDsFailed = { [weak self] (error) in
            if let strongSelf = self {
                strongSelf.completionWithError(error: error)
            }
        }
        
        idRetriever.retrievedStoryIDsCompleted = { [weak self] (ids) in
            if let strongSelf = self {
                strongSelf.storiesIds = ids
                strongSelf.detailedStories = [Int: Story]()

                if strongSelf.storiesIds.count > 0 {
                    let storiesToDownload = min(strongSelf.MaximumStoriesToDownload, strongSelf.storiesIds.count)
                    strongSelf.retrieveStories(startingIndex: 0, endingIndex: storiesToDownload)
                }
                else {
                    strongSelf.completionWithError(error: nil)
                }
            }
        }
        
        idRetriever.retrieve()
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
    
    // MARK: Retrieve Stories Methods
    
    private func retrieveStories(startingIndex from:Int, endingIndex to:Int) {
        assert(from <= to, "From should be less than To")
        
        pendingDownloads = to-from
        
        for i in from..<to {
            retrieveStoryDetails(storiesIds[i])
        }
    }
    
    private func retrieveStoryDetails(_ storyId: Int) {
        storyDetailsRetriever.retrievedStoryDetailsCompleted = { [weak self] (story) in
            if let strongSelf = self {
                strongSelf.pendingDownloads -= 1
                strongSelf.detailedStories[story.storyId] = story
            }
        }
        
        storyDetailsRetriever.retrievedStoryDetailsFailed = { [weak self] (error) in
            if let strongSelf = self {
                print("Failed to retrieve story details")
                strongSelf.cleanStoryIdFromPendingDownloads(storyId)
            }
        }
        
        storyDetailsRetriever.retrieve(storyId: String(describing:storyId))
    }
    
    private func cleanStoryIdFromPendingDownloads(_ storyId: Int) {
        if let index = storiesIds.index(of: storyId) {
            storiesIds.remove(at: index)
            pendingDownloads -= 1
        }
    }
}

