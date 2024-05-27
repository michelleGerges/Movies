//
//  Configuration.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import Foundation

struct Configuration: Codable {
  let images: ImagesConfig?
  
  enum CodingKeys: String, CodingKey {
    case images = "images"
  }
}

struct ImagesConfig: Codable {
  let baseUrl: String?
  let secureBaseUrl: String?
  let backdropSizes: [String]?
  let logoSizes: [String]?
  let posterSizes: [String]?
  let profileSizes: [String]?
  let stillSizes: [String]?
  
  enum CodingKeys: String, CodingKey {
    case baseUrl = "base_url"
    case secureBaseUrl = "secure_base_url"
    case backdropSizes = "backdrop_sizes"
    case logoSizes = "logo_sizes"
    case posterSizes = "poster_sizes"
    case profileSizes = "profile_sizes"
    case stillSizes = "still_sizes"
  }
}
