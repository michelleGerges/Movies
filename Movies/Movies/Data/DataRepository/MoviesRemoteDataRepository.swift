//
//  MoviesRemoteDataRepository.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

protocol MoviesRemoteDataRepository {
    
}

class MoviesRemoteDataRepositoryImplementation: MoviesRemoteDataRepository {
    
    @Dependency private var networkClient: NetworkClient
}
