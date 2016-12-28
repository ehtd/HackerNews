//
//  ObjectsFactory.swift
//  Hackyto
//
//  Created by Ernesto Torres on 5/24/15.
//  Copyright (c) 2015 ehtd. All rights reserved.
//

import Foundation

class ObjectsFactory {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var webViewController: WebViewController {
        get {
            return storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        }
    }
}
