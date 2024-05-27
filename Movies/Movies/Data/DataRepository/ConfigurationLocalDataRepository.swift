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
    
    static var configuration: Configuration?
    
    var configuration: Configuration? {
        Self.configuration
    }
    
    func saveConfiguration(_ config: Configuration) {
        Self.configuration = config
    }
}
