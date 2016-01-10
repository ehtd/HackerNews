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

        let tabBarImageNames = ["top", "news", "ask", "show", "jobs"]
        let tabBarTitles = tabBarImageNames.map { $0.capitalizedString }
        
        for i in 0..<viewControllers.count {
            if let tab = tabBarController.tabBar.items?[i] {
                tab.image = UIImage(named: tabBarImageNames[i])
                tab.title = tabBarTitles[i]
            }
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
        UINavigationBar.appearance().barTintColor = ColorFactory.lightColor()
        UINavigationBar.appearance().tintColor = ColorFactory.darkGrayColor()
        UINavigationBar.appearance().translucent = false

        UITabBar.appearance().tintColor = ColorFactory.darkGrayColor()
        UITabBar.appearance().barTintColor = ColorFactory.lightColor()
        UITabBar.appearance().translucent = false

        UIToolbar.appearance().barTintColor = ColorFactory.lightColor()
        UIToolbar.appearance().tintColor = ColorFactory.darkGrayColor()
    }
}

