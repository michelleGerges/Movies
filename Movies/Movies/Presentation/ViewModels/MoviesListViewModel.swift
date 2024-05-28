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
    
    lazy private var configuration: Configuration? = {
        configurationUseCase.configuration
    } ()
    
    let moviesListType: MovieListType
    
    @Published var moviesViewModels = [MovieCellViewModel]()
    @Published var error: Error? = nil
    
    fileprivate var subscriptions = Set<AnyCancellable>()
    
    init(moviesListType: MovieListType) {
        self.moviesListType = moviesListType
    }
}

extension MoviesListViewModel {
    
    func loadMovies() {
        bindToUseCase()
        useCase.loadMovies(moviesListType)
    }
    
    func bindToUseCase() {
        useCase
            .moviesList
            .receive(on: DispatchQueue.main)
            .sink { completed in
                if case .failure(let error) = completed {
                    self.error = error
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
}

extension MoviesListViewModel {
    
    func makeMovieCellViewModels(_ moviesList: MoviesList) -> [MovieCellViewModel] {
        moviesList.results?.compactMap({ makeMovieCellViewModel($0) }) ?? []
    }
    
    func makeMovieCellViewModel(_ movie: Movie) -> MovieCellViewModel? {
        guard let title = movie.title,
              let url = makeMovieUrl(movie.posterPath),
              let releaseDate = makeMovieReleaseDate(movie.releaseDate) else {
            return nil
        }
        return MovieCellViewModel(title: title, releaseDate: releaseDate, posterUrl: url)
    }
    
    func makeMovieUrl(_ path: String?) -> URL? {
        guard let imageBaseUrl = configuration?.images?.baseUrl,
              let posterSize = configuration?.images?.posterSizes?.suffix(2).first,
              let path = path else {
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
