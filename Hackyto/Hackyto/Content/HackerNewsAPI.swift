//
//  HackerNewsAPI.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class HackerNewsAPI {
    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)

    fileprivate let topListFetcher: ListFetcher
    fileprivate let newsListFetcher: ListFetcher
    fileprivate let askListFetcher: ListFetcher
    fileprivate let showListFetcher: ListFetcher
    fileprivate let jobListFetcher: ListFetcher

    init() {
        self.topListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        self.newsListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        self.askListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        self.showListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        self.jobListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
    }
}

extension HackerNewsAPI {
    func getTopStoryIDList(success: @escaping (([Int]) -> Void), error: @escaping ((Error) -> Void)) {
        topListFetcher.getStoryList(for: "topstories.json", success: success, error: error)
    }
}
