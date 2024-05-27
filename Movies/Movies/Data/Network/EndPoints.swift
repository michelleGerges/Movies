//
//  EndPoints.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

enum EndPoint {
    
    case configuration
    case getMoviesList(_ type: MovieListType)
    case getMovieDetails(_ id: Int)
    
    var baseURL: String {
        return Constants.Network.baseURL
    }
    
    var path: String {
        switch self {
        case .configuration:
            return Constants.Network.EndPointPath.configuration
        case .getMoviesList(let type):
            return "\(Constants.Network.EndPointPath.moviesList)/\(type.key)"
        case .getMovieDetails(let id):
            return "\(Constants.Network.EndPointPath.movieDetails)/\(id)"
        }
    }
    
    var method: EndPointMethod {
        switch self {
        case .configuration, .getMoviesList, .getMovieDetails:
            return .get
        }
    }
    
    var headerFields: [String: String]? {
        ["Authorization": "Bearer \(Constants.Network.token)"]
    }
    
    var body: Encodable? {
        switch self {
        case .configuration, .getMoviesList, .getMovieDetails:
            return nil
        }
    }
    
    var fullURL: String {
        "\(baseURL)\(path)"
    }
}

enum EndPointMethod: String {
    case get = "GET"
    case post = "POST"
}
