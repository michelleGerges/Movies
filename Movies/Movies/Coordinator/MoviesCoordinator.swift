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
        viewModel.coordinator = self
        let rootViewController = MoviesListViewController(viewModel: viewModel)
        
        navigationController.viewControllers = [rootViewController]
        navigationController.tabBarItem.title = movieListType.title
    }
    
    func navigateToMovieDetails(_ id: Int) {
        let viewModel = MovieDetailsViewModel(movieID: id)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.show(viewController, sender: nil)
    }
}
