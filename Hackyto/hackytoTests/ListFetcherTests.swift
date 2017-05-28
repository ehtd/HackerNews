//
//  ListFetcherTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/28/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class ListFetcherTests: XCTestCase {

    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var fetcher: ListFetcher?

    fileprivate let topStories = "topstories.json"

    override func setUp() {
        super.setUp()

        fetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
    }

    func testFetchingIDList() {
        let exp = expectation(description: "Fetch Top Stories List")
        fetcher?.getStoryList(for: topStories, success: { (list) in
            print(list)
            exp.fulfill()
        }, error: { (error) in
            XCTFail()
        })

        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
