//
//  NetworkClient.swift
//  Movies
//
//  Created by Michelle on 25/05/2024.
//

import Foundation

class NetworkClient {
    
    @Dependency private var urlSession: URLSession
    
    static var shared: NetworkClient = {
        NetworkClient()
    }()
    
    func request<T: Codable>(_ endPoint: EndPoint) async throws -> T {
        
        guard let url = URL(string: endPoint.fullURL) else {
            fatalError("Error: Invalid URL format")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request = requestWithBody(request, endPoint: endPoint)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            return try handleData(data, andResponse: response)
        } catch {
            throw (error as? ErrorHandler) ?? ErrorHandler.netowrk
        }
    }
    
    func handleData<T: Codable>(_ data: Data, andResponse response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ErrorHandler.serialization
        }
        do {
            if httpResponse.statusCode == 200 {
                return try JSONDecoder().decode(T.self, from: data)
            } else {
                print("Status Code:", httpResponse.statusCode)
                let error = try JSONDecoder().decode(ServerError.self, from: data)
                throw ErrorHandler.server(error: error)
            }
            
        } catch {
            print(error.localizedDescription)
            throw ErrorHandler.serialization
        }
    }
    
    func requestWithBody(_ request:URLRequest, endPoint: EndPoint) -> URLRequest {
        
        guard let body = endPoint.body else {
            return request
        }
        
        var request = request
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(body)
            request.httpBody = data
            return request
        } catch {
            fatalError("Error encoding dictionary to JSON: \(error)")
        }
    }
}
