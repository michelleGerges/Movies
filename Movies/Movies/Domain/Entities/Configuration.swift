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
    let posterSizes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case posterSizes = "poster_sizes"
    }
}
