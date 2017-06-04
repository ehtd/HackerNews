//
//  Fetcher.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class Fetcher: Fetchable {

    typealias responseType = Any
    
    let connector: HttpConnector
    let apiEndPoint: String

    init(with session: URLSession, apiEndPoint: String) {
        self.connector = HttpConnector(with: session)
        self.apiEndPoint = apiEndPoint
    }

    func fetch(_ segment: String, success: @escaping ((responseType) -> Void), error: @escaping ((Error) -> Void)) {
        connector
            .onSuccess(success: success)
            .onError(error: error)
            .get(withUrlPath: apiEndPoint + segment, headers: nil, body: nil)
    }
}
