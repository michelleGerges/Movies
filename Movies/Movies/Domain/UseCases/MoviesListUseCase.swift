//
//  MoviesUseCase.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit

protocol MoviesUseCase {
    
}

class MoviesUseCaseImplementaiton: MoviesUseCase {

    @Dependency private var remoteRepo: MoviesRemoteDataRepository
    @Dependency private var localRepo: MoviesLocalDataReposistory
}
