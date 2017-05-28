//
//  HttpConnector.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class HttpConnector: AsyncHandler, Http {
    fileprivate let session: URLSession

    init(with session: URLSession) {
        self.session = session
    }

    func get(withUrlPath urlPath: String, headers: [String: String]?, body: String?) {
        let builder = requestBuilder(withUrlPath: urlPath, headers: headers, body: body)
        let request = builder.set(type: .GET).build()

        send(request)
    }
}

extension HttpConnector {
    func requestBuilder(withUrlPath urlPath: String, headers: [String: String]?, body: String?) -> RequestBuilder {
        let builder = RequestBuilder()
            .set(type: .GET)
            .set(urlString: urlPath)
            .set(headers: headers)
            .set(httpBodyFromString: body)

        return builder
    }
}

fileprivate extension HttpConnector {
    private func asyncSend(_ request: URLRequest) {
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

        DispatchQueue.main.async { [weak self] in
            if let response = apiResponse {
                self?.successHandler(response)
            } else if let error = apiError {
                self?.errorHandler(error)
            }
        }
    }

    func send(_ request: URLRequest) {
        DispatchQueue.global().async { [weak self] in
            self?.asyncSend(request)
        }
    }
}
