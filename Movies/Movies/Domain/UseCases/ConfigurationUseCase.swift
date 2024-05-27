//
//  ConfigurationUseCase.swift
//  Movies
//
//  Created by Michelle on 26/05/2024.
//

import Foundation
import Combine

protocol ConfigurationUseCase {
    func loadConfiguration() async throws
}

class ConfigurationUseCaseImplementation: ConfigurationUseCase {
    
    @Dependency private var remoteRepo: ConfigurationRemoteDataRepository
    @Dependency private var localRepo: ConfigurationLocalDataRepository
    
    func loadConfiguration() async throws {
        let data = try await remoteRepo.loadConfiguration()
        localRepo.saveConfiguration(data)
    }
}
