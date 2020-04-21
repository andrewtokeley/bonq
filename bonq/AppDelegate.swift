//
//  AppDelegate.swift
//  bonq
//
//  Created by Andrew Tokeley on 6/04/20.
//  Copyright © 2020 Andrew Tokeley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Open first view
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let module = AppModules.load.build()
//        module.router.show(inWindow: self.window, embedInNavController: false, setupData: nil, makeKeyAndVisible: true)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let module = AppModules.menu.build()
        module.router.show(inWindow: self.window, embedInNavController: false, setupData: nil, makeKeyAndVisible: true)
        return true
            
    }

}

