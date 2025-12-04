//
//  Page.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

public struct ChapterReader: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let mangaID: String
    public let mangaName: String
    public let chapterTitle: String
    public let chapterURL: URL?
    public let imageURLs: [URL]
    public let chapters: [Chapter]
    
    public let previousChapter: Chapter?
    public let nextChapter: Chapter?
    
    public init(
        id: String,
        mangaID: String,
        mangaName: String = "",
        chapterTitle: String = "",
        chapterURL: URL? = nil,
        imageURLs: [URL] = [],
        chapters: [Chapter] = [],
        previousChapter: Chapter? = nil,
        nextChapter: Chapter? = nil
    ) {
        self.id = id
        self.mangaID = mangaID
        self.mangaName = mangaName
        self.chapterTitle = chapterTitle
        self.chapterURL = chapterURL
        self.imageURLs = imageURLs
        self.chapters = chapters
        self.previousChapter = previousChapter
        self.nextChapter = nextChapter
    }
}
