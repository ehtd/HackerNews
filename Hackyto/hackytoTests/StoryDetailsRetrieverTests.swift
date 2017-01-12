//
//  StoryDetailsRetrieverTests.swift
//  Hackyto
//
//  Created by Ernesto Torres on 1/11/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import XCTest

class StoryDetailsRetrieverTests: XCTestCase {

    func testRetrieveStoryDetails() {
        let storyId = "10483024"
        
        let retriever = StoryDetailsRetriever()
        
        let exp = expectation(description: "retrieveComplete")
        
        retriever.retrievedStoryDetailsCompleted = { (story) in
            print(story.title)
            XCTAssert(story.title != "")
            exp.fulfill()
        }
        
        retriever.retrievedStoryDetailsFailed = { (error) in
            print(error)
            XCTFail("Failed to Retrieve")
            exp.fulfill()
        }
        
        retriever.retrieve(storyId: storyId)
        
        waitForExpectations(timeout: 2.0) { (error) in
            XCTAssertNil(error)
        }
    }
}
