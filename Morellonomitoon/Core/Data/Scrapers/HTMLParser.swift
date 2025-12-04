//
//  HTMLParser.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation
import SwiftSoup

enum HTMLParserError: Error {
    case parseFailed
    case elementNotFound
}

final class HTMLParser {
    
    static func document(from data: Data) throws -> Document {
        guard let html = String(data: data, encoding: .utf8) else {
            throw HTMLParserError.parseFailed
        }
        
        return try SwiftSoup.parse(html)
    }
    
    static func text(_ document: Document, selector: String) throws -> String {
        guard let element = try document.select(selector).first() else {
            throw HTMLParserError.elementNotFound
        }
        
        return try element.text()
    }
    
    static func links(_ document: Document, selector: String) throws -> [String] {
        let elements = try document.select(selector)
        
        return try elements.array().compactMap { element in
            let href = try element.attr("href")
            
            return href.isEmpty ? nil : href
        }
    }
}
