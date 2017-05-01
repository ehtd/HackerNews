//
//  HttpDriver.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class HttpDriver: AsyncHandler, Http {
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default)

    func get(withUrlPath urlPath: String, headers: [String: String]?, body: String?) {
        let request = RequestBuilder()
            .set(type: .GET)
            .set(urlString: urlPath)
            .set(headers: headers)
            .set(httpBodyFromString: body)
            .build()

        send(request)
    }
}

extension HttpDriver {
    func send(_ request: URLRequest) {
        var apiResponse : Any?
        var apiError : Error?
        let semaphore = DispatchSemaphore.init(value: 0)

        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                apiError = error
                semaphore.signal()
                return
            }

            do {
                apiResponse = try JSONSerialization.jsonObject(with: data)
            } catch let jsonError {
                apiError = jsonError
            }

            semaphore.signal()
        }

        task.resume()

        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)

        if let response = apiResponse {
            successHandler(response)
        } else if let error = apiError {
            errorHandler(error)
        }
    }
}
