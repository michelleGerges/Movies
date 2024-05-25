//
//  EndPoints.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

enum EndPoint {
    
    case getMoviesList(_ type: MovieListType)
    case getMovieDetials
    
    var baseURL: String {
        return "https://api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .getMoviesList(let type):
            return "3/movie/\(type.key)"
        case .getMovieDetials:
            return ""
        }
    }
    
    var method: EndPointMethod {
        switch self {
        case .getMoviesList:
            return .get
        case .getMovieDetials:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .getMoviesList:
            return nil
        case .getMovieDetials:
            return nil
        }
    }
    
    var fullURL: String {
        "\(baseURL)/\(path)"
    }
}

enum EndPointMethod: String {
    case get = "GET"
    case post = "POST"
}
