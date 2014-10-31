//
//  WebViewController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/29/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit
import MessageUI

class WebViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var story: NSDictionary?
    
    var hud: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.mode = MBProgressHUDModeIndeterminate
        
        let url: String? = story?.objectForKey("url") as? String
        println(story)

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
    
    @IBAction func openComposer(){

        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var composer = appDelegate.composer()
        
        if MFMailComposeViewController.canSendMail() && composer != nil{
            
            composer!.mailComposeDelegate = self
            
            let storyTitle: String? = story?.objectForKey("title") as? String
            if let title = storyTitle {
                composer!.setSubject(title)
            }
            
            let storyURL: String? = story?.objectForKey("url") as? String
            if let url = storyURL {
                var message = url+"\n\n (via Hackyto)"
                composer!.setMessageBody(message, isHTML: false)
            }
            
            self.navigationController?.presentViewController(composer!, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertView(title: "Error", message: "Mail Account not configured", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
        }
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
