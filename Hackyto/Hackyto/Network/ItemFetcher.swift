//
//  ItemFetcher.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class ItemFetcher {
    let connector: HttpConnector
    let apiEndPoint: String

    init(with session: URLSession, apiEndPoint: String) {
        self.connector = HttpConnector(with: session)
        self.apiEndPoint = apiEndPoint
    }

    func getItem(for segment: String,
                 success: @escaping (([String: Any]) -> Void),
                 error: @escaping ((Error) -> Void)) {
        connector
            .onSuccess { (response) in
                guard let item = response as? [String: Any] else {
                    fatalError("Unexpected response")
                }

                success(item)
            }
            .onError(error: error)
            .get(withUrlPath: apiEndPoint + segment, headers: nil, body: nil)
    }
}
