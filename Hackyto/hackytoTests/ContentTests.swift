//
//  ContentTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest
import Hermes

class ContentTests: XCTestCase {
    fileprivate let apiEndPoint = "https://hacker-news.firebaseio.com/v0/"

    fileprivate let topStoriesPath = "topstories.json"
    fileprivate let newStoriesPath = "newstories.json"
    fileprivate let askStoriesPath = "askstories.json"
    fileprivate let showStoriesPath = "showstories.json"
    fileprivate let jobStoriesPath = "jobstories.json"

    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)
    fileprivate var topContentProvider: ContentProvider?
    fileprivate var newsContentProvider: ContentProvider?
    fileprivate var askContentProvider: ContentProvider?
    fileprivate var showContentProvider: ContentProvider?
    fileprivate var jobContentProvider: ContentProvider?

    override func setUp() {
        super.setUp()
        topContentProvider = ContentProvider(with: session, apiEndPoint: apiEndPoint, contentPath: topStoriesPath)
        newsContentProvider = ContentProvider(with: session, apiEndPoint: apiEndPoint, contentPath: newStoriesPath)
        askContentProvider = ContentProvider(with: session, apiEndPoint: apiEndPoint, contentPath: askStoriesPath)
        showContentProvider = ContentProvider(with: session, apiEndPoint: apiEndPoint, contentPath: showStoriesPath)
        jobContentProvider = ContentProvider(with: session, apiEndPoint: apiEndPoint, contentPath: jobStoriesPath)
    }

    func testFetchingTopStories() {
        let exp = expectation(description: "Fetch a list of stories")

        topContentProvider?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(10)

        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testFetchingAskStories() {
        let exp = expectation(description: "Fetch a list of stories")

        askContentProvider?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(10)

        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testFetchingNewStories() {
        let exp = expectation(description: "Fetch a list of stories")

        newsContentProvider?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(10)

        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testFetchingShowStories() {
        let exp = expectation(description: "Fetch a list of stories")

        showContentProvider?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(10)

        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error)
        }
    }

    func testFetchingJobStories() {
        let exp = expectation(description: "Fetch a list of stories")

        jobContentProvider?
            .onError(error: { (_) in
                XCTFail()
            })
            .onSuccess(success: { (stories) in
                print(stories)
                exp.fulfill()
            })
            .getStories(10)

        waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
