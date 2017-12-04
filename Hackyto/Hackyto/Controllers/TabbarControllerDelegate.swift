//
//  TabbarControllerDelegate.swift
//  hackyto
//
//  Created by Ernesto Torres on 12/4/17.
//  Copyright © 2017 ehtd. All rights reserved.
//

import UIKit

class TabbarControllerDelegate: NSObject, UITabBarControllerDelegate {
    private var previousController: UINavigationController? = nil;
    
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
}
