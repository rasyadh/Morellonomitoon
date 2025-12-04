//
//  BookmarkFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 30/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BookmarkFeature {
    
    @Dependency(\.databaseService) private var databaseService
    
    @ObservableState
    struct State: Equatable {
        var loadingState: LoadingState = .idle
        var bookmarks: [Manga] = []
        
        var path = StackState<Path.State>()
        var matchedSourceID: String = ""
    }
    
    enum Action {
        case onAppear
        case bookmarkResponse(Result<[Manga], ResultError>)
        case mangaTapped(String)
        case setMatchedSourceID(String)
        
        case path(StackAction<Path.State, Path.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loadingState = .loading
                return fetchBookmarks()
                
            case let .bookmarkResponse(.success(result)):
                state.bookmarks = result
                state.loadingState = .loaded
                return .none
                
            case let .bookmarkResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .setMatchedSourceID(id):
                state.matchedSourceID = id
                return .none
                
            case let .mangaTapped(slug):
                state.matchedSourceID = slug
                state.path.append(.manga(MangaFeature.State(id: slug)))
                return .none
                
            case let .path(.element(id: _, action: .manga(.chapterTapped(chapterParam)))):
                state.matchedSourceID = chapterParam.chapterID
                state.path.append(.reader(ReaderFeature.State(
                    mangaId: chapterParam.mangaID, chapterId: chapterParam.chapterID
                )))
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    private func fetchBookmarks() -> Effect<Action> {
        .run { [databaseService] send in
            do {
                let bookmarks = try await databaseService.fetchBookmarks()
                
                let mangaDtos = bookmarks.map { bookmark in
                    MangaDTO(
                        id: bookmark.id,
                        title: bookmark.title,
                        url: bookmark.url,
                        thumbnailURL: bookmark.thumbnailURL,
                        sourceID: bookmark.sourceID,
                        latestChapter: bookmark.latestChapter,
                        latestChapterURL: bookmark.latestChapterURL
                    )
                }
                
                let mangas = await MainActor.run {
                    mangaDtos.map { mangaDto in
                        Manga(
                            id: mangaDto.id,
                            title: mangaDto.title,
                            url: mangaDto.url,
                            thumbnailURL: mangaDto.thumbnailURL,
                            sourceID: mangaDto.sourceID,
                            latestChapter: mangaDto.latestChapter,
                            latestChapterURL: mangaDto.latestChapterURL
                        )
                    }
                }
                
                await send(.bookmarkResponse(.success(mangas)))
            } catch {
                await send(.bookmarkResponse(.failure(ResultError.from(error))))
            }
        }
    }
}

extension BookmarkFeature {
    
    @Reducer
    enum Path {
        case manga(MangaFeature)
        case reader(ReaderFeature)
    }
}

extension BookmarkFeature.Path.State: Equatable {}
