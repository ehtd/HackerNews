//
//  FetcherTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/28/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class FetcherTests: XCTestCase {

    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var fetcher: ListFetcher?
    fileprivate var itemFetcher: ItemFetcher?

    fileprivate let topStories = "topstories.json"
    fileprivate let storyId = "10483024"

    override func setUp() {
        super.setUp()

        fetcher = ListFetcher(with: session, apiEndPoint: apiEndPoint)
        itemFetcher = ItemFetcher(with: session, apiEndPoint: apiEndPoint)
    }

    func testFetchingIDList() {
        let exp = expectation(description: "Fetch Top Stories List")
        fetcher?.fetch(topStories, success: { (response) in
            print(response)
            exp.fulfill()
        }, error: { (_) in
            XCTFail()
        })

        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testFetchItem() {
        let exp = expectation(description: "Fetch item")

        itemFetcher?.fetch( "item/\(storyId).json", success: { (response) in
            print(response)
            exp.fulfill()
        }, error: { (_) in
            XCTFail()
        })

        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
