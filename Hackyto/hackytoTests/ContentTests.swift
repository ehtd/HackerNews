//
//  ContentTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class ContentTests: XCTestCase {
    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var topContent: TopContent?

    override func setUp() {
        super.setUp()
        topContent = TopContent(with: session, apiEndPoint: apiEndPoint)
    }

    func testFetchingTopStories() {
        let exp = expectation(description: "Fetch a list of stories")

        topContent?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(100)

        waitForExpectations(timeout: 50.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
