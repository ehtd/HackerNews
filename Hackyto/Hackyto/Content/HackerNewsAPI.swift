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

    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate let topContent: Content

    init() {
        topContent = Content(with: session, apiEndPoint: baseURL, contentPath: topStoriesPath)
    }
}

extension HackerNewsAPI {
    func topStories(success: @escaping (([Story]) -> Void),
                      error: @escaping ((Error) -> Void)) {
        topContent
            .onError(error: error)
            .onSuccess(success: success)
            .getStories(10)
    }
}
