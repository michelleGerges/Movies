//
//  ConfigurationLocalDataRepository.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import Foundation

protocol ConfigurationLocalDataRepository {

    var configuration: Configuration? { get }
    func saveConfiguration(_ config: Configuration)
}

class ConfigurationLocalDataRepositoryImplementation: ConfigurationLocalDataRepository {
    
    @Dependency private var userDefauls: UserDefaults
    static var configuration: Configuration?
    
    var configuration: Configuration? {
        if let configuration = Self.configuration {
            return configuration
        }
        
        guard let data = userDefauls.object(forKey: "Configuration") as? Data else {
            return nil
        }
        
        Self.configuration = try? JSONDecoder().decode(Configuration.self, from: data)
        return Self.configuration
    }
    
    func saveConfiguration(_ config: Configuration) {
        userDefauls.set(try? JSONEncoder().encode(config), forKey: "Configuration")
    }
}
