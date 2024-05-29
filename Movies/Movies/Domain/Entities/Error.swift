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
    
    private var generalErrorMessage: String {
        "Something went wrong. Kindly try again later!"
    }
    
    var message: String {
        guard let errorHandler = self as? ErrorHandler else {
            return generalErrorMessage
        }
        
        switch errorHandler {
        case .netowrk:
            return "Network Error, Kindly check Internet connectivity!"
        case .serialization:
            return generalErrorMessage
        case .server(let error):
            return error.message ?? generalErrorMessage
        }
    }
}

