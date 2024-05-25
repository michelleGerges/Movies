//
//  DependencyContainer.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

@propertyWrapper
struct Dependency<T> {
    
    var dependency: T
    
    init() {
        guard let resolved = DependencyContainer.resolve(T.self) else {
            fatalError("No Dependency Resolved for \(T.self)")
        }
        dependency = resolved
    }
    
    var wrappedValue: T {
        get {
            dependency
        }
        set {
            dependency = newValue
        }
    }
}

class DependencyContainer {
    
    private static var factories: [String: () -> Any] = [:]
    
    private static func register<T>(_ dependency: T.Type, _ factory: @autoclosure @escaping () -> T) {
        factories[String(describing: T.self)] = factory
    }
    
    static func resolve<T>(_ dependency: T.Type) -> T? {
        factories[String(describing: dependency.self)]?() as? T
    }
    
    static func registerDependencies() {
        
        self.register(URLSession.self, URLSession.shared)
        self.register(NetworkClient.self, NetworkClient.shared)
        
        self.register(MoviesRemoteDataRepository.self, MoviesRemoteDataRepositoryImplementation())
        self.register(MoviesLocalDataReposistory.self, MoviesLocalDataReposistoryImplementation())
        
        self.register(MoviesUseCase.self, MoviesUseCaseImplementaiton())
    }
}
