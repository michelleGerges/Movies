//
//  MoviesList.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

struct MoviesList: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movie]?
    let totalPages: Int?
    let totalResults: Int?
    
    init(dates: Dates? = nil, page: Int? = nil, results: [Movie]? = nil, totalPages: Int? = nil, totalResults: Int? = nil) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum: String?
    let minimum: String?
    
    enum CodingKeys: String, CodingKey {
        case maximum = "max"
        case minimum = "min"
    }
}

struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    init(adult: Bool? = nil,
         backdropPath: String? = nil,
         genreIds: [Int]? = nil,
         id: Int? = nil,
         originalLanguage: String? = nil,
         originalTitle: String? = nil,
         overview: String? = nil,
         popularity: Double? = nil,
         posterPath: String? = nil,
         releaseDate: String? = nil,
         title: String? = nil,
         video: Bool? = nil,
         voteAverage: Double? = nil,
         voteCount: Int? = nil) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIds = genreIds
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

