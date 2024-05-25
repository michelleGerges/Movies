//
//  AppCoordinator.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordintaor {
    
    let window: UIWindow
    var childCoordinators = [MoviesCoordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let tabBarController = UITabBarController()
        
        childCoordinators.append(MoviesCoordinator(movieListType: .nowPlaying))
        childCoordinators.append(MoviesCoordinator(movieListType: .popular))
        childCoordinators.append(MoviesCoordinator(movieListType: .upcoming))
        
        tabBarController.viewControllers = childCoordinators.map({
            $0.start()
            return $0.navigationController
        })
        
        window.rootViewController = tabBarController
    }
}
