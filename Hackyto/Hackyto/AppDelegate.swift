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
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var window: UIWindow?

    var globalMailComposer: MFMailComposeViewController? = nil

    var previousController: UINavigationController? = nil;
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = ColorFactory.darkGrayColor()

        let tabBarController: UITabBarController = UITabBarController()
        tabBarController.delegate = self

        var viewControllers: [UIViewController] = []
        
        for i in 0..<ContentType.count {
            let type: ContentType = ContentType(rawValue: i)!
            let navigationController = UINavigationController(rootViewController: TableController(type: type))
            let textAttributes = [NSForegroundColorAttributeName: ColorFactory.lightColor()]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            viewControllers.append(navigationController)
        }

        tabBarController.viewControllers = viewControllers

        let tabBarImageNames = ["top", "new", "ask", "show", "jobs"]
        let tabBarTitles = tabBarImageNames.map { $0.capitalized }
        
        for i in 0..<viewControllers.count {
            if let tab = tabBarController.tabBar.items?[i] {
                tab.image = UIImage(named: tabBarImageNames[i])
                tab.title = tabBarTitles[i]
            }
        }
        
        configureAppearance()

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = tabBarController.viewControllers?[tabBarController.selectedIndex] as? UINavigationController else {
            return
        }
        
        let canScrollToTop = navigationController == previousController
        if let tableViewController = navigationController.topViewController as? UITableViewController, canScrollToTop {
            tableViewController.tableView.setContentOffset(.zero, animated: true)
        }
        
        previousController = navigationController
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
        UINavigationBar.appearance().isTranslucent = false

        UITabBar.appearance().tintColor = ColorFactory.darkGrayColor()
        UITabBar.appearance().barTintColor = ColorFactory.lightColor()
        UITabBar.appearance().isTranslucent = false

        UIToolbar.appearance().barTintColor = ColorFactory.lightColor()
        UIToolbar.appearance().tintColor = ColorFactory.darkGrayColor()
    }
}

