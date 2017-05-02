//
//  Schema.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/1/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

protocol Graphable {
    associatedtype type
    func resolve() -> type
}

class GraphArray: Graphable {

    func resolve() -> [Any] {
        return [Any]()
    }
}

class GraphString: Graphable {
//    let object: [String: Any]

    func resolve() -> String {
        return ""
    }
}

class GraphInt: Graphable {
    func resolve() -> Int {
        return 0
    }
}

class StoryType {
    let name = "Story"
    let description = ""
    let fields = ["id": idField, "title": titleField]
//        "by", "score", "url"]

    func resolve(_ key: String) -> String {
        return ""
    }

    func idField() {

    }

    func titleField() {

    }

    private func landingAction() -> (() -> (Void)) {
        return { [weak self] in
            if let strongSelf = self {

            }
        }
    }
}

class Schema {
//    var object {
//
//    }

    typealias idType = (() -> String)

    func fields() {
        let def = ["key":""
            ]
    }

    func id(type: idType) {

    }
}

let schema = ["id": Int.self,
              "title": String.self,
              "by": String.self,
              "score": Int.self,
              "url": String.self
                ] as [String : Any]

//title = stringFromKey(dictionary, key: "title")
//author = stringFromKey(dictionary, key: "by")
//urlString = dictionary["url"] as? String
//score = intFromKey(dictionary, key: "score")
//storyId = intFromKey(dictionary, key: "id")
//comments = intArrayFromKey(dictionary, key: "kids")
//
//var title: String = ""
//var author: String = ""
//var score: Int = 0
//var storyId: Int = 0
//var urlString: String?
//var comments = [Int]()
