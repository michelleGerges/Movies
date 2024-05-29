//
//  MovieDetailsRemoteDataRepository.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation

protocol MovieDetailsRemoteDataRepository {
    func loadMovieDetails(_ movieID: Int) async throws -> MovieDetails
}

class MovieDetailsRemoteDataRepositoryImplementation: MovieDetailsRemoteDataRepository {
    
    @Dependency private var networkClient: NetworkClient
    
    func loadMovieDetails(_ movieID: Int) async throws -> MovieDetails {
        try await networkClient.request(.getMovieDetails(movieID))
    }
}
