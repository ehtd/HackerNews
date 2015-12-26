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

        let tabbar: UITabBarController = UITabBarController()

        var viewControllers: [UIViewController] = []

        for i in 0..<RetrieverManager.supportedNewsType {
            let type: RetrieverManager.NewsType = RetrieverManager.NewsType(rawValue: i)!
            let navigationController = UINavigationController(rootViewController: TableController(type: type))
            let textAttributes = [NSForegroundColorAttributeName: ColorFactory.lightColor()]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            viewControllers.append(navigationController)
        }

        tabbar.viewControllers = viewControllers

        if let topTab = tabbar.tabBar.items?[0] {
            topTab.image = UIImage(named: "top")
            topTab.title = "Top"
        }

        if let topTab = tabbar.tabBar.items?[1] {
            topTab.image = UIImage(named: "news")
            topTab.title = "News"
        }

        if let topTab = tabbar.tabBar.items?[2] {
            topTab.image = UIImage(named: "ask")
            topTab.title = "Ask"
        }

        if let topTab = tabbar.tabBar.items?[3] {
            topTab.image = UIImage(named: "show")
            topTab.title = "Show"
        }

        if let topTab = tabbar.tabBar.items?[4] {
            topTab.image = UIImage(named: "jobs")
            topTab.title = "Jobs"
        }

        configureAppearance()

        self.window?.rootViewController = tabbar
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

    // MARK: Apperance configuration

    func configureAppearance() {
        UINavigationBar.appearance().barTintColor = ColorFactory.darkColor()
        UINavigationBar.appearance().tintColor = ColorFactory.blueColor()
        UINavigationBar.appearance().translucent = false

        UITabBar.appearance().tintColor = ColorFactory.blueColor()
        UITabBar.appearance().barTintColor = ColorFactory.darkColor()
        UITabBar.appearance().translucent = false
    }
}

