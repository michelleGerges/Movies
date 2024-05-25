//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit

class MoviesListViewModel {
    
    @Dependency private var moviesUseCae: MoviesUseCase
    
    let moviesListType: MovieListType
    
    init(moviesListType: MovieListType) {
        self.moviesListType = moviesListType
    }
}

extension MoviesListViewModel {
    var title: String {
        moviesListType.title
    }
}
