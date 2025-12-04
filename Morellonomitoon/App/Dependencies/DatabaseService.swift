//
//  DatabaseService.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 01/12/25.
//

import ComposableArchitecture
import Foundation
import SwiftData

@MainActor
struct DatabaseService {
    
    var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchBookmarks() throws -> [MangaEntity] {
        let descriptor = FetchDescriptor<MangaEntity>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
    
    func fetchBookmark(mangaID: String) throws -> MangaEntity? {
        var descriptor = FetchDescriptor<MangaEntity>(
            predicate: #Predicate<MangaEntity>{ $0.id == mangaID }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }
    
    func saveBookmark(manga: Manga) throws {
        let newBookmark = MangaEntity(
            id: manga.id,
            title: manga.title,
            url: manga.url,
            thumbnailURL: manga.thumbnailURL,
            sourceID: manga.sourceID,
            createdAt: .now,
            latestChapter: manga.latestChapter,
            latestChapterURL: manga.latestChapterURL
        )
        context.insert(newBookmark)
        try context.save()
    }
    
    func deleteBookmark(mangID: String) throws {
        if let bookmark = try fetchBookmark(mangaID: mangID) {
            context.delete(bookmark)
            try context.save()
        }
    }
    
    func updateBookmarkChapter(mangaID: String, latestChapter: String, latestChapterURL: URL?) throws {
        let selectedBookmark = try fetchBookmark(mangaID: mangaID)
        if let bookmark = selectedBookmark {
            bookmark.latestChapter = latestChapter
            bookmark.latestChapterURL = latestChapterURL
            bookmark.createdAt = .now
            try context.save()
        }
    }
}

extension DependencyValues {
    
    var databaseService: DatabaseService {
        get { self[DatabaseServiceKey.self] }
        set { self[DatabaseServiceKey.self] = newValue }
    }
}

private struct DatabaseServiceKey: DependencyKey {
    
    static let liveValue: DatabaseService = {
        do {
            // Configure your model container for the live environment
            let container = try ModelContainer(for: MangaEntity.self)
            return DatabaseService(context: ModelContext(container))
        } catch {
            fatalError()
        }
    }()
    
    // Provide a test value for unit testing
    static var testValue: DatabaseService {
        do {
            // In a test environment, you can use an in-memory container
            let container = try ModelContainer(
                for: MangaEntity.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            return DatabaseService(context: ModelContext(container))
        } catch {
            fatalError()
        }
    }
}
