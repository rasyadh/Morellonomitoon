//
//  ReaderFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 29/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ReaderFeature {
    
    @Dependency(\.sourceManager) private var sourceManager
    @Dependency(\.databaseService) private var databaseService
    
    @ObservableState
    struct State: Equatable {
        let mangaId: String
        var chapterId: String
        var reader: ChapterReader?
        
        var loadingState: LoadingState = .idle
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case onAppear
        case chapterToolbarTapped
        case previousChapterTapped(Chapter)
        case nextChapterTapped(Chapter)
        case updateBookmarkChapter
        case readerResponse(Result<ChapterReader, ResultError>)
        
        case destination(PresentationAction<Destination.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.loadingState = .loading
                return fetchChapterReader(mangaID: state.mangaId, chapterID: state.chapterId)
                
            case .chapterToolbarTapped:
                if let chapters = state.reader?.chapters {
                    state.destination = .chapterSheet(
                        ChapterSheetFeature.State(
                            currentChapterID: state.chapterId,
                            chapters: chapters
                        )
                    )
                }
                return .none
                
            case let .previousChapterTapped(chapter):
                state.reader = nil
                state.chapterId = chapter.id
                return .send(.onAppear)
                
            case let .nextChapterTapped(chapter):
                state.reader = nil
                state.chapterId = chapter.id
                return .send(.onAppear)
                
            case .updateBookmarkChapter:
                return updateBookmarkChapter(mangaID: state.mangaId, reader: state.reader)
                
            case let .readerResponse(.success(reader)):
                state.reader = reader
                state.loadingState = .loaded
                return .send(.updateBookmarkChapter)
                
            case let .readerResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .destination(.presented(.chapterSheet(.chapterTapped(chapter)))):
                state.destination = nil
                state.reader = nil
                state.chapterId = chapter.id
                return .send(.onAppear)
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    private func fetchChapterReader(mangaID: String, chapterID: String) -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                async let readerTask = sourceManager.current.fetchMangaChapters(
                    mangaID: mangaID, chapterID: chapterID
                )
                let reader = try await readerTask
                
                await send(.readerResponse(.success(reader)))
            } catch {
                await send(.readerResponse(.failure(ResultError.from(error))))
            }
        }
    }
    
    private func updateBookmarkChapter(mangaID: String, reader: ChapterReader?) -> Effect<Action> {
        .run { [databaseService] send in
            guard let reader = reader else { return }
            
            try await databaseService.updateBookmarkChapter(
                mangaID: mangaID,
                latestChapter: reader.chapterTitle,
                latestChapterURL: reader.chapterURL
            )
            
            return
        }
    }
}

extension ReaderFeature {
    
    @Reducer
    enum Destination {
        case chapterSheet(ChapterSheetFeature)
    }
}

extension ReaderFeature.Destination.State: Equatable {}
