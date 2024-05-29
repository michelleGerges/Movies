//
//  MoviesUseCaseTest.swift
//  MoviesTests
//
//  Created by Michelle on 29/05/2024.
//

import XCTest
import Combine

@testable import Movies

final class MoviesUseCaseTest: XCTestCase {
    
    var useCaseUnderTest: MoviesUseCaseImplementaiton!
    var remoteRepoMock: MoviesRemoteDataRepositoryMock!
    var localRepoMock: MoviesLocalDataReposistoryMock!
    var subscriptions: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        subscriptions = Set<AnyCancellable>()
        remoteRepoMock = MoviesRemoteDataRepositoryMock()
        localRepoMock = MoviesLocalDataReposistoryMock()
        
        DependencyContainer.register(MoviesRemoteDataRepository.self, self.remoteRepoMock)
        DependencyContainer.register(MoviesLocalDataReposistory.self, self.localRepoMock)
        
        useCaseUnderTest = MoviesUseCaseImplementaiton()
    }
    
    override func tearDown() {
        remoteRepoMock = nil
        localRepoMock = nil
        useCaseUnderTest = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func testLoadMoviesRemoteSuccess() {

        remoteRepoMock.moviesList = MoviesList()
        
        let expectation = XCTestExpectation(description: "Movies loaded successfully")
        
        var receivedMoviesList: MoviesList?
        
        useCaseUnderTest.loadMovies(.popular)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Loading movies should not fail")
                }
            }, receiveValue: { movies in
                expectation.fulfill()
                receivedMoviesList = movies
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedMoviesList)
    }
    
    func testSaveResponseWhenLoadedSuccessfulyFromRemote() {

        remoteRepoMock.moviesList = MoviesList()
        _ = useCaseUnderTest.loadMovies(.popular)
        wait(for: [], timeout: 5.0)
        XCTAssertNotNil(localRepoMock.savedMoviesList)
    }
    
    func testLoadMoviesFailedRemoteAndGetFromLocal() {

        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        remoteRepoMock.error = error
        localRepoMock.movieList = MoviesList()
        
        let dataExpectation = XCTestExpectation(description: "Movies loaded from local")
        let errorExpection = XCTestExpectation(description: "Error From Remote")
        
        var receivedMoviesList: MoviesList?
        var receivedError: Error?
        
        useCaseUnderTest.loadMovies(.popular)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    receivedError = error
                    errorExpection.fulfill()
                }
            }, receiveValue: { movies in
                receivedMoviesList = movies
                dataExpectation.fulfill()
            })
            .store(in: &subscriptions)
        
        wait(for: [dataExpectation, errorExpection], timeout: 5.0)
        XCTAssertNotNil(receivedMoviesList)
        XCTAssertNotNil(receivedError)
    }
    
    func testLoadMoviesFailedRemoteAndNoDataLocal() {

        let error = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        remoteRepoMock.error = error
        localRepoMock.movieList = nil
        
        let expectation = XCTestExpectation(description: "Movies load failed from both remote and local")
        var receivedError: Error?
        useCaseUnderTest.loadMovies(.popular)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Loading movies should not finish successfully")
                case .failure(let err):
                    receivedError = err
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Loading movies should not finish successfully")
            })
            .store(in: &subscriptions)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(receivedError)
    }
}

extension MoviesUseCaseTest {
    class MoviesRemoteDataRepositoryMock: MoviesRemoteDataRepository {
        
        var moviesList: MoviesList?
        var error: Error?
        
        func loadMovies(_ type: MovieListType) async throws -> MoviesList {
            if let moviesList = moviesList {
                return moviesList
            }
            
            if let error = error {
                throw error
            }
            
            fatalError("no Mocked data provided")
        }
    }
    
    class MoviesLocalDataReposistoryMock: MoviesLocalDataReposistory {
        
        var movieList: MoviesList?
        var savedMoviesList: MoviesList?
        
        func saveMovies(_ movies: MoviesList, type: MovieListType) {
            savedMoviesList = movies
        }
        
        func getMovies(_ type: MovieListType) -> MoviesList? {
            return movieList
        }
    }
}
