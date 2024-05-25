//
//  MovieListType.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

enum MovieListType {
    case nowPlaying
    case popular
    case upcoming
    
    var key: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .upcoming:
            return "upcoming"
        }
    }
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "Now playing"
        case .popular:
            return "Popular"
        case .upcoming:
            return "Upcoming"
        }
    }
}
