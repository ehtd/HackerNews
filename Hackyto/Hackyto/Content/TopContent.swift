//
//  TopContent.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/29/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class TopContent: ContentProvider {
    static let SEGMENT = "topstories"

    let contentFormat = ".json"
    let driver = HttpDriver()
    let endPoint: String

    init(withEndpoint endPoint: String) {
        self.endPoint = endPoint
    }
    
    override func get() {
        driver
            .onSuccess(success: successHandler)
            .onError(error: errorHandler)
            .get(withUrlPath: endPoint + TopContent.SEGMENT + contentFormat, headers: nil, body: nil)
    }
}
