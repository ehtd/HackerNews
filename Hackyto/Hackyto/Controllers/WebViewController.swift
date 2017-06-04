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
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud?.mode = MBProgressHUDModeIndeterminate
        
        var url: String? = nil
        if hnCommentsURL != nil {
            url = hnCommentsURL
        } else {
            url = story?.object(forKey: "url") as? String
        }
//        println(story)

        if let urlToLoad = url {
            let request = URLRequest(url: URL(string: urlToLoad)!)
            webView.loadRequest(request)
            webView.delegate = self
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hud?.hide(true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hud?.hide(true)
    }
    
    @IBAction func openComposer(){

        let storyTitle: String? = story?.object(forKey: "title") as? String
        if let title = storyTitle {
            let storyURL: String? = story?.object(forKey: "url") as? String
            if let url = storyURL {
                let info = ShareInfo(news: title, url: url)
                let vc = UIActivityViewController(activityItems: [info], applicationActivities: nil)
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                    popOverController = UIPopoverController(contentViewController: vc)
                    popOverController!.delegate = self
                    popOverController?.present(from: shareButton, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                    
                } else {
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
        }

    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: PopOverViewController Delegate Methods
    
    func popoverControllerDidDismissPopover(_ popoverController: UIPopoverController) {
        popOverController = nil
    }
}
