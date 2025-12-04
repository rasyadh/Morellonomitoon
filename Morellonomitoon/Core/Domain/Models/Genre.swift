//
//  Genre.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation
import SwiftUI

public struct Genre: Codable, Equatable, Sendable, Identifiable {
    
    public var id: String
    public let name: String
    public let url: URL?
    public let properties: GenreProperties
    
    public init(
        id: String,
        name: String,
        url: URL? = nil,
        properties: GenreProperties = GenreProperties(icon: "afa", colorHex: "fmksaf")
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.properties = properties
    }
}

public struct GenreProperties: Codable, Equatable, Sendable {
    
    public var icon: String
    public var colorHex: String
    
    public var color: Color { Color(hex: colorHex) }
    
    public init(
        icon: String,
        colorHex: String = "#9B9B9B"
    ) {
        self.icon = icon
        self.colorHex = colorHex
    }
}

public struct GenreResponse: Codable, Equatable, Sendable {
    let genres: [Genre]
    let popular: [Genre]
}

extension Genre {
        
    static let mapPopularGenre: [String: GenreProperties] = [
        "comedy": GenreProperties(
            icon: "face.smiling",
            colorHex: "#F8D34B"
        ),
        "drama": GenreProperties(
            icon: "theatermasks.fill",
            colorHex: "#A259FF"
        ),
        "fantasy": GenreProperties(
            icon: "sparkles",
            colorHex: "#4B63D1"
        ),
        "adventure": GenreProperties(
            icon: "figure.hiking",
            colorHex: "#FF8A34"
        ),
        "romance": GenreProperties(
            icon: "heart.fill",
            colorHex: "#FF4B4B"
        )
    ]
    
    static let seeAll: Genre = Genre(
        id: "all",
        name: "See all",
        properties: GenreProperties(
            icon: "ellipsis.circle",
            colorHex: "#9B9B9B"
        )
    )
    
    static let excludeGenreNames: Set<String> = Set([
        "newest" , "latest", "top read", "all", "completed", "ongoing"]
    )
}

extension GenreProperties {
    static let `default`: GenreProperties = GenreProperties(
        icon: "info.circle",
        colorHex: "#9B9B9B"
    )
    
    static func properties(for genreId: String) -> GenreProperties {
        Genre.mapPopularGenre[genreId] ?? .default
    }
}
