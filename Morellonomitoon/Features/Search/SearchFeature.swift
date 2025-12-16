//
//  SearchFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 30/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SearchFeature {
    
    private let recentKey = "recent_searches"
    
    @ObservableState
    struct State: Equatable {
        var loadingState: LoadingState = .idle
        var query: String = ""
        var recentSearches: [String] = []
        var mangas: [Manga] = []
        
        var path = StackState<Path.State>()
        var matchedSourceID: String = ""
        
        var page: Int = 1
        var hasMore: Bool = true
        var isLoadingMore: Bool = false
    }
    
    enum Action: BindableAction {
        case onAppear
        case submitSearch(String)
        case clearRecent
        case recentSearchTapped(String)
        case cancelSearch
        case mangaTapped(String)
        case setMatchedSourceID(String)
        case searchResponse(Result<[Manga], ResultError>)
        case loadMore
        
        case binding(BindingAction<SearchFeature.State>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    enum CancelID {
        case search
    }
    
    @Dependency(\.userDefaults) var userDefaults
    @Dependency(\.sourceManager) private var sourceManager
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.loadingState == .loaded {
                    return .none
                }
                state.loadingState = .idle
                state.recentSearches = userDefaults.loadStringArray(recentKey)
                return .none
                
            case let .submitSearch(text):
                guard !text.isEmpty else { return .none }
                
                state.page = 1
                state.hasMore = true
                state.isLoadingMore = false
                state.mangas.removeAll()
                
                state.recentSearches.removeAll { $0 == text }
                state.recentSearches.insert(text, at: 0)
                state.recentSearches = Array(state.recentSearches.prefix(5))
                userDefaults.saveStringArray(recentKey, state.recentSearches)
                
                state.loadingState = .loading
                return fetchSearchManga(by: text)
                
            case .cancelSearch:
                state.mangas.removeAll()
                state.page = 1
                state.hasMore = true
                state.isLoadingMore = false
                state.loadingState = .idle
                return .send(.onAppear)
                
            case .clearRecent:
                state.recentSearches = []
                userDefaults.saveStringArray(recentKey, [])
                return .none
                
            case let .recentSearchTapped(text):
                state.query = text
                return .send(.submitSearch(text))
                
            case let .searchResponse(.success(result)):
                if result.isEmpty {
                    state.hasMore = false
                }
                
                if state.isLoadingMore {
                    state.mangas.append(contentsOf: result)
                    state.isLoadingMore = false
                } else {
                    state.mangas = result
                }
                state.loadingState = .loaded
                return .none
                
            case let .searchResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .mangaTapped(slug):
                state.path.append(.manga(MangaFeature.State(id: slug)))
                return .none
                
            case let .setMatchedSourceID(id):
                state.matchedSourceID = id
                return .none
                
            case let .path(.element(id: _, action: .manga(.chapterTapped(chapterParam)))):
                state.matchedSourceID = chapterParam.chapterID
                state.path.append(.reader(ReaderFeature.State(
                    mangaId: chapterParam.mangaID, chapterId: chapterParam.chapterID
                )))
                return .none
                
            case let .path(.element(id: _, action: .manga(.genreTapped(param)))):
                state.path.append(.genericExplore(GenericExploreFeature.State(
                    id: param.id,
                    name: param.name,
                    type: param.type
                )))
                return .none
                
            case let .path(.element(id: _, action: .genericExplore(.mangaTapped(id)))):
                state.matchedSourceID = id
                state.path.append(.manga(MangaFeature.State(id: id)))
                return .none
                
            case .loadMore:
                guard state.hasMore, !state.isLoadingMore else { return .none }
                state.isLoadingMore = true
                state.page += 1
                return fetchSearchManga(by: state.query, page: state.page)
                
            case .binding:
                return .none
                
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    private func fetchSearchManga(by keyword: String, page: Int = 1) -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                async let searchedManga = sourceManager.current.fetchSearchManga(query: keyword, page: page)
                let mangas = try await searchedManga
                
                await send(.searchResponse(.success(mangas)))
            } catch {
                await send(.searchResponse(.failure(ResultError.from(error))))
            }
        }
    }
}

extension SearchFeature {
    
    @Reducer
    enum Path {
        case manga(MangaFeature)
        case reader(ReaderFeature)
        case genericExplore(GenericExploreFeature)
    }
}

extension SearchFeature.Path.State: Equatable {}
