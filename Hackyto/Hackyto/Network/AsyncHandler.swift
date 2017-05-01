//
//  AsyncHandler.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class AsyncHandler {
    private(set) var errorHandler: ((Error) -> Void) = { _ in }
    private(set) var successHandler: ((Any) -> Void) = { _ in }

    @discardableResult
    func onError(error: @escaping ((Error) -> Void)) -> Self {
        self.errorHandler = error

        return self
    }

    @discardableResult
    func onSuccess(success: @escaping (Any) -> Void) -> Self {
        self.successHandler = success
        
        return self
    }
}
