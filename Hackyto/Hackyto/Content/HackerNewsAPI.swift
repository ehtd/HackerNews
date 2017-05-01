//
//  HackerNewsAPI.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class HackerNewsAPI: AsyncHandler {
    fileprivate let apiEndPoint: String
    fileprivate var routes = [String: ContentProvider]()

    init(withEndpoint endPoint: String) {
        self.apiEndPoint = endPoint
    }

    func start() {
        self.routes = [TopContent.SEGMENT: TopContent(withEndpoint: apiEndPoint)]
    }
}

// MARK: - Routes

extension HackerNewsAPI {
    func resolve(_ URI: String) {
        if let route = self.routes[URI] {
            route
                .onSuccess(success: successHandler)
                .onError(error: errorHandler)
                .get()
        } else {
            // TODO: route missing
        }
    }
}
