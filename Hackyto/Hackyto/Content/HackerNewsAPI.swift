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
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate let topContent: TopContent

    init() {
        topContent = TopContent(with: session, apiEndPoint: baseURL)

    }
}

extension HackerNewsAPI {

}
