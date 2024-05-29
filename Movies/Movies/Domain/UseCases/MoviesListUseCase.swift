//
//  MoviesUseCase.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation
import Combine

protocol MoviesUseCase {
    func loadMovies(_ type: MovieListType) -> AnyPublisher<MoviesList, Error>
}

class MoviesUseCaseImplementaiton: MoviesUseCase {
    
    @Dependency private var remoteRepo: MoviesRemoteDataRepository
    @Dependency private var localRepo: MoviesLocalDataReposistory
    
    private var subject: PassthroughSubject<MoviesList, Error>?
    
    func loadMovies(_ type: MovieListType) -> AnyPublisher<MoviesList, Error> {
        let subject = PassthroughSubject<MoviesList, Error>()
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
        self.subject = subject
        return subject.eraseToAnyPublisher()
    }
}
