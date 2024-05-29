//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import UIKit
import Combine

class MoviesListViewModel {
    
    @Dependency private var useCase: MoviesUseCase
    @Dependency private var configurationUseCase: ConfigurationUseCase
    
    @Published var moviesViewModels = [MovieCellViewModel]()
    @Published var loadMoviesListError: Error? = nil
    
    private var subscriptions = Set<AnyCancellable>()
    lazy private var configuration: Configuration? = { configurationUseCase.configuration } ()
    
    var isEmpty: Bool {
        moviesViewModels.isEmpty
    }
    
    weak var coordinator: MoviesCoordinator?
    
    let moviesListType: MovieListType
    init(moviesListType: MovieListType) {
        self.moviesListType = moviesListType
    }
}

extension MoviesListViewModel {
    
    func loadMovies() {
        useCase
            .loadMovies(moviesListType)
            .receive(on: DispatchQueue.main)
            .sink { completed in
                if case .failure(let error) = completed {
                    self.loadMoviesListError = error
                }
            } receiveValue: { moviesList in
                self.moviesViewModels = self.makeMovieCellViewModels(moviesList)
            }
            .store(in: &subscriptions)
    }
}

extension MoviesListViewModel {
    var numberOfSections: Int {
        1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        moviesViewModels.count
    }
    
    func movieCellViewModelAt(_ indexPath: IndexPath) -> MovieCellViewModel {
        moviesViewModels[indexPath.row]
    }
    
    func selectMovieAt(_ indexPath: IndexPath) {
        coordinator?.navigateToMovieDetails(moviesViewModels[indexPath.row].id)
    }
}

extension MoviesListViewModel {
    
    func makeMovieCellViewModels(_ moviesList: MoviesList) -> [MovieCellViewModel] {
        moviesList.results?.compactMap({ makeMovieCellViewModel($0) }) ?? []
    }
    
    func makeMovieCellViewModel(_ movie: Movie) -> MovieCellViewModel? {
        guard let id = movie.id,
              let title = movie.title,
              let url = makeMoviePosterUrl(movie),
              let releaseDate = makeMovieReleaseDate(movie.releaseDate) else {
            return nil
        }
        return MovieCellViewModel(id: id, title: title, releaseDate: releaseDate, posterUrl: url)
    }
    
    func makeMoviePosterUrl(_ movie: Movie) -> URL? {
        guard let path = movie.posterPath,
              let imageBaseUrl = configuration?.images?.baseUrl,
              let posterSize = configuration?.images?.posterSizes?.suffix(2).first else {
            return nil
        }
        return URL(string: "\(imageBaseUrl)/\(posterSize)/\(path)")
    }
    
    func makeMovieReleaseDate(_ date: String?) -> Date? {
        guard let date = date else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)
    }
}

extension MoviesListViewModel {
    var title: String {
        moviesListType.title
    }
}
