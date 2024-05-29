//
//  MovieCellViewModel.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation

class MovieCellViewModel {
    
    let id: Int
    let title: String
    let releaseDate: Date
    let posterUrl: URL
    
    init(id: Int, title: String, releaseDate: Date, posterUrl: URL) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterUrl = posterUrl
    }
    
    var formattedReleaseDate: String {
        releaseDate.formatted(date: .abbreviated, time: .omitted)
    }
}
