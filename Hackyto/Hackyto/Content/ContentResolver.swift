//
//  ContentResolver.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/29/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class ContentResolver: AsyncHandler {
    static let BASE_URL = "https://hacker-news.firebaseio.com/v0/"

    let api = HackerNewsAPI(withEndpoint: BASE_URL)

    func start() {
        api.start()
    }

    func get(_ URI: String) {
        api
            .onSuccess(success: successHandler)
            .onError(error: errorHandler)
            .resolve(URI)
    }
}
