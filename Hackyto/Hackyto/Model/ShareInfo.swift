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
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return news;
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        
        if(activityType == UIActivityTypeCopyToPasteboard){
            return url
        } else {
            return news + " " + url + " via Hackyto"
        }

    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        return news
    }
}