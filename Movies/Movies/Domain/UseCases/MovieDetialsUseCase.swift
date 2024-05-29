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
    
    func loadMovieDetials(_ movieID: Int) -> AnyPublisher<MovieDetails, any Error> {
        Future { promise in
            Task {
                do {
                    let data = try await self.remoteRepo.loadMovieDetails(movieID)
                    self.localRepo.saveMovieDetails(data)
                    promise(.success(data))
                } catch {
                    if let data = self.localRepo.getMovieDetails(movieID) {
                        promise(.success(data))
                    } else {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
