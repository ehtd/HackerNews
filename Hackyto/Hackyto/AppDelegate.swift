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
        self.window?.backgroundColor = ColorFactory.darkGrayColor()

        let tabBarController: UITabBarController = UITabBarController()

        var viewControllers: [UIViewController] = []

        for i in 0..<RetrieverManager.supportedNewsType {
            let type: RetrieverManager.NewsType = RetrieverManager.NewsType(rawValue: i)!
            let navigationController = UINavigationController(rootViewController: TableController(type: type))
            let textAttributes = [NSForegroundColorAttributeName: ColorFactory.lightColor()]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            viewControllers.append(navigationController)
        }

        tabBarController.viewControllers = viewControllers

        if let topTab = tabBarController.tabBar.items?[0] {
            topTab.image = UIImage(named: "top")
            topTab.title = "Top"
        }

        if let topTab = tabBarController.tabBar.items?[1] {
            topTab.image = UIImage(named: "news")
            topTab.title = "News"
        }

        if let topTab = tabBarController.tabBar.items?[2] {
            topTab.image = UIImage(named: "ask")
            topTab.title = "Ask"
        }

        if let topTab = tabBarController.tabBar.items?[3] {
            topTab.image = UIImage(named: "show")
            topTab.title = "Show"
        }

        if let topTab = tabBarController.tabBar.items?[4] {
            topTab.image = UIImage(named: "jobs")
            topTab.title = "Jobs"
        }

        configureAppearance()

        self.window?.rootViewController = tabBarController
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
        UINavigationBar.appearance().barTintColor = ColorFactory.darkGrayColor()
        UINavigationBar.appearance().tintColor = ColorFactory.belizeHoleColor()
        UINavigationBar.appearance().translucent = false

        UITabBar.appearance().tintColor = ColorFactory.darkGrayColor()
        UITabBar.appearance().barTintColor = ColorFactory.lightColor()
        UITabBar.appearance().translucent = false
    }
}

