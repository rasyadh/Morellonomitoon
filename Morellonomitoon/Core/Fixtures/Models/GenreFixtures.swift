//
//  GenreFixtures.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation

enum GenreFixtures {
    
    static let genres: [Genre] = [
        Genre(
            id: "comedy",
            name: "Comedy",
            url: URL(string: "https://mangabats.com/genre/comedy"),
            properties: GenreProperties(
                icon: "face.smiling",
                colorHex: "#F8D34B"
            )
        ), // yellow
        Genre(
            id: "drama",
            name: "Drama",
            url: URL(string: "https://mangabats.com/genre/drama"),
            properties: GenreProperties(
                icon: "theatermasks.fill",
                colorHex: "#A259FF"
            )
        ), // purple
        Genre(
            id: "fantasy",
            name: "Fantasy",
            url: URL(string: "https://mangabats.com/genre/drama"),
            properties: GenreProperties(
                icon: "sparkles",
                colorHex: "#4B63D1"
            )
        ), // indigo
        Genre(
            id: "adventure",
            name: "Adventure",
            url: URL(string: "https://mangabats.com/genre/adventure"),
            properties: GenreProperties(
                icon: "figure.hiking",
                colorHex: "#FF8A34"
            )
        ), // orange
        Genre(
            id: "romance",
            name: "Romance",
            url: URL(string: "https://mangabats.com/genre/romance"),
            properties: GenreProperties(
                icon: "heart.fill",
                colorHex: "#FF4B4B"
            )
        ), // red
        Genre(
            id: "all",
            name: "See all",
            url: URL(string: "https://mangabats.com/genre/all"),
            properties: GenreProperties(
                icon: "ellipsis.circle",
                colorHex: "#9B9B9B"
            )
        )  // gray
    ]
}
