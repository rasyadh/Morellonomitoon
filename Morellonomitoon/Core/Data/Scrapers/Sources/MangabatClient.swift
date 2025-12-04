//
//  MangabatClient.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import Foundation
import Nuke
import SwiftSoup

final class MangabatClient: MangaSource {
    
    var baseUrl: String { "https://www.mangabats.com"}
    
    var sourceID: String { "mangabats" }
    
    var imagePipeline: ImagePipeline = {
        var config = ImagePipeline.Configuration()
        
        config.imageCache = ImageCache.shared
        config.dataCache = try? DataCache(name: "com.morellonomitoon.mangabats.images")
        
        config.dataLoader = {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = [
                "Referer": "https://www.mangabats.com/"
            ]
            
            return DataLoader(configuration: config)
        }()
        
        return ImagePipeline(configuration: config)
    }()
    
    private let http = HttpClient()
    
    private func createURLRequest(urlString: String) throws -> URLRequest {
        return try RequestBuilder.get(
            urlString: urlString,
            headers: ["Referer": "https://www.mangabats.com/"]
        )
    }
    
    // MARK: - Popular Manga
    
    func fetchPopularManga() async throws -> [Manga] {
        let request = try createURLRequest(urlString: baseUrl)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        let items = try doc.select("div#owl-demo.owl-carousel > div.item")
        
        var results: [Manga] = []
        
        for item in items {
            let imgEl = try item.select("img").first()
            let imageUrl = try imgEl?.attr("src") ?? ""
            
            let mangaAnchor = try item.select("div.slide-caption > h3 > a").first()
            let title = try mangaAnchor?.attr("title") ?? ""
            let mangaUrl = try mangaAnchor?.attr("href") ?? ""
            
            let chapterAnchor = try item.select("div.slide-caption > a").first()
            let latestChapter = try chapterAnchor?.text() ?? ""
            let latestChapterUrl = try chapterAnchor?.attr("href") ?? ""
            
            guard
                !title.isEmpty,
                !mangaUrl.isEmpty,
                let thumbnailURL = URL(string: imageUrl),
                let url = URL(string: mangaUrl),
                let slugID = url.extractMangabatSlug,
                let latestChapterURL = URL(string: latestChapterUrl) else {
                continue
            }
            
            let manga = Manga(
                id: slugID,
                title: title,
                url: url,
                thumbnailURL: thumbnailURL,
                sourceID: sourceID,
                latestChapter: latestChapter,
                latestChapterURL: latestChapterURL
            )
            
            results.append(manga)
        }
        
        return results
    }
    
    // MARK: - Latest Manga
    
    func fetchLatestManga(page: Int = 1) async throws -> [Manga] {
        var url = "\(baseUrl)/manga-list/latest-manga"
        if page > 1 {
            url += "?page=\(page)"
        }
        
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        return try await parseMangaItems(document: doc)
    }
    
    // MARK: - Hotest Manga
    
    func fetchHotestManga(page: Int = 1) async throws -> [Manga] {
        var url = "\(baseUrl)/manga-list/hot-manga"
        if page > 1 {
            url += "?page=\(page)"
        }
        
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        return try await parseMangaItems(document: doc)
    }
    
    // MARK: - Newest Manga
    
    func fetchNewestManga(page: Int = 1) async throws -> [Manga] {
        var url = "\(baseUrl)/manga-list/new-manga"
        if page > 1 {
            url += "?page=\(page)"
        }
        
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        return try await parseMangaItems(document: doc)
    }
    
    // MARK: - Genre
    
    func fetchGenre() async throws -> GenreResponse {
        let request = try createURLRequest(urlString: baseUrl)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        let items = try doc.select("div.panel-category > table > tbody > tr > td > a")
        
        var results: [Genre] = []
        
        for item in items {
            let title = try item.text()
            let href = try item.attr("href")
            
            if Genre.excludeGenreNames.contains(title.lowercased()) {
                continue
            }
            
            guard let url = URL(string: href) else {
                continue
            }
            
            results.append(
                Genre(
                    id: title.slugified(),
                    name: title,
                    url: url,
                    properties: GenreProperties.properties(for: title.slugified())
                )
            )
        }
        
        var filteredGenre: [Genre] = results.filter { Genre.mapPopularGenre[$0.id] != nil }
        filteredGenre.append(Genre.seeAll)
        
        return GenreResponse(
            genres: results,
            popular: filteredGenre
        )
    }
    
    // MARK: - Manga
    
    func fetchManga(slug: String) async throws -> Manga {
        let mangaUrl = "\(baseUrl)/manga/\(slug)"
        let request = try createURLRequest(urlString: mangaUrl)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        let mangaInfoPicEl = try doc.select("div.manga-info-top")

        let imgEl = try mangaInfoPicEl.select("div.manga-info-pic > img").first()
        let imageUrl = try imgEl?.attr("src") ?? ""
        
        let mangaInfoTextEl = try doc.select("div.manga-info-content > ul.manga-info-text")
        
        let title = try mangaInfoTextEl.select("li:nth-child(1) > h1").text()
        let authorsText = try mangaInfoTextEl.select("li:nth-child(2)").text()
        let authorSubstring = authorsText.components(separatedBy: ": ").last ?? ""
        var authors: [String] = []
        if !authorSubstring.lowercased().contains("author") {
            authors = authorSubstring.components(separatedBy: ", ")
        }
        
        let statusText = try mangaInfoTextEl.select("li:nth-child(3)").text()
        let statusString = statusText.components(separatedBy: ": ").last ?? ""
        let mangaStatus = MangaStatus(rawValue: statusString.lowercased())
        
        let viewsText = try mangaInfoTextEl.select("li:nth-child(6)").text()
        let viewsString = viewsText.components(separatedBy: ": ").last ?? ""
        let viewsNum = viewsString.replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let viewsNumber = formatter.number(from: viewsNum)
        
        var genres: [Genre] = []
        let genreAnchors = try mangaInfoTextEl.select("li:nth-child(7).genres > a")
        for genreAnchor in genreAnchors {
            let title = try genreAnchor.text().trim()
            let href = try genreAnchor.attr("href")
            
            guard let url = URL(string: href) else {
                continue
            }
            
            genres.append(
                Genre(
                    id: title.slugified(),
                    name: title,
                    url: url,
                    properties: GenreProperties.properties(for: title.slugified())
                )
            )
        }
        
        let ratingText = try doc.select("em#rate_row_cmd").text()
        let ratingComponent = ratingText.components(separatedBy: " : ").last ?? ""
        let ratingString = ratingComponent.components(separatedBy: " / ").first ?? ""
        
        let description = try doc.select("div#contentBox").text()
        
        let chapterAnchor = try doc.select("div.read-chapter").first()
        let firstChapterUrl = try chapterAnchor?.select("a").first()?.attr("href") ?? ""
        let firstChapter = firstChapterUrl.components(separatedBy: "/").last?
            .replacingOccurrences(of: "-", with: " ").capitalized ?? ""
        let latestChapterUrl = try chapterAnchor?.select("a").last()?.attr("href") ?? ""
        let latestChapter = latestChapterUrl.components(separatedBy: "/").last?
            .replacingOccurrences(of: "-", with: " ").capitalized ?? ""
        
        guard
            !title.isEmpty,
            !mangaUrl.isEmpty,
            let thumbnailURL = URL(string: imageUrl),
            let url = URL(string: mangaUrl)
        else {
            throw MangaFetcherError.missingRequiredData
        }
        
        let chapters = try await parseChapterList(mangaId: slug, document: doc)
        
        return Manga(
            id: slug,
            title: title,
            authors: authors,
            url: url,
            thumbnailURL: thumbnailURL,
            description: description,
            genres: genres,
            status: mangaStatus ?? MangaStatus.unknown,
            sourceID: sourceID,
            latestChapter: latestChapter,
            latestChapterURL: URL(string: latestChapterUrl),
            firstChapter: firstChapter,
            firstChapterURL: URL(string: firstChapterUrl),
            statistics: MangaStatistics(
                views: viewsNumber?.intValue ?? 0,
                rating:  Double(ratingString) ?? 0.0
            ),
            chapters: chapters
        )
    }
    
    // MARK: - Manga by Genre
    
    func fetchMangaByGenre(id: String, page: Int = 1) async throws -> [Manga] {
        var url = "\(baseUrl)/genre/\(id)"
        if page > 1 {
            url += "?page=\(page)"
        }
        
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        return try await parseMangaItems(document: doc)
    }
    
    // MARK: - Manga Chapter
    
    func fetchMangaChapters(mangaID: String, chapterID: String) async throws -> ChapterReader {
        let url = "\(baseUrl)/manga/\(mangaID)/\(chapterID)"
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        let breadcrumbEl = try doc.select("div.breadcrumb.breadcrumbs.bred_doc > p")
        let mangaName = try breadcrumbEl.select("span:nth-child(3) > a > span").text()
        let chapterTitle = try breadcrumbEl.select("span:nth-child(5) > a > span").text()
        
        let readerEl = try doc.select("div.container-chapter-reader > img")
        var imageURLs: [URL] = []
        
        for el in readerEl {
            let url = try el.attr("src")
            
            if let imageURL = URL(string: url) {
                imageURLs.append(imageURL)
            }
        }
        
        let optionWrapEl = try doc.select("div.option_wrap").first()
        let chapterElOpt = try optionWrapEl?.select("select.navi-change-chapter > option")
        var chapters: [Chapter] = []
        
        if let chapterEl = chapterElOpt {
            for el in chapterEl {
                let title = try el.text()
                let url = try el.attr("data-c")
                let id = url.components(separatedBy: "/").last ?? ""
                
                if let url = URL(string: "\(baseUrl)\(url)") {
                    chapters.append(
                        Chapter(id: id, mangaID: mangaID, title: title, url: url, sourceID: sourceID)
                    )
                }
            }
        }
        
        var prevChapter: Chapter? = nil
        let previousHref = try doc.select("div.btn-navigation-chap > a.next").attr("href")
        if !previousHref.isEmpty, let prevURL = URL(string: "\(baseUrl)\(previousHref)") {
            let prevId = previousHref.components(separatedBy: "/").last ?? ""
            prevChapter = Chapter(
                id: prevId, mangaID: mangaID, title: prevId, url: prevURL, sourceID: sourceID
            )
        }
        
        var nextChapter: Chapter? = nil
        let nextHref = try doc.select("div.btn-navigation-chap > a.back").attr("href")
        if !nextHref.isEmpty, let nextURL = URL(string: "\(baseUrl)\(nextHref)") {
            let nextID = nextHref.components(separatedBy: "/").last ?? ""
            nextChapter = Chapter(
                id: nextID, mangaID: mangaID, title: nextID, url: nextURL, sourceID: sourceID
            )
        }
        
        return ChapterReader(
            id: chapterID,
            mangaID: mangaID,
            mangaName: mangaName,
            chapterTitle: chapterTitle,
            chapterURL: URL(string: url),
            imageURLs: imageURLs,
            chapters: chapters,
            previousChapter: prevChapter,
            nextChapter: nextChapter
        )
    }
    
    // MARK: - Search Manga
    
    func fetchSearchManga(query: String, page: Int = 1) async throws -> [Manga] {
        let encodedQuery = query.lowercased().trim().toUnderscore()
        var url = "\(baseUrl)/search/story/\(encodedQuery)"
        if page > 1 {
            url += "?page=\(page)"
        }
        
        let request = try createURLRequest(urlString: url)
        let data = try await http.send(request)
        let doc = try HTMLParser.document(from: data)
        
        let items = try doc.select("div.panel_story_list > div.story_item")
        
        var results: [Manga] = []
        
        for item in items {
            let anchor = try item.select("a").first()
            let imageUrl = try anchor?.select("img").attr("src")
            let mangaUrl = try anchor?.attr("href") ?? ""
            
            let rightEl = try item.select("div.story_item_right")
            let title = try rightEl.select("h3.story_name > a").text()
            
            let chapterAnchor = try rightEl.select("em.story_chapter > a").first()
            let latestChapter = try chapterAnchor?.attr("title")
            let latestChapterUrl = try chapterAnchor?.attr("href") ?? ""
            
            guard
                !title.isEmpty,
                !mangaUrl.isEmpty,
                let imageURL = imageUrl,
                let thumbnailURL = URL(string: imageURL),
                let url = URL(string: mangaUrl),
                let slugID = url.extractMangabatSlug,
                let latestChapterURL = URL(string: latestChapterUrl)
            else {
                continue
            }
            
            let manga = Manga(
                id: slugID,
                title: title,
                url: url,
                thumbnailURL: thumbnailURL,
                sourceID: sourceID,
                latestChapter: latestChapter,
                latestChapterURL: latestChapterURL
            )
            results.append(manga)
        }
        
        return results
    }
}

extension MangabatClient {
    
    private func parseMangaItems(document doc: Document) async throws -> [Manga] {
        let items = try doc.select("div.comic-list > div.list-comic-item-wrap")
        
        var results: [Manga] = []
        
        for item in items {
            let imgEl = try item.select("a > img").first()
            let imageUrl = try imgEl?.attr("src") ?? ""
            
            let mangaAnchor = try item.select("h3 > a").first()
            let title = try mangaAnchor?.attr("title") ?? ""
            let mangaUrl = try mangaAnchor?.attr("href") ?? ""
            
            let chapterAnchor = try item.select("a.list-story-item-wrap-chapter").first()
            let latestChapter = try chapterAnchor?.text() ?? ""
            let latestChapterUrl = try chapterAnchor?.attr("href") ?? ""
            
            let description = try item.select("p").first()?.text() ?? ""
            
            guard
                !title.isEmpty,
                !mangaUrl.isEmpty,
                let thumbnailURL = URL(string: imageUrl),
                let url = URL(string: mangaUrl),
                let slugID = url.extractMangabatSlug,
                let latestChapterURL = URL(string: latestChapterUrl)
            else {
                continue
            }
            
            let manga = Manga(
                id: slugID,
                title: title,
                url: url,
                thumbnailURL: thumbnailURL,
                description: description,
                sourceID: sourceID,
                latestChapter: latestChapter,
                latestChapterURL: latestChapterURL
            )
            
            results.append(manga)
        }
        
        return results
    }
    
    private func parseChapterList(mangaId: String, document doc: Document) async throws -> [Chapter] {
        let items = try doc.select("div.chapter-list > div.row")
        
        var results: [Chapter] = []
        
        for item in items {
            let anchor = try item.select("span:nth-child(1) > a")
            let title = try anchor.text()
            let chapterUrl = try anchor.attr("href")
            let id = title.slugified()
            
            let viewsText = try item.select("span:nth-child(2)").text().trim()
            let viewsNum = viewsText.replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: ".", with: "")
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let viewsNumber = formatter.number(from: viewsNum)
            
            let timeUploadedText = try item.select("span:nth-child(3)").attr("title")
            
            guard
                !title.isEmpty,
                !chapterUrl.isEmpty,
                !id.isEmpty,
                let url = URL(string: chapterUrl)
            else {
                continue
            }
            
            let chapter = Chapter(
                id: id,
                mangaID: mangaId,
                title: title,
                view: viewsNumber?.intValue ?? 0,
                url: url,
                uploadedAt: timeUploadedText,
                sourceID: sourceID
            )
            
            results.append(chapter)
        }
        
        return results
    }
}

extension URL {
    /// Extracts the manga slug from a URL like:
    /// https://www.mangabats.com/manga/one-piece
    var extractMangabatSlug: String? {
        let components = path
            .split(separator: "/")
            .map { String($0) }
        
        // Expected: ["manga", "one-piece"]
        guard components.count >= 2 else {
            return nil
        }
        
        guard components.contains("manga") else {
            return nil
        }
        
        return components.last
    }
}

extension String {
    func slugified() -> String {
        self
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9]+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
    }
}
