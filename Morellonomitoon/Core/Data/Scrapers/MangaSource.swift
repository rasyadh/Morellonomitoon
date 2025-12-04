//
//  MangaSource.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation
import Nuke

protocol MangaSource {
    
    var baseUrl: String { get }
    
    var sourceID: String { get }
    
    var imagePipeline: ImagePipeline { get }
    
    func fetchPopularManga() async throws -> [Manga]
    
    func fetchLatestManga(page: Int) async throws -> [Manga]
    
    func fetchHotestManga(page: Int) async throws -> [Manga]
    
    func fetchNewestManga(page: Int) async throws -> [Manga]
    
    func fetchGenre() async throws -> GenreResponse
    
    func fetchManga(slug: String) async throws -> Manga
    
    func fetchMangaByGenre(id: String, page: Int) async throws -> [Manga]
    
    func fetchMangaChapters(mangaID: String, chapterID: String) async throws -> ChapterReader
    
    func fetchSearchManga(query: String, page: Int) async throws -> [Manga]
}

enum MangaFetcherError: Error {
    case missingRequiredData
    case invalidURL
}
