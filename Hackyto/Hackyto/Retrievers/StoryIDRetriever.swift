//
//  StoryIDRetriever.swift
//  Hackyto
//
//  Created by Ernesto Torres on 1/11/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class StoryIDRetriever {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var firebaseAPIString: String?
    
    var retrievedStoryIDsCompleted: ((Array<Int>) -> ())?
    var retrievedStoryIDsFailed: ((Error) -> ())?
    
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
    
    func retrieve() {
        if let firebaseAPIString = firebaseAPIString {
            if let url = URL(string: firebaseAPIString) {
                retrieveFromURLString(url: url)
            }
        }
    }
    
    private func retrieveFromURLString(url: URL) {
        dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if let strongSelf = self {
                strongSelf.dataTask = nil
                
                if let error = error, let retrievedStoryIDsFailed = strongSelf.retrievedStoryIDsFailed {
                    DispatchQueue.main.async {
                        retrievedStoryIDsFailed(error)
                    }
                }
                else {
                    let storyIDs = strongSelf.itemsFromData(data: data)
                    
                    if let retrievedStoryIDsCompleted = strongSelf.retrievedStoryIDsCompleted {
                        DispatchQueue.main.async {
                            retrievedStoryIDsCompleted(storyIDs)
                        }
                    }
                }
            }
        })
        
        dataTask?.resume()
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
    
}
