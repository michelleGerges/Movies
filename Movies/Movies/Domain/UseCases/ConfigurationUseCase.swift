//
//  ConfigurationUseCase.swift
//  Movies
//
//  Created by Michelle on 26/05/2024.
//

import Foundation
import Combine

protocol ConfigurationUseCase {
    var configuration: Configuration? { get }
    func loadConfiguration() -> AnyPublisher<Configuration, Error>
}

class ConfigurationUseCaseImplementation: ConfigurationUseCase {
    
    @Dependency private var remoteRepo: ConfigurationRemoteDataRepository
    @Dependency private var localRepo: ConfigurationLocalDataRepository
    
    var configuration: Configuration? {
        localRepo.configuration
    }
    
    func loadConfiguration() ->  AnyPublisher<Configuration, Error> {
        Future  { promise in
            Task {
                do {
                    let data = try await self.remoteRepo.loadConfiguration()
                    self.localRepo.saveConfiguration(data)
                    promise(.success(data))
                } catch {
                    if let data = self.localRepo.configuration {
                        promise(.success(data))
                    } else {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
