//
//  MovieDetailsUseCaseTest.swift
//  MoviesTests
//
//  Created by Michelle on 29/05/2024.
//

import XCTest
import Combine

@testable import Movies

final class MovieDetailsUseCaseTest: XCTestCase {
    
    var useCaseUnderTest: MovieDetailsUseCaseImplementaiton!
    var remoteRepoMock: MovieDetailsRemoteDataRepositoryMock!
    var localRepoMock: MovieDetailsLocalDataRepositoryMock!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        subscriptions = Set<AnyCancellable>()
        remoteRepoMock = MovieDetailsRemoteDataRepositoryMock()
        localRepoMock = MovieDetailsLocalDataRepositoryMock()
        
        DependencyContainer.register(MovieDetailsRemoteDataRepository.self, self.remoteRepoMock)
        DependencyContainer.register(MovieDetailsLocalDataRepository.self, self.localRepoMock)
        
        useCaseUnderTest = MovieDetailsUseCaseImplementaiton()
    }
    
    override func tearDown() {
        remoteRepoMock = nil
        localRepoMock = nil
        useCaseUnderTest = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func testLoadMovieDetailsRemoteSuccess() {

        remoteRepoMock.movieDetails = MovieDetails()
        
        let expectation = XCTestExpectation(description: "Movie Details loaded successfully")
        
        var receivedMovieDetails: MovieDetails?
        
        useCaseUnderTest.loadMovieDetials(123)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Loading movie Details should not fail")
                }
            }, receiveValue: { movies in
                expectation.fulfill()
                receivedMovieDetails = movies
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedMovieDetails)
    }
    
    func testSaveResponseWhenLoadedSuccessfulyFromRemote() {

        remoteRepoMock.movieDetails = MovieDetails()
        _ = useCaseUnderTest.loadMovieDetials(123)
        wait(for: [], timeout: 5.0)
        XCTAssertNotNil(localRepoMock.savedMovieDetails)
    }
    
    func testLoadMovieDetailsFailedRemoteAndGetFromLocal() {

        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        remoteRepoMock.error = error
        localRepoMock.movieDetails = MovieDetails()
        
        let dataExpectation = XCTestExpectation(description: "Movie details loaded from local")
        let errorExpection = XCTestExpectation(description: "Error From Remote")
        
        var receivedMovieDetails: MovieDetails?
        var receivedError: Error?
        
        useCaseUnderTest.loadMovieDetials(123)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    receivedError = error
                    errorExpection.fulfill()
                }
            }, receiveValue: { movieDetails in
                receivedMovieDetails = movieDetails
                dataExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [dataExpectation, errorExpection], timeout: 5.0)
        XCTAssertNotNil(receivedMovieDetails)
        XCTAssertNotNil(receivedError)
    }
    
    func testLoadMovieDetailsFailedRemoteAndNoDataLocal() {

        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        remoteRepoMock.error = error
        localRepoMock.movieDetails = nil
        
        let expectation = XCTestExpectation(description: "Movi eDetails load failed from both remote and local")
        var receivedError: Error?
        useCaseUnderTest.loadMovieDetials(123)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Loading movie details should not finish successfully")
                case .failure(let err):
                    receivedError = err
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Loading movie details should not finish successfully")
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedError)
    }
}

extension MovieDetailsUseCaseTest {
    class MovieDetailsRemoteDataRepositoryMock: MovieDetailsRemoteDataRepository {
        
        var movieDetails: MovieDetails?
        var error: Error?
        
        func loadMovieDetails(_ movieID: Int) async throws -> Movies.MovieDetails {
            
            if let movieDetails = movieDetails {
                return movieDetails
            }
            
            if let error = error {
                throw error
            }
            
            fatalError("no Mocked data provided")
        }
    }
    
    class MovieDetailsLocalDataRepositoryMock: MovieDetailsLocalDataRepository {
        
        var movieDetails: MovieDetails?
        var savedMovieDetails: MovieDetails?
        
        func getMovieDetails(_ movieID: Int) -> Movies.MovieDetails? {
            movieDetails
        }
        
        func saveMovieDetails(_ movieDetails: Movies.MovieDetails) {
            savedMovieDetails = movieDetails
        }
    }
}
