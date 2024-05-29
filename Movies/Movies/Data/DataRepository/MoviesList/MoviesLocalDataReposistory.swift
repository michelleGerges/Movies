//
//  MoviesLocalDataReposistory.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

protocol MoviesLocalDataReposistory {
    func getMovies(_ type: MovieListType) -> MoviesList?
    func saveMovies(_ movies: MoviesList, type: MovieListType)
}

class MoviesLocalDataReposistoryImplementation: MoviesLocalDataReposistory {
        
    @Dependency private var userDefauls: UserDefaults
    
    private func getKeyfor(_ type: MovieListType) -> String {
        "MoviesList|\(type.key)"
    }
    
    func getMovies(_ type: MovieListType) -> MoviesList? {
        guard let data = userDefauls.object(forKey: getKeyfor(type)) as? Data else {
            return nil
        }
        return try? JSONDecoder().decode(MoviesList.self, from: data)
    }
    
    func saveMovies(_ movies: MoviesList, type: MovieListType) {
        userDefauls.set(try? JSONEncoder().encode(movies), forKey: getKeyfor(type))
    }
}
