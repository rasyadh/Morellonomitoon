//
//  Chapter.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

public struct Chapter: Codable, Equatable, Sendable, Identifiable {
    public let id: String                      // unique slug
    public let mangaID: String                 // parent reference
    public let title: String
    public let view: Int
    public let url: URL?
    
    public let uploadedAt: String
    public let sourceID: String
    
    public init(
        id: String,
        mangaID: String,
        title: String,
        view: Int = 0,
        url: URL? = nil,
        uploadedAt: String = "",
        sourceID: String
    ) {
        self.id = id
        self.mangaID = mangaID
        self.title = title
        self.view = view
        self.url = url
        self.uploadedAt = uploadedAt
        self.sourceID = sourceID
    }
}

struct ChapterParam: Equatable {
    let mangaID: String
    let chapterID: String
}
