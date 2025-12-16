//
//  HttpClient.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case noData
}

final class HttpClient: Sendable {
    func send(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // Treat 404 as "no more data"
        if http.statusCode == 404 {
            return Data()
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        return data
    }
}
