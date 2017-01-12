//
//  hackytoTests.swift
//  hackytoTests
//
//  Created by Ernesto Torres on 1/11/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class StoryIDRetrieverTests: XCTestCase {
    
    func testRetrieveTopIDs() {
        let retriever = StoryIDRetriever(type: .top)
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryIDsCompleted = { (stories) in
            print(stories)
            XCTAssert(stories.count > 0 , "Retrieved stories are not > 0")
            exp.fulfill()
        }
        
        retriever.retrievedStoryIDsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve()
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRetrieveNewsIDs() {
        let retriever = StoryIDRetriever(type: .news)
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryIDsCompleted = { (stories) in
            print(stories)
            XCTAssert(stories.count > 0 , "Retrieved stories are not > 0")
            exp.fulfill()
        }
        
        retriever.retrievedStoryIDsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve()
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRetrieveAskIDs() {
        let retriever = StoryIDRetriever(type: .ask)
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryIDsCompleted = { (stories) in
            print(stories)
            XCTAssert(stories.count > 0 , "Retrieved stories are not > 0")
            exp.fulfill()
        }
        
        retriever.retrievedStoryIDsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve()
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRetrieveShowIDs() {
        let retriever = StoryIDRetriever(type: .show)
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryIDsCompleted = { (stories) in
            print(stories)
            XCTAssert(stories.count > 0 , "Retrieved stories are not > 0")
            exp.fulfill()
        }
        
        retriever.retrievedStoryIDsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve()
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testRetrieveJobsIDs() {
        let retriever = StoryIDRetriever(type: .jobs)
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryIDsCompleted = { (stories) in
            print(stories)
            XCTAssert(stories.count > 0 , "Retrieved stories are not > 0")
            exp.fulfill()
        }
        
        retriever.retrievedStoryIDsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve()
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
