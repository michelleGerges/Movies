//
//  AppDelegate.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initialSetup()
        return true
    }
    
    private func initialSetup() {
        DependencyContainer.registerDependencies()
    }
}

