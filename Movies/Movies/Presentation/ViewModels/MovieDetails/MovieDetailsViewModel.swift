//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation
import Combine

class MovieDetailsViewModel {
    
    @Dependency private var useCase: MovieDetialsUseCase
    @Dependency private var configurationUseCase: ConfigurationUseCase
    
    @Published var movieDetailsViewModels = [MovieDetailsCellViewModel]()
    @Published var movieTitle: String?
    @Published var loadMovieDetailsError: Error?
    
    private var subscriptions = Set<AnyCancellable>()
    private lazy var configuration: Configuration? = { configurationUseCase.configuration }()
    
    var isEmpty: Bool {
        movieDetailsViewModels.isEmpty
    }
    
    let movieID: Int
    init(movieID: Int) {
        self.movieID = movieID
    }
    
    func loadMovieDetilas() {
            
        useCase
            .loadMovieDetials(movieID)
            .receive(on: DispatchQueue.main)
            .sink { completed in
                if case .failure(let error) = completed {
                    self.loadMovieDetailsError = error
                }
            } receiveValue: { movieDetails in
                self.movieTitle = movieDetails.title
                self.movieDetailsViewModels = self.makeMovieDetailsViewModels(movieDetails)
            }
            .store(in: &subscriptions)
    }
}

extension MovieDetailsViewModel {
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        movieDetailsViewModels.count
    }
    
    func movieDetailsCellViewModelAt(_ indexPath: IndexPath) -> MovieDetailsCellViewModel {
        movieDetailsViewModels[indexPath.row]
    }
}

extension MovieDetailsViewModel {
    func makeMovieDetailsViewModels(_ movieDetails: MovieDetails) -> [MovieDetailsCellViewModel] {
        [
            makeMovieDetailsPosterCell(movieDetails),
            makeMovieDetailsOverviewCell(movieDetails),
            makeMovieDetailsGenresCell(movieDetails),
            makeMovieDetailsBudgetCell(movieDetails),
            makeMovieDetailsRuntimeCell(movieDetails)
        ].compactMap { $0 }
    }
    
    func makeMovieDetailsPosterCell(_ movieDetails: MovieDetails) -> MovieDetailsCellViewModel? {
        guard let url = makeMoviePosterUrl(movieDetails) else {
            return nil
        }
        return MovieDetailsImageCellViewModel(imageURL: url)
    }
    
    func makeMoviePosterUrl(_ movieDetails: MovieDetails) -> URL? {
        guard let path = movieDetails.posterPath,
              let imageBaseUrl = configuration?.images?.baseUrl,
              let posterSize = configuration?.images?.posterSizes?.last else {
            return nil
        }
        return URL(string: "\(imageBaseUrl)/\(posterSize)\(path)")
    }
    
    func makeMovieDetailsOverviewCell(_ movieDetails: MovieDetails) -> MovieDetailsCellViewModel? {
        guard let overview = movieDetails.overview else {
            return nil
        }
        return MovieDetailsDescriptionCellViewModel(description: overview)
    }
    
    func makeMovieDetailsGenresCell(_ movieDetails: MovieDetails) -> MovieDetailsCellViewModel? {
        guard let genres = movieDetails.genres?.compactMap({ $0.name }),
              !genres.isEmpty else {
            return nil
        }
        return MovieDetailsTitleValueCellViewModel(title: "Genres", value: genres.joined(separator: ", "))
    }
    
    func makeMovieDetailsBudgetCell(_ movieDetails: MovieDetails) -> MovieDetailsCellViewModel? {
        guard let budget = movieDetails.budget,
              budget > 0 else {
            return nil
        }
        return MovieDetailsTitleValueCellViewModel(title: "Budget", value: budget.formatted(.currency(code: "USD")))
    }
    
    func makeMovieDetailsRuntimeCell(_ movieDetails: MovieDetails) -> MovieDetailsCellViewModel? {
        guard let runtime = movieDetails.runtime,
              runtime > 0 else {
            return nil
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        guard let duration = formatter.string(from: TimeInterval(runtime * 60)) else {
            return nil
        }
        
        return MovieDetailsTitleValueCellViewModel(title: "Runtime", value: duration)
    }
}
