//
//  Schema.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/1/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import UIKit

protocol Identifiable {
    var globalId: String { get }
}

protocol Resolvable {
    associatedtype type

    var successHandler: ((type) -> ()) { get }
    func onSuccess(success: @escaping (type) -> ()) -> Self

    func resolve()
}

class GraphableType: Resolvable, Identifiable {
    let globalId: String
    typealias type = Any

    private(set) var successHandler: ((type) -> ()) = { _ in }

    init(withId id: String) {
        globalId = id
    }

    func resolve() {
        successHandler([type]())
    }

    func onSuccess(success: @escaping (type) -> ()) -> Self {
        successHandler = success
        return self
    }
}

class GraphString: GraphableType {
    typealias type = String

    init() {
        super.init(withId: "GraphString")
    }

    override func resolve() {
        successHandler("")
    }
}

class GraphInt: GraphableType {
    typealias type = Int

    init() {
        super.init(withId: "GraphInt")
    }

    override func resolve() {
        successHandler(0)
    }
}

class QueryResolver {
    typealias resultSet = [String: Any]
    typealias queryDictionary = [String: [String]]

    private(set) var supportedTypes = [String: GraphableType]()

    private(set) var successHandler: (([String: Any]) -> ()) = { _ in }

    func add(type: GraphableType) {
        supportedTypes[type.globalId] = type
    }

    func query(_ queryDictionary: queryDictionary) {
        for (key, array) in queryDictionary {
            let type = supportedTypes[key]
            type?.onSuccess(success: { (result) in

                if let r = result as? resultSet {
                    var generatedResultSet = resultSet()
                    for item in array {
                        generatedResultSet[item] = r[item]
                    }
                    self.successHandler(generatedResultSet)
                }
            })
            .resolve()
        }
    }

    func onSuccess(success: @escaping ([String: Any]) -> ()) -> Self {
        successHandler = success
        return self
    }
}

class StoryType: GraphableType {
    typealias type = [String: Any]

    init() {
        super.init(withId: "Story")
    }

//    var fields: [String: GraphableType] = ["id": GraphString(),
//                                           "title": GraphString()]


    override func resolve() {
        successHandler(["id": 100, "title": "test", "by": "Some author", "score": 10, "url": "http://"])
    }
}
