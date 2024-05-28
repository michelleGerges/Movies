//
//  LandingViewModel.swift
//  Movies
//
//  Created by Michelle on 26/05/2024.
//

import Foundation
import Combine

class LandingViewModel {
    
    @Dependency fileprivate var useCase: ConfigurationUseCase
    @Published var error: Error?
    
    weak var coordinator: AppCoordinator?
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
}

extension LandingViewModel {
    
    func loadConfiguration() {
        useCase
            .loadConfiguration()
            .receive(on: DispatchQueue.main)
            .sink { completed in
                if case .failure(let error) = completed {
                    self.error = error
                }
            } receiveValue: { _ in
                self.coordinator?.navigateToMovies()
            }
            .store(in: &subscriptions)
    }
}
