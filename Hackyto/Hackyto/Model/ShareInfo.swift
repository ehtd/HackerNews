//
//  ShareInfo.swift
//  Hackyto
//
//  Created by Ernesto Torres on 12/29/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import Foundation
import UIKit

class ShareInfo: NSObject, UIActivityItemSource {
    var news: String
    var url : String
    
    init(news: String, url: String) {

        self.news = news
        self.url = url
    }
    
    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        NSLog("Place holder")
        return news;
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        NSLog("Place holder itemForActivity")
        
        if(activityType == UIActivityTypeCopyToPasteboard){
            return url
        } else {
            return news + " " + url + " via Hackyto"
        }

    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        NSLog("Place holder subjectForActivity")
        return news

    }
}