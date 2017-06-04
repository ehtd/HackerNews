//
//  HackerNewsAPI.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class HackerNewsAPI {
    fileprivate let baseURL = "https://hacker-news.firebaseio.com/v0/"
    
    fileprivate let topStoriesPath = "topstories.json"
    fileprivate let newStoriesPath = "newstories.json"
    fileprivate let askStoriesPath = "askstories.json"
    fileprivate let showStoriesPath = "showstories.json"
    fileprivate let jobStoriesPath = "jobstories.json"

    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate let contentProvider: ContentProvider

    // Add pagination
    init(for type: ContentType) {
        let contentPath: String
        switch type {
        case .top:
            contentPath = topStoriesPath

        case .news:
            contentPath = newStoriesPath

        case .ask:
            contentPath = askStoriesPath

        case .show:
            contentPath = showStoriesPath

        case .jobs:
            contentPath = jobStoriesPath
        }

        contentProvider = ContentProvider(with: session, apiEndPoint: baseURL, contentPath: contentPath)
    }
}

extension HackerNewsAPI {
    func topStories(success: @escaping (([Story]) -> Void),
                      error: @escaping ((Error) -> Void)) {
        contentProvider
            .onError(error: error)
            .onSuccess(success: success)
            .getStories(10)
    }
}
