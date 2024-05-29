//
//  ConfigurationRemoteDataRepository.swift
//  Movies
//
//  Created by Michelle on 26/05/2024.
//

import Foundation

protocol ConfigurationRemoteDataRepository {
    func loadConfiguration() async throws -> Configuration
}

class ConfigurationRemoteDataRepositoryImplementation: ConfigurationRemoteDataRepository {
    
    @Dependency private var networkClient: NetworkClient
    
    func loadConfiguration() async throws -> Configuration {
        try await networkClient.request(.configuration)
    }
}
