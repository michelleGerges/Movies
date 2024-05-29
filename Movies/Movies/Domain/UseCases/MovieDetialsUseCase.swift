//
//  MovieDetialsUseCase.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation
import Combine

protocol MovieDetialsUseCase {
    func loadMovieDetials(_ movieID: Int) -> AnyPublisher<MovieDetails, Error>
}

class MovieDetailsUseCaseImplementaiton: MovieDetialsUseCase {
    
    @Dependency private var remoteRepo: MovieDetailsRemoteDataRepository
    @Dependency private var localRepo: MovieDetailsLocalDataRepository
    
    private var subject: PassthroughSubject<MovieDetails, Error>?
    
    func loadMovieDetials(_ movieID: Int) -> AnyPublisher<MovieDetails, Error> {
        let subject = PassthroughSubject<MovieDetails, Error>()
        Task {
            do {
                let data = try await remoteRepo.loadMovieDetails(movieID)
                localRepo.saveMovieDetails(data)
                subject.send(data)
            } catch {
                if let data = localRepo.getMovieDetails(movieID) {
                    subject.send(data)
                }
                subject.send(completion: .failure(error))
            }
        }
        self.subject = subject
        return subject.eraseToAnyPublisher()
    }
}
