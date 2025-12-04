//
//  RequestBuilder.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

enum RequestError: Error {
    case invalidURL
}

struct RequestBuilder {
    
    static func get(
        urlString: String,
        headers: [String: String] = [:]
    ) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw RequestError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(UserAgent.default, forHTTPHeaderField: "User-Agent")
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
