//
//  Fetchable.swift
//  Hackyto
//
//  Created by Ernesto Torres on 6/3/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

protocol Fetchable {
    associatedtype responseType
    func fetch(_ segment: String, success: @escaping ((responseType) -> Void), error: @escaping ((Error) -> Void))
}
