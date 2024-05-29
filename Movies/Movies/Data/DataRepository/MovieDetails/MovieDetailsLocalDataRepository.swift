//
//  MovieDetailsLocalDataRepository.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation

protocol MovieDetailsLocalDataRepository {
    func getMovieDetails(_ movieID: Int) -> MovieDetails?
    func saveMovieDetails(_ movieDetails: MovieDetails)
}

class MovieDetailsLocalDataRepositoryImplementation: MovieDetailsLocalDataRepository {
    
    @Dependency private var userDefauls: UserDefaults
    
    private func getKeyforMovie(_ id: Int) -> String {
        "MovieDetails|\(id)"
    }
    
    func getMovieDetails(_ movieID: Int) -> MovieDetails? {
        guard let data = userDefauls.object(forKey: getKeyforMovie(movieID)) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(MovieDetails.self, from: data)
    }
    
    func saveMovieDetails(_ movieDetails: MovieDetails) {
        guard let id = movieDetails.id else { return }
        userDefauls.set(try? JSONEncoder().encode(movieDetails), forKey: getKeyforMovie(id))
    }
}
