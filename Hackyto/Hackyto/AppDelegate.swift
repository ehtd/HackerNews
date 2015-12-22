//
//  AppDelegate.swift
//  Hackyto
//
//  Created by Ernesto Torres on 10/22/14.
//  Copyright (c) 2014 ehtd. All rights reserved.
//

import UIKit
import MessageUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var globalMailComposer: MFMailComposeViewController? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = ColorFactory.darkColor()

        let navigationController = UINavigationController(rootViewController: TableController())
        navigationController.navigationBar.translucent = false

        UINavigationBar.appearance().barTintColor = ColorFactory.darkColor()
        UINavigationBar.appearance().tintColor = ColorFactory.blueColor()

        let textAttributes = [NSForegroundColorAttributeName: ColorFactory.lightColor()]
        navigationController.navigationBar.titleTextAttributes = textAttributes

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }

    func composer() -> MFMailComposeViewController?{
        
        if MFMailComposeViewController.canSendMail() {
            globalMailComposer = nil
            globalMailComposer = MFMailComposeViewController()
            return globalMailComposer
        }
        
        return nil

    }
}

