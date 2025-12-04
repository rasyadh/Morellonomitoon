//
//  MangaEntity.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 01/12/25.
//

import Foundation
import SwiftData

@Model
public final class MangaEntity {
    
    @Attribute(.unique) public var id: String
    public var title: String
    public var url: URL?
    public var thumbnailURL: URL?
    public var sourceID: String
    public var createdAt: Date
    public var latestChapter: String?
    public var latestChapterURL: URL?

    public init(
        id: String,
        title: String,
        url: URL?,
        thumbnailURL: URL?,
        sourceID: String,
        createdAt: Date = .now,
        latestChapter: String? = nil,
        latestChapterURL: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.sourceID = sourceID
        self.createdAt = createdAt
        self.latestChapter = latestChapter
        self.latestChapterURL = latestChapterURL
    }
}
