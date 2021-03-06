//
//  ContentProvider.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class ContentProvider {
    fileprivate let topListFetcher: ListFetcher
    fileprivate var itemFetchers = [ItemFetcher]()

    fileprivate let session: URLSession
    fileprivate let apiEndPoint: String

    typealias StoryList = [Story]
    fileprivate var stories = StoryList()
    fileprivate var availableStoryIds = [Int]()

    fileprivate(set) var errorHandler: ((Error) -> Void) = { _ in }
    fileprivate(set) var successHandler: ((StoryList) -> Void) = { _ in }

    fileprivate let contentPath: String
    fileprivate var fetching = false
    fileprivate let pageSize = 20

    init(with session: URLSession, apiEndPoint: String, contentPath: String) {
        self.contentPath = contentPath
        self.session = session
        self.apiEndPoint = apiEndPoint

        topListFetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
    }
}

fileprivate extension ContentProvider {
    func getStoryList(success: @escaping (([Int]) -> Void),
                           error: @escaping ((Error) -> Void)) {
        stories = StoryList()

        topListFetcher.fetch(contentPath, success: { (response) in
            if let response = response as? [Int] {
                success(response)
            }
        }, error: error)
    }

    func fetchItems(in list: [Int]) {
        itemFetchers = [ItemFetcher]()

        var stories = Array<Story?>(repeatElement(nil, count: list.count))

        var pendingItems = list.count
        let fetchCompleted: (() -> Void) = { [weak self] in
            pendingItems -= 1
            if pendingItems <= 0 {
                let fullStories = stories.filter { $0 != nil }.map { $0! }
                self?.fetching = false
                self?.successHandler(fullStories)
            }
        }

        var storyIndex = 0
        for item in list {
            let segment = "item/\(item).json"

            let fetcher = ItemFetcher(with: session, apiEndPoint: apiEndPoint)
            itemFetchers.append(fetcher)

            fetcher.fetch(segment, success: { [constIndex = storyIndex](response) in
                if let response = response as? [String: Any] {
                    let story = Story(response as NSDictionary)
                    stories[constIndex] = story
                    fetchCompleted()
                }
            }, error: { (error) in
                fetchCompleted()
            })

            storyIndex += 1
        }
    }

    func fetchNextBatch(size: Int) {
        if size < availableStoryIds.count {
            let truncatedList = Array(availableStoryIds[0..<size])
            availableStoryIds = Array(availableStoryIds[size..<availableStoryIds.count])

            fetchItems(in: truncatedList)
        }
        else {
            fetchItems(in: availableStoryIds)
            availableStoryIds.removeAll()
        }
    }
}

extension ContentProvider {
    @discardableResult
    func onError(error: @escaping ((Error) -> Void)) -> Self {
        self.errorHandler = error

        return self
    }

    @discardableResult
    func onSuccess(success: @escaping (StoryList) -> Void) -> Self {
        self.successHandler = success

        return self
    }
}

extension ContentProvider {
    func getStories(_ number: Int) {
        guard fetching == false else { return }

        fetching = true

        getStoryList(success: { [weak self] (list) in
            if let strongSelf = self {
                strongSelf.availableStoryIds = list
                strongSelf.fetchNextBatch(size: number)
            }
        }) { [weak self] (error) in
            self?.fetching = false
            self?.errorHandler(error)
        }
    }

    func next() {
        guard fetching == false, availableStoryIds.count > 0 else { return }

        fetching = true

        fetchNextBatch(size: pageSize)
    }
}
