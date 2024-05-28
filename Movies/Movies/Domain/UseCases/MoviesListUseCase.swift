//
//  MoviesUseCase.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation
import Combine

protocol MoviesUseCase {
    
    var moviesList: AnyPublisher<MoviesList, Error> { get }
    func loadMovies(_ type: MovieListType)
}

class MoviesUseCaseImplementaiton: MoviesUseCase {
    
    @Dependency private var remoteRepo: MoviesRemoteDataRepository
    @Dependency private var localRepo: MoviesLocalDataReposistory
    
    private var subject = PassthroughSubject<MoviesList, Error>()
    
    var moviesList: AnyPublisher<MoviesList, any Error> {
        subject.eraseToAnyPublisher()
    }
    
    func loadMovies(_ type: MovieListType) {
        Task {
            do {
                let data = try await remoteRepo.loadMovies(type)
                localRepo.saveMovies(data, type: type)
                subject.send(data)
            } catch {
                if let data = localRepo.getMovies(type) {
                    subject.send(data)
                }
                subject.send(completion: .failure(error))
            }
        }
    }
}
