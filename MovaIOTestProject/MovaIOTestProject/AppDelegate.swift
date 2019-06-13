//
//  AppDelegate.swift
//  MovaIOTestProject
//
//  Created by Oleksii on 6/13/19.
//  Copyright © 2019 Self Organization. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let navigationController = UINavigationController()
        let rootViewController = FlickrSearchingHistoryViewController()
        
        navigationController.viewControllers = [rootViewController]
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

