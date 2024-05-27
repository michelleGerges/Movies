//
//  Constants.swift
//  Movies
//
//  Created by Michelle on 27/05/2024.
//

import Foundation

class Constants {
    
    class Network {
        
        static let baseURL = "https://api.themoviedb.org"
        static let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNzkyOWY2M2UzNWY0YTJmNmU1NDM0MDJhZDBmZmNlZCIsInN1YiI6IjY2NTA5NzQ0ZmFiZmE2ZTQzYjA2OTlkOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.xVkNY70MtJ6jfn-7dM12Jx8Se419ZpfEWDsLyj3Hnmg"
        
        class EndPointPath {
            static let configuration = "/3/configuration"
            static let moviesList = "/3/movie"
            static let movieDetails = "/3/movie"
        }
    }
}
