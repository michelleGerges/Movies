//
//  SceneDelegate.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(window: window ?? UIWindow())
        appCoordinator?.start()
    }
}

