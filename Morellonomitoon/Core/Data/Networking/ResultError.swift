//
//  ResultError.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 22/11/25.
//

import Foundation

enum ResultError: Equatable, Error {
    case message(String)
    
    static func from(_ error: Error) -> ResultError {
        let errorMessage = error.localizedDescription
        
        return .message(errorMessage)
    }
}
