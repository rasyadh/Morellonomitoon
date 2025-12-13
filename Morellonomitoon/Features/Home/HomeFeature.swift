//
//  HomeFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HomeFeature {
    
    @ObservableState
    struct State: Equatable {
        var loadingState: LoadingState = .idle
        
        var popularManga: IdentifiedArrayOf<Manga> = []
        var latestManga: IdentifiedArrayOf<Manga> = []
        
        var featuredManga: Manga? {
            popularManga.first
        }
        var popularDisplayed: IdentifiedArrayOf<Manga> {
            IdentifiedArrayOf(uniqueElements: popularManga.dropFirst())
        }
        
        var matchedSourceID: String = ""
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }
    
    struct HomeMangaResponse: Equatable, Sendable {
        let popular: [Manga]
        let latest: [Manga]
    }
    
    enum Action {
        case onAppear
        case refresh
        case mangaResponse(Result<HomeMangaResponse, ResultError>)
        case mangaTapped(String)
        case genericExploreTapped(GenericExploreParam)
        case settingTapped
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
                
            case let .mangaResponse(.success(result)):
                state.popularManga = IdentifiedArrayOf(uniqueElements: result.popular)
                state.latestManga = IdentifiedArrayOf(uniqueElements: result.latest)
                state.loadingState = .loaded
                return .none
                
            case let .mangaResponse(.failure(error)):
                state.loadingState = .failed(error.localizedDescription)
                return .none
                
            case let .mangaTapped(slug):
                state.path.append(.manga(MangaFeature.State(id: slug)))
                return .none
                
            case let .genericExploreTapped(param):
                state.path.append(.genericExplore(GenericExploreFeature.State(
                    id: param.id,
                    name: param.name,
                    type: param.type
                )))
                return .none
                
            case .settingTapped:
                state.destination = .settingSheet(
                    SettingSheetFeature.State()
                )
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
                
            case let .path(.element(id: _, action: .genericExplore(.mangaTapped(id)))):
                state.matchedSourceID = id
                state.path.append(.manga(MangaFeature.State(id: id)))
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
                async let popular = sourceManager.current.fetchPopularManga()
                async let latest = sourceManager.current.fetchLatestManga(page: 1)
                
                let popularResults = try await popular
                let latestResults = try await latest
                
                let result = HomeMangaResponse(
                    popular: popularResults,
                    latest: latestResults
                )
                
                await send(.mangaResponse(.success(result)))
            } catch {
                await send(.mangaResponse(.failure(ResultError.from(error))))
            }
        }
    }
}

extension HomeFeature {
    
    @Reducer
    enum Path {
        case manga(MangaFeature)
        case reader(ReaderFeature)
        case genericExplore(GenericExploreFeature)
    }
    
    @Reducer
    enum Destination {
        case settingSheet(SettingSheetFeature)
    }
}

extension HomeFeature.Path.State: Equatable {}

extension HomeFeature.Destination.State: Equatable {}
