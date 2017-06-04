//
//  ShareInfo.swift
//  Hackyto
//
//  Created by Ernesto Torres on 12/29/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import Foundation
import UIKit

@objc class ShareInfo: NSObject, UIActivityItemSource {
    var news: String
    var url : String
    
    init(news: String, url: String) {
        self.news = news
        self.url = url
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return news;
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        
        if(activityType == UIActivityType.copyToPasteboard){
            return url
        } else {
            return news + " " + url + " via Hackyto"
        }

    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        return news
    }
}
