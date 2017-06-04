//
//  StoryDetailsFetcherTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class ItemFetcherTests: XCTestCase {
    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var itemFetcher: ItemFetcher?

    override func setUp() {
        itemFetcher = ItemFetcher(with: session, apiEndPoint: apiEndPoint)
    }
    
    func testFetchItem() {
        let storyId = "10483024"

        let exp = expectation(description: "Fetch item")

        itemFetcher?.getItem(for: "item/\(storyId).json", success: { (response) in
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
