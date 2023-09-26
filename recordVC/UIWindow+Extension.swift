//
//  UIWindow + Extension.swift
//  
//
//  Created by Jimmy on 2018/10/24.
//  Copyright © 2018 SoftArts Inc. All rights reserved.
//

import UIKit

//找到目前使用者眼前的VC

extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }
    
    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            
        default:
            return viewController
        }
    }
}
