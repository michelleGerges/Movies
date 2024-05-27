//
//  AppCoordinator.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    var childCoordinators = [MoviesCoordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = LandingViewModel(coordinator: self)
        window.rootViewController = LandingViewController(viewModel: viewModel)
    }
    
    func navigateToMovies() {
        
        childCoordinators.append(MoviesCoordinator(movieListType: .nowPlaying))
        childCoordinators.append(MoviesCoordinator(movieListType: .popular))
        childCoordinators.append(MoviesCoordinator(movieListType: .upcoming))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = childCoordinators.map {
            $0.start()
            return $0.navigationController
        }
        
        window.rootViewController = tabBarController
    }
}
