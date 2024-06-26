//
//  MovieDetails.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation

struct MovieDetails: Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: MovieCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originalCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    init(adult: Bool? = nil, backdropPath: String? = nil, belongsToCollection: MovieCollection? = nil, budget: Int? = nil, genres: [Genre]? = nil, homepage: String? = nil, id: Int? = nil, imdbID: String? = nil, originalCountry: [String]? = nil, originalLanguage: String? = nil, originalTitle: String? = nil, overview: String? = nil, popularity: Double? = nil, posterPath: String? = nil, releaseDate: String? = nil, revenue: Int? = nil, runtime: Int? = nil, status: String? = nil, tagline: String? = nil, title: String? = nil, video: Bool? = nil, voteAverage: Double? = nil, voteCount: Int? = nil) {
      self.adult = adult
      self.backdropPath = backdropPath
      self.belongsToCollection = belongsToCollection
      self.budget = budget
      self.genres = genres
      self.homepage = homepage
      self.id = id
      self.imdbID = imdbID
      self.originalCountry = originalCountry
      self.originalLanguage = originalLanguage
      self.originalTitle = originalTitle
      self.overview = overview
      self.popularity = popularity
      self.posterPath = posterPath
      self.releaseDate = releaseDate
      self.revenue = revenue
      self.runtime = runtime
      self.status = status
      self.tagline = tagline
      self.title = title
      self.video = video
      self.voteAverage = voteAverage
      self.voteCount = voteCount
    }


    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalCountry = "original_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieCollection: Codable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
