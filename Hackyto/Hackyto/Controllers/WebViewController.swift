//
//  WebViewController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/29/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var url: String?
    
    var hud: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.mode = MBProgressHUDModeIndeterminate
        
        if let urlToLoad = url {
            var request = NSURLRequest(URL: NSURL(string: urlToLoad)!)
            webView.loadRequest(request)
            webView.delegate = self
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.hud?.hide(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hud?.hide(true)
    }

}
