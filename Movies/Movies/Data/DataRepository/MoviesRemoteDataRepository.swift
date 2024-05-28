//
//  MoviesRemoteDataRepository.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

protocol MoviesRemoteDataRepository {
    func loadMovies(_ type: MovieListType) async throws -> MoviesList
}

class MoviesRemoteDataRepositoryImplementation: MoviesRemoteDataRepository {
    
    @Dependency private var networkClient: NetworkClient
    
    func loadMovies(_ type: MovieListType) async throws -> MoviesList {
        try await networkClient.request(.getMoviesList(type))
    }
}
