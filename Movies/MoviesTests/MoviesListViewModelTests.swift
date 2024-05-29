//
//  MoviesListViewModelTests.swift
//  MoviesTests
//
//  Created by Michelle on 29/05/2024.
//

import XCTest
import Combine

@testable import Movies

final class MoviesListViewModelTests: XCTestCase {
    
    var viewModelUnderTest: MoviesListViewModel!
    var mockMoviesUseCase: MockMoviesUseCase!
    var mockConfigurationUseCase: MockConfigurationUseCase!
    var mockCoordinator: MockMoviesCoordinator!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockMoviesUseCase = MockMoviesUseCase()
        mockConfigurationUseCase = MockConfigurationUseCase()
        mockCoordinator = MockMoviesCoordinator(movieListType: .popular)
        DependencyContainer.register(MoviesUseCase.self, self.mockMoviesUseCase)
        DependencyContainer.register(ConfigurationUseCase.self, self.mockConfigurationUseCase)
        
        viewModelUnderTest = MoviesListViewModel(moviesListType: .popular)
        viewModelUnderTest.coordinator = mockCoordinator
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        mockMoviesUseCase = nil
        mockConfigurationUseCase = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModelUnderTest.moviesViewModels.isEmpty)
        XCTAssertNil(viewModelUnderTest.loadMoviesListError)
        XCTAssertEqual(viewModelUnderTest.moviesListType, .popular)
    }
    
    func testLoadMoviesSuccess() {
        let moviesList = MoviesList(results: [Movie(id: 1, posterPath: "/test.jpg", releaseDate: "2023-01-01", title: "Test Movie")])
        mockMoviesUseCase.moviesList = moviesList
        let expectation = XCTestExpectation(description: "Movies loaded")
        
        viewModelUnderTest
            .$moviesViewModels
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModelUnderTest.loadMovies()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModelUnderTest.moviesViewModels.count, 1)
        XCTAssertEqual(viewModelUnderTest.moviesViewModels.first?.title, "Test Movie")
        XCTAssertNil(viewModelUnderTest.loadMoviesListError)
        XCTAssertFalse(viewModelUnderTest.moviesViewModels.isEmpty)
    }
    
    func testLoadMoviesFailure() {
        mockMoviesUseCase.error = NSError(domain: "", code: -1, userInfo: nil)
        let expectation = XCTestExpectation(description: "Movies failed to load")
        
        viewModelUnderTest.$loadMoviesListError
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModelUnderTest.loadMovies()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModelUnderTest.loadMoviesListError)
        XCTAssertTrue(viewModelUnderTest.moviesViewModels.isEmpty)
    }
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModelUnderTest.numberOfSections, 1)
    }
    
    func testNumberOfRowsInSection() {
        let moviesList = MoviesList(results: [
            Movie(id: 1, posterPath: "/poster1.jpg", releaseDate: "2023-01-01", title: "Movie 1"),
            Movie(id: 2, posterPath: "/poster2.jpg", releaseDate: "2023-02-01", title: "Movie 2"),
        ])
        mockMoviesUseCase.moviesList = moviesList
        let expectation = XCTestExpectation(description: "Movies loaded")
        
        viewModelUnderTest
            .$moviesViewModels
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModelUnderTest.loadMovies()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModelUnderTest.numberOfRowsInSection(0), 2)
    }
    
    func testMovieCellViewModelAt() {
        let moviesList = MoviesList(results: [
            Movie(id: 1, posterPath: "/poster1.jpg", releaseDate: "2023-01-01", title: "Movie 1"),
            Movie(id: 2, posterPath: "/poster2.jpg", releaseDate: "2023-02-01", title: "Movie 2"),
        ])
        mockMoviesUseCase.moviesList = moviesList
        let expectation = XCTestExpectation(description: "Movies loaded")
        
        viewModelUnderTest
            .$moviesViewModels
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        viewModelUnderTest.loadMovies()
        
        wait(for: [expectation], timeout: 1.0)
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModelUnderTest.movieCellViewModelAt(indexPath).title, "Movie 1")
    }
    
    func testTitle() {
        XCTAssertEqual(viewModelUnderTest.title, "Popular") // Assuming moviesListType.title returns "Popular Movies"
    }
    
    func testMakeMovieCellViewModels() {
        let moviesList = MoviesList(results: [
            Movie(id: 1, posterPath: "/poster1.jpg", releaseDate: "2023-01-01", title: "Movie 1"),
            Movie(id: 2, posterPath: "/poster2.jpg", releaseDate: "2023-02-01", title: "Movie 2"),
            Movie(id: 3, posterPath: "/poster3.jpg", releaseDate: "2023-03-01", title: nil)  // This should be ignored
        ])
        
        let movieCellViewModels = viewModelUnderTest.makeMovieCellViewModels(moviesList)
        
        XCTAssertEqual(movieCellViewModels.count, 2)
        XCTAssertEqual(movieCellViewModels[0].title, "Movie 1")
        XCTAssertEqual(movieCellViewModels[0].posterUrl.absoluteString, "https://example.com/w500/poster1.jpg")
        XCTAssertEqual(movieCellViewModels[1].title, "Movie 2")
        XCTAssertEqual(movieCellViewModels[1].posterUrl.absoluteString, "https://example.com/w500/poster2.jpg")
    }
    
    func testSelectMovieAt() {
        let movieCellVM1 = MovieCellViewModel(id: 1, title: "Movie 1", releaseDate: Date(), posterUrl: URL(string: "https://example.com/poster1.jpg")!)
        let movieCellVM2 = MovieCellViewModel(id: 2, title: "Movie 2", releaseDate: Date(), posterUrl: URL(string: "https://example.com/poster2.jpg")!)
        viewModelUnderTest.moviesViewModels = [movieCellVM1, movieCellVM2]
        
        let indexPath = IndexPath(row: 1, section: 0)
        viewModelUnderTest.selectMovieAt(indexPath)
        
        XCTAssertTrue(mockCoordinator.didNavigateToMovieDetails)
        XCTAssertEqual(mockCoordinator.selectedMovieID, 2)
    }
}

extension MoviesListViewModelTests {
    
    class MockMoviesUseCase: MoviesUseCase {
        var moviesList: MoviesList?
        var error: Error?
        
        func loadMovies(_ type: MovieListType) -> AnyPublisher<MoviesList, Error> {
            if let error = error {
                return Fail(error: error).eraseToAnyPublisher()
            } else if let moviesList = moviesList {
                return Just(moviesList)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            } else {
                fatalError("No mock data provided")
            }
        }
    }


    class MockConfigurationUseCase: ConfigurationUseCase {
        func loadConfiguration() -> AnyPublisher<Movies.Configuration, any Error> {
            Future<Configuration, Error>({ _ in }).eraseToAnyPublisher()
        }
        
        var configuration: Configuration? = Configuration(images: ImagesConfig(baseUrl: "https://example.com", posterSizes: ["w500", "original"]))
    }

    class MockMoviesCoordinator: MoviesCoordinator {
        var didNavigateToMovieDetails = false
        var selectedMovieID: Int?
        
        override func navigateToMovieDetails(_ movieID: Int) {
            didNavigateToMovieDetails = true
            selectedMovieID = movieID
        }
    }

}
