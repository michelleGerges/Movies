//
//  MoviesCoordinator.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation
import UIKit

class MoviesCoordinator: Coordinator {
    
    let navigationController: UINavigationController
    let movieListType: MovieListType
    
    init(movieListType: MovieListType) {
        navigationController = UINavigationController()
        self.movieListType = movieListType
    }
    
    func start() {
        
        let viewModel = MoviesListViewModel(moviesListType: movieListType)
        let rootViewController = MoviesListViewController(viewModel: viewModel)
        
        navigationController.viewControllers = [rootViewController]
        navigationController.tabBarItem.title = movieListType.title
    }
    
    func navigateToMovie(_ id: Int) {
        
    }
}
