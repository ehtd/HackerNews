//
//  StoryDetailsRetriever.swift
//  Hackyto
//
//  Created by Ernesto Torres on 1/11/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class StoryDetailsRetriever {
    
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    let retrieveItemAPIString = "https://hacker-news.firebaseio.com/v0/item/"
    
    var retrievedStoryDetailsCompleted: ((Story) -> ())?
    var retrievedStoryDetailsFailed: ((Error) -> ())?
    
    func retrieve(storyId: String) {
        let storyURL = retrieveItemAPIString + storyId + ".json"
        
        if let url = URL(string: storyURL) {
            retrieveFromURLString(url: url)
        }
    }
    
    private func retrieveFromURLString(url: URL) {
        dataTask = defaultSession.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if let strongSelf = self {
                strongSelf.dataTask = nil
                
                if let error = error, let retrievedStoryDetailsFailed = strongSelf.retrievedStoryDetailsFailed {
                    DispatchQueue.main.async {
                        retrievedStoryDetailsFailed(error)
                    }
                }
                else {
                    let story = strongSelf.storyFromData(data: data)
                    
                    if let retrievedStoryDetailsCompleted = strongSelf.retrievedStoryDetailsCompleted {
                        DispatchQueue.main.async {
                            retrievedStoryDetailsCompleted(story)
                        }
                    }
                }
            }
        })
        
        dataTask?.resume()
    }
    
    private func storyFromData(data: Data?) -> Story {
        var storyData: NSDictionary?
        
        if let data = data {
            do {
                storyData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
            }
            catch {
                print(String(describing: error))
            }
            
            if let storyData = storyData {
                return Story(storyData)
            }
            else {
                return Story()
            }
        }
        else {
            return Story()
        }
    }
}
