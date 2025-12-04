//
//  GenericExploreFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 28/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GenericExploreFeature {
    
    @ObservableState
    struct State: Equatable {
        let id: String
        let name: String
        let type: GenericExploreType
        
        var loadingState: LoadingState = .idle
        var mangas: IdentifiedArrayOf<Manga> = []
        var mangaSourceID: String = ""
        
        var page: Int = 1
        let maxPage: Int = 10
        var isLoadingMore: Bool = false
    }
    
    enum Action {
        case onAppear
        case refresh
        case loadMore
        case mangaTapped(String)
        case mangaByGenreResponse(Result<[Manga], ResultError>)
    }
    
    @Dependency(\.sourceManager) private var sourceManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.loadingState == .loaded {
                    return .none
                }
                return .send(.refresh)
                
            case .refresh:
                state.loadingState = .loading
                return fetchGenerateById(id: state.id, type: state.type)
                
            case let .mangaTapped(id):
                state.mangaSourceID = id
                return .none
                
            case let .mangaByGenreResponse(.success(mangas)):
                if state.isLoadingMore {
                    state.mangas.append(contentsOf: IdentifiedArrayOf(uniqueElements: mangas))
                    state.isLoadingMore = false
                } else {
                    state.mangas = IdentifiedArrayOf(uniqueElements: mangas)
                }
                state.loadingState = .loaded
                return .none
                
            case let .mangaByGenreResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case .loadMore:
                if state.page >= state.maxPage {
                    state.isLoadingMore = false
                    return .none
                }
                
                if state.isLoadingMore { return .none }
                
                state.isLoadingMore = true
                state.page += 1
                return onLoadMore(id: state.id, type: state.type, page: state.page)
            }
        }
    }
    
    private func fetchGenerateById(id: String, type: GenericExploreType) -> Effect<Action> {
        switch type {
        case .genre:
            return fetchByGenre(id: id)
        default:
            return fetchBySlug(id: id, type: type)
        }
    }
    
    private func onLoadMore(id: String, type: GenericExploreType, page: Int) -> Effect<Action> {
        switch type {
        case .genre:
            return fetchByGenre(id: id, page: page)
        default:
            return fetchBySlug(id: id, type: type, page: page)
        }
    }
    
    private func fetchByGenre(id: String, page: Int = 1) -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                async let mangaTask = sourceManager.current.fetchMangaByGenre(id: id, page: page)
                let mangas = try await mangaTask
                
                await send(.mangaByGenreResponse(.success(mangas)))
            } catch {
                await send(.mangaByGenreResponse(.failure(ResultError.from(error))))
            }
        }
    }
    
    private func fetchBySlug(id: String, type: GenericExploreType, page: Int = 1) -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                var mangas: [Manga] = []
                
                switch type {
                case .latest:
                    async let mangaTask = await sourceManager.current.fetchLatestManga(page: page)
                    mangas = try await mangaTask
                case .hotest:
                    async let mangaTask = await sourceManager.current.fetchHotestManga(page: page)
                    mangas = try await mangaTask
                case .newest:
                    async let mangaTask = await sourceManager.current.fetchNewestManga(page: page)
                    mangas = try await mangaTask
                case .genre:
                    return
                }
                
                await send(.mangaByGenreResponse(.success(mangas)))
            } catch {
                await send(.mangaByGenreResponse(.failure(ResultError.from(error))))
            }
        }
    }
}
