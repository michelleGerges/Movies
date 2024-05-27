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
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = endPoint.method.rawValue
        request = requestWithHeader(request, endPoint: endPoint)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            return try handleData(data, response: response)
        } catch {
            throw (error as? ErrorHandler) ?? ErrorHandler.netowrk
        }
    }
    
    private func handleData<T: Codable>(_ data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ErrorHandler.serialization
        }
        do {
            if httpResponse.statusCode == 200 {
                print(String(data: data, encoding: String.Encoding.utf8) ?? "NOT JSON")
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
    
    private func requestWithHeader(_ request:URLRequest, endPoint: EndPoint) -> URLRequest {
        
        guard let headerFields = endPoint.headerFields else {
            return request
        }
        
        var request = request

        request.allHTTPHeaderFields = request.allHTTPHeaderFields ?? [:]
        headerFields.forEach {
            request.allHTTPHeaderFields?[$0] = $1
        }
        
        return request
    }
}
