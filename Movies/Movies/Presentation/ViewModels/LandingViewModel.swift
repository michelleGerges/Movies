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
    
    var subscriptions = Set<AnyCancellable>()
    weak var coordinator: AppCoordinator?
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
}

extension LandingViewModel {
    
    @MainActor func loadConfiguration() {
        Task {
            do {
                try await useCase.loadConfiguration()
                coordinator?.navigateToMovies()
            } catch {
                self.error = error
            }
        }
    }
}
