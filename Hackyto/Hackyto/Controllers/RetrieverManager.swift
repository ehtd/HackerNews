//
//  RetrieverManager.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class RetrieverManager {

    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    enum NewsType: Int {
        case top = 0, news, ask, show, jobs
    }

    let MaximumStoriesToDownload = 200
    
    static let supportedNewsType: Int = 5

    var topStories: Array<Int>? = nil
    var detailedStories = [Int: NSDictionary]()
    
    var firebaseAPIString: String?

    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var didFinishLoadingTopStories: ((_ storyIDs: Array<Int>?, _ stories: [Int: NSDictionary]) ->())?
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
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/topstories.json"

        case .news:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/newstories.json"

        case .ask:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/askstories.json"

        case .show:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/showstories.json"

        case .jobs:
            firebaseAPIString = "https://hacker-news.firebaseio.com/v0/jobstories.json"
        }
    }

    // MARK: Internal
    
    internal func retrieve() {
        if let firebaseAPIString = firebaseAPIString {
            self.retrieveFromURLString(URLString: firebaseAPIString)
        }
    }
    
    // MARK: Private
    
    private func retrieveFromURLString(URLString: String) {
        if let url = URL(string: URLString) {
            dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                if let strongSelf = self {
                    strongSelf.dataTask = nil
                    
                    if let error = error {
                        strongSelf.completionWithError(error: error)
                    }
                    else {
                        strongSelf.topStories = strongSelf.itemsFromData(data: data)
                        strongSelf.detailedStories = [Int: NSDictionary]()
                        
                        if let topStories = strongSelf.topStories, topStories.count > 0 {
                            let storiesToDownload = min(strongSelf.MaximumStoriesToDownload, topStories.count)
                            strongSelf.retrieveStories(startingIndex: 0, endingIndex: storiesToDownload)
                        }
                        else {
                            strongSelf.completionWithError(error: nil)
                        }
                    }
                }
            })
            
            dataTask?.resume()
        }
    }
    
    private func itemsFromData(data: Data?) -> Array<Int> {
        var items: Array<Int>?
        
        if let data = data {
            do {
                items = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? Array<Int>
            }
            catch {
                print(String(describing: error))
            }
            
            if let items = items {
                return items
            }
            else {
                return Array<Int>()
            }
        }
        else {
            return Array<Int>()
        }
    }
    
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
    
    func retrieveStories(startingIndex from:Int, endingIndex to:Int) {
        assert(from <= to, "From should be less than To")
        guard let topStories = self.topStories else { return }
        
        self.pendingDownloads = to-from
        
        for i in from..<to {
            self.retrieveStoryWithId(topStories[i])
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
        if let index = topStories?.index(of: storyId) {
            topStories?.remove(at: index)
            pendingDownloads -= 1
        }
    }
}

