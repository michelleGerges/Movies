//
//  Error.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

enum ErrorHandler: Error {
    case netowrk
    case serialization
    case server(error: ServerError)
}

struct ServerError: Codable {
    
    let code: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}

extension Error {
    var message: String {
        guard let errorHandler = self as? ErrorHandler else {
            return "Something went wrong."
        }
        
        switch errorHandler {
        case .netowrk:
            return "Network Error"
        case .serialization:
            return "Something went wrong"
        case .server(let error):
            return error.message ?? "Something went wrong"
        }
    }
}

