//
//  MockSourceClient.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import Foundation
import Nuke

final class MockSourceClient: MangaSource {
    
    var baseUrl: String { "https://example.com"}
    
    var sourceID: String { "mock" }
    
    var imagePipeline: ImagePipeline = {
        return ImagePipeline()
    }()
    
    // MARK: - Mock data
    
    var mockPopular: [Manga] = []
    var mockLatest: [Manga] = []
    var mockHotest: [Manga] = []
    var mockNewest: [Manga] = []
    var mockChapterReader: ChapterReader = ChapterReader(id: "", mangaID: "")
    
    // MARK: - Popular Manga
    
    func fetchPopularManga() async throws -> [Manga] {
        return mockPopular
    }
    
    // MARK: - Latest Manga
    
    func fetchLatestManga(page: Int) async throws -> [Manga] {
        return mockLatest
    }
    
    // MARK: - Hotest Manga
    
    func fetchHotestManga(page: Int) async throws -> [Manga] {
        return mockHotest
    }
    
    // MARK: - Newest Manga
    
    func fetchNewestManga(page: Int) async throws -> [Manga] {
        return mockNewest
    }
    
    // MARK: - Genre
    
    func fetchGenre() async throws -> GenreResponse {
        return GenreResponse(
            genres: GenreFixtures.genres,
            popular: GenreFixtures.genres
        )
    }
    
    // MARK: - Manga
    
    func fetchManga(slug: String) async throws -> Manga {
        return MangaFixtures.manga
    }
    
    // MARK: - Manga by Genre
    
    func fetchMangaByGenre(id: String, page: Int) async throws -> [Manga] {
        return mockLatest
    }
    
    // MARK: - Manga Chapter
    
    func fetchMangaChapters(mangaID: String, chapterID: String) async throws -> ChapterReader {
        return mockChapterReader
    }
    
    // MARK: - Search Manga
    
    func fetchSearchManga(query: String, page: Int) async throws -> [Manga] {
        return mockLatest
    }
}
