//
//  WebViewController.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/29/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit
import MessageUI

class WebViewController: UIViewController, UIWebViewDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var story: NSDictionary?
    var hnCommentsURL: String?
    
    var hud: MBProgressHUD? = nil
    
    var popOverController: UIPopoverController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.hud?.mode = MBProgressHUDModeIndeterminate
        
        var url: String? = nil
        if hnCommentsURL != nil {
            url = hnCommentsURL
        } else {
            url = story?.objectForKey("url") as? String
        }
//        println(story)

        if let urlToLoad = url {
            let request = NSURLRequest(URL: NSURL(string: urlToLoad)!)
            webView.loadRequest(request)
            webView.delegate = self
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.hud?.hide(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hud?.hide(true)
    }
    
    @IBAction func openComposer(){

        let storyTitle: String? = story?.objectForKey("title") as? String
        if let title = storyTitle {
            let storyURL: String? = story?.objectForKey("url") as? String
            if let url = storyURL {
                let info = ShareInfo(news: title, url: url)
                let vc = UIActivityViewController(activityItems: [info], applicationActivities: nil)
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
                    popOverController = UIPopoverController(contentViewController: vc)
                    popOverController!.delegate = self
                    popOverController?.presentPopoverFromBarButtonItem(shareButton, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                    
                } else {
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                
            }
        }

    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: PopOverViewController Delegate Methods
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        popOverController = nil
    }
}
