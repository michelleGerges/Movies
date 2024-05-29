//
//  MovieDetailsCellViewModel.swift
//  Movies
//
//  Created by Michelle on 28/05/2024.
//

import Foundation

protocol MovieDetailsCellViewModel {
    
}

class MovieDetailsImageCellViewModel: MovieDetailsCellViewModel {
    let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
}

class MovieDetailsTitleValueCellViewModel: MovieDetailsCellViewModel {
    let title: String
    let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}

class MovieDetailsDescriptionCellViewModel: MovieDetailsCellViewModel {
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
