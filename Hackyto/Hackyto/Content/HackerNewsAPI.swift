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

    fileprivate let itemFetcher: ItemFetcher

    init() {
        topListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        newsListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        askListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        showListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        jobListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        itemFetcher = ItemFetcher(with: session, apiEndPoint: apiEndPoint)
    }
}

extension HackerNewsAPI {
    func getTopStoryIDList(success: @escaping (([Int]) -> Void),
                           error: @escaping ((Error) -> Void)) {
        topListFetcher.getStoryList(for: "topstories.json", success: success, error: error)
    }

    func getItem(_ id: String,
                 success: @escaping (([String: Any]) -> Void),
                 error: @escaping ((Error) -> Void)) {
        itemFetcher.getItem(for: "item/\(id).json", success: success, error: error)
    }
}
