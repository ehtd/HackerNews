//
//  Story.swift
//  Hackyto
//
//  Created by Ernesto Torres on 1/11/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class Story {
    
    var title: String = ""
    var author: String = ""
    var score: Int = 0
    var storyId: Int = 0
    var urlString: String?
    var comments = [Int]()
    
    convenience init(_ dictionary: NSDictionary) {
        self.init()
        title = stringFromKey(dictionary, key: "title")
        author = stringFromKey(dictionary, key: "by")
        urlString = dictionary["url"] as? String
        score = intFromKey(dictionary, key: "score")
        storyId = intFromKey(dictionary, key: "id")
        comments = intArrayFromKey(dictionary, key: "kids")
    }
    
    func stringFromKey(_ dictionary: NSDictionary, key: String) -> String {
        if let value = dictionary[key] as? String {
            return value
        }
        else {
            return ""
        }
    }
    
    func intFromKey(_ dictionary: NSDictionary, key: String) -> Int {
        if let value = dictionary[key] as? Int {
            return value
        }
        else {
            return 0
        }
    }
    
    func intArrayFromKey(_ dictionary: NSDictionary, key: String) -> [Int] {
        if let value = dictionary[key] as? [Int] {
            return value
        }
        else {
            return [Int]()
        }
    }
}
