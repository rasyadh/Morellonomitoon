//
//  MangaFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 27/11/25.
//

import ComposableArchitecture
import Foundation
import SwiftData

@Reducer
struct MangaFeature {
    
    @Dependency(\.sourceManager) private var sourceManager
    @Dependency(\.databaseService) private var databaseService
    
    enum Sort: Equatable {
        case asc, desc
    }
    
    @ObservableState
    struct State: Equatable {
        let id: String
        var loadingState: LoadingState = .idle
        var manga: Manga = .init(id: "", title: "", sourceID: "")
        var sort: Sort = .desc
        var bookmark: Manga?
        
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case refresh
        case onMoreTapped
        case chapterTapped(ChapterParam)
        case sortTapped
        case bookmarkTapped
        case genreTapped(GenericExploreParam)
        
        case mangaResponse(Result<Manga, ResultError>)
        case settingLoaded(Setting?)
        case loadBookmark(String)
        case bookmarkLoaded(Manga?)
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.loadingState == .loaded {
                    return .send(.loadBookmark(state.manga.id))
                }
                return .send(.refresh)
                
            case .refresh:
                state.loadingState = .loading
                return fetchSetting()
                
            case .onMoreTapped:
                state.destination = .mangaInfoSheet(
                    MangaInfoSheetFeature.State(manga: state.manga)
                )
                return .none
                
            case .sortTapped:
                state.sort = state.sort == .asc ? .desc : .asc
                state.manga = state.manga.copy(
                    chapters: state.manga.chapters?.reversed()
                )
                return .none
                
            case .bookmarkTapped:
                return toggleBookmark(
                    manga: state.manga,
                    bookmarkMangaID: state.bookmark?.id
                )
                
            case let .mangaResponse(.success(result)):
                if state.sort == .asc {
                    state.manga = result.copy(
                        chapters: result.chapters?.reversed()
                    )
                } else {
                    state.manga = result
                }
                state.loadingState = .loaded
                return .send(.loadBookmark(result.id))
                
            case let .mangaResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .loadBookmark(id):
                return fetchBookmark(for: id)
                
            case let .bookmarkLoaded(bookmark):
                state.bookmark = bookmark
                return .none
                
            case let .settingLoaded(setting):
                state.sort = setting.isChapterAsc ? .asc : .desc
                return fetchManga(slug: state.id)
                
            case .chapterTapped:
                return .none
                
            case .genreTapped:
                return .none
                
            case let .destination(.presented(.mangaInfoSheet(.genreTapped(param)))):
                state.destination = nil
                return .send(.genreTapped(param))
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func fetchManga(slug: String) -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                async let mangaResponse = sourceManager.current.fetchManga(slug: slug)
                let manga = try await mangaResponse
                
                await send(.mangaResponse(.success(manga)))
            } catch {
                await send(.mangaResponse(.failure(ResultError.from(error))))
            }
        }
    }
    
    private func fetchBookmark(for id: String) -> Effect<Action> {
        .run { [databaseService] send in
            do {
                guard let bookmark = try await databaseService.fetchBookmark(mangaID: id) else {
                    await send(.bookmarkLoaded(nil))
                    
                    return
                }
                
                let mangaDto = MangaDTO(
                    id: bookmark.id,
                    title: bookmark.title,
                    url: bookmark.url,
                    thumbnailURL: bookmark.thumbnailURL,
                    sourceID: bookmark.sourceID,
                    latestChapter: bookmark.latestChapter,
                    latestChapterURL: bookmark.latestChapterURL
                )
                
                let manga = await MainActor.run {
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
                
                await send(.bookmarkLoaded(manga))
            } catch {
                await send(.bookmarkLoaded(nil))
            }
        }
    }
    
    private func toggleBookmark(manga: Manga, bookmarkMangaID: String?) -> Effect<Action> {
        .run { [databaseService] send in
            if let mangaID = bookmarkMangaID {
                try await databaseService.deleteBookmark(mangID: mangaID)
                await send(.bookmarkLoaded(nil))
            } else {
                try await databaseService.saveBookmark(manga: manga)
                await send(.loadBookmark(manga.id))
            }
        }
    }
    
    private func fetchSetting() -> Effect<Action> {
        .run { [databaseService] send in
            do {
                guard let setting = try await databaseService.fetchSetting() else {
                    await send(.settingLoaded(nil))
                    
                    return
                }
                await send(.settingLoaded(setting))
            } catch {
                await send(.settingLoaded(nil))
            }
        }
    }
}

extension MangaFeature {
    
    @Reducer
    enum Destination {
        case mangaInfoSheet(MangaInfoSheetFeature)
    }
}

extension MangaFeature.Destination.State: Equatable {}
