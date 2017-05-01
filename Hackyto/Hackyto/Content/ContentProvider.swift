//
//  ContentProvider.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/1/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

class ContentProvider: AsyncHandler, Providable {
    func get() {
        fatalError("Subclass needs to implement this")
    }
}
