//
//  Http.swift
//  Hackyto
//
//  Created by Ernesto Torres on 4/30/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import Foundation

protocol Http {
    func get(withUrlPath urlPath: String, headers: [String: String]?, body: String?)
}
