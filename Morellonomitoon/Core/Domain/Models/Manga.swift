//
//  Manga.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import Foundation

public struct Manga: Codable, Equatable, Sendable, Identifiable {
    
    public let id: String               // unique slug/id from the source
    public let title: String
    public let authors: [String]
    public let artist: String?
    public let url: URL?
    public let thumbnailURL: URL?
    public let description: String?
    public let genres: [Genre]
    public let status: MangaStatus
    public let sourceID: String         // which source this manga comes from
    
    public let lastUpdated: Date?
    public let latestChapter: String?
    public let latestChapterURL: URL?
    public let firstChapter: String?
    public let firstChapterURL: URL?
    
    public let statistics: MangaStatistics?
    public let chapters: [Chapter]?
    
    public init(
        id: String,
        title: String,
        authors: [String] = [],
        artist: String? = nil,
        url: URL? = nil,
        thumbnailURL: URL? = nil,
        description: String? = nil,
        genres: [Genre] = [],
        status: MangaStatus = .unknown,
        sourceID: String,
        lastUpdated: Date? = nil,
        latestChapter: String? = nil,
        latestChapterURL: URL? = nil,
        firstChapter: String? = nil,
        firstChapterURL: URL? = nil,
        statistics: MangaStatistics? = nil,
        chapters: [Chapter]? = []
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.artist = artist
        self.url = url
        self.thumbnailURL = thumbnailURL
        self.description = description
        self.genres = genres
        self.status = status
        self.sourceID = sourceID
        self.lastUpdated = lastUpdated
        self.latestChapter = latestChapter
        self.latestChapterURL = latestChapterURL
        self.firstChapter = firstChapter
        self.firstChapterURL = firstChapterURL
        self.statistics = statistics
        self.chapters = chapters
    }
}

public struct MangaStatistics: Codable, Equatable, Sendable {
    public let views: Int
    public let rating: Double
    
    public init(views: Int, rating: Double) {
        self.views = views
        self.rating = rating
    }
}

public enum MangaStatus: String, Codable, Equatable, Sendable {
    case ongoing
    case completed
    case hiatus
    case cancelled
    case unknown
}

extension Manga {
    
    func copy(
        id: String? = nil,
        title: String? = nil,
        authors: [String]? = nil,
        artist: String? = nil,
        url: URL? = nil,
        thumbnailURL: URL? = nil,
        description: String? = nil,
        genres: [Genre]? = nil,
        status: MangaStatus? = nil,
        sourceID: String? = nil,
        lastUpdated: Date? = nil,
        latestChapter: String? = nil,
        latestChapterURL: URL? = nil,
        statistics: MangaStatistics? = nil,
        chapters: [Chapter]? = nil
    ) -> Manga {
        Manga(
            id: id ?? self.id,
            title: title ?? self.title,
            authors: authors ?? self.authors,
            artist: artist ?? self.artist,
            url: url ?? self.url,
            thumbnailURL: thumbnailURL ?? self.thumbnailURL,
            description: description ?? self.description,
            genres: genres ?? self.genres,
            status: status ?? self.status,
            sourceID: sourceID ?? self.sourceID,
            lastUpdated: lastUpdated ?? self.lastUpdated,
            latestChapter: latestChapter ?? self.latestChapter,
            latestChapterURL: latestChapterURL ?? self.latestChapterURL,
            firstChapter: firstChapter ?? self.firstChapter,
            firstChapterURL: firstChapterURL ?? self.firstChapterURL,
            statistics: statistics ?? self.statistics,
            chapters: chapters ?? self.chapters
        )
    }
    
    var authorsString: String {
        authors.joined(separator: ", ")
    }
    
    var genresString: String {
        var genre = ""
        for i in 0..<genres.count {
            genre += genres[i].name
            
            if i < genres.count - 1 {
                genre += " • "
            }
        }
        
        return genre
    }
}

extension MangaStatistics {
    
    var viewCount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        
        return formatter.string(for: views) ?? ""
    }
    
    var ratingView: String {
        String(Int(rating.rounded(.up)))
    }
}
