//
//  ListFetcher.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/27/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class ListFetcher {
    let connector: HttpConnector
    let apiEndPoint: String

    init(with session: URLSession, apiEndPoint: String) {
        self.connector = HttpConnector(with: session)
        self.apiEndPoint = apiEndPoint
    }

    func getStoryList(for segment: String, success: @escaping (([Int]) -> Void), error: @escaping ((Error) -> Void)) {
        connector
            .onSuccess { (response) in
                guard let topStories = response as? [Int] else {
                    fatalError("Unexpected response")
                }

                success(topStories)
            }
            .onError(error: error)
            .get(withUrlPath: apiEndPoint + segment, headers: nil, body: nil)
    }
}
