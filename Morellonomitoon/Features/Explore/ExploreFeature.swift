//
//  ExploreFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ExploreFeature {
    
    @ObservableState
    struct State: Equatable {
        var loadingState: LoadingState = .idle
        
        var genre: IdentifiedArrayOf<Genre> = []
        var popularGenre: IdentifiedArrayOf<Genre> = []
        var hotestManga: IdentifiedArrayOf<Manga> = []
        var newestManga: IdentifiedArrayOf<Manga> = []
        
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        var matchedSourceID = ""
    }
    
    struct ExploreResponse: Equatable {
        let genre: [Genre]
        let popularGenre: [Genre]
        let hotest: [Manga]
        let newest: [Manga]
    }
    
    enum Action {
        case onAppear
        case refresh
        case exploreResponse(Result<ExploreResponse, ResultError>)
        
        case genreTapped(Genre)
        case seeAllGenreTapped
        case mangaTapped(String)
        case genericExploreTapped(GenericExploreParam)
        case setMatchedSourceID(String)
        
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
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
                return fetchAll()
                
            case let .exploreResponse(.success(result)):
                state.genre = IdentifiedArrayOf(uniqueElements: result.genre)
                state.popularGenre = IdentifiedArrayOf(uniqueElements: result.popularGenre)
                state.hotestManga = IdentifiedArrayOf(uniqueElements: result.hotest)
                state.newestManga = IdentifiedArrayOf(uniqueElements: result.newest)
                state.loadingState = .loaded
                return .none
                
            case let .exploreResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .genreTapped(genre):
                if genre.id == "all" {
                    return .send(.seeAllGenreTapped)
                } else {
                    return .send(.genericExploreTapped(
                        GenericExploreParam(id: genre.id, name: genre.name)
                    ))
                }
                
            case .seeAllGenreTapped:
                state.destination = .genreSheet(
                    GenreSheetFeature.State(genres: state.genre)
                )
                return .none
                
            case let .mangaTapped(slug):
                state.path.append(.manga(MangaFeature.State(id: slug)))
                return .none
                
            case let .genericExploreTapped(param):
                state.matchedSourceID = param.id
                state.path.append(.genericExplore(GenericExploreFeature.State(
                    id: param.id, name: param.name, type: param.type
                )))
                return .none
                
            case let .setMatchedSourceID(id):
                state.matchedSourceID = id
                return .none
                
            case let .path(.element(id: _, action: .genericExplore(.mangaTapped(id)))):
                state.matchedSourceID = id
                state.path.append(.manga(MangaFeature.State(id: id)))
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
                
            case let .destination(.presented(.genreSheet(.genreTapped(param)))):
                state.destination = nil
                state.path.append(.genericExplore(GenericExploreFeature.State(
                    id: param.id, name: param.name, type: .genre
                )))
                return .none
                
            case .path:
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
    
    private func fetchAll() -> Effect<Action> {
        .run { [sourceManager] send in
            do {
                async let genreTask = sourceManager.current.fetchGenre()
                async let hotestTask = sourceManager.current.fetchHotestManga(page: 1)
                async let newestTask = sourceManager.current.fetchNewestManga(page: 1)
                
                let genre = try await genreTask
                let hotest = try await hotestTask
                let newest = try await newestTask
                
                let result = ExploreResponse(
                    genre: genre.genres,
                    popularGenre: genre.popular,
                    hotest: hotest,
                    newest: newest
                )
                
                await send(.exploreResponse(.success(result)))
            } catch {
                await send(.exploreResponse(.failure(ResultError.from(error))))
            }
        }
    }
}

extension ExploreFeature {
    
    @Reducer
    enum Destination {
        case genreSheet(GenreSheetFeature)
    }
    
    @Reducer
    enum Path {
        case manga(MangaFeature)
        case genericExplore(GenericExploreFeature)
        case reader(ReaderFeature)
    }
}

extension ExploreFeature.Destination.State: Equatable {}

extension ExploreFeature.Path.State: Equatable {}
