//
//  ExploreView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

struct ExploreView: View {
    
    @Bindable var store: StoreOf<ExploreFeature>
    @Namespace private var namespace
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Space.xl) {
                    switch store.loadingState {
                    case .loaded:
                        if !store.popularGenre.isEmpty {
                            GridGenreSectionView(
                                namespace: namespace,
                                genres: store.popularGenre
                            ) {
                                store.send(.setMatchedSourceID($0.id))
                                store.send(.genreTapped($0))
                            }
                        }
                        
                        if !store.hotestManga.isEmpty {
                            HorizontalMangaSectionView(
                                namespace: namespace,
                                title: "Hotest Manga",
                                mangas: store.hotestManga
                            ) {
                                onNavigateManga($0)
                            } seeAllAction: {
                                onNavigateGenericExplore(
                                    param: GenericExploreParam(
                                        id: "/manga-list/hot-manga", 
                                        name: "Hotest Manga",
                                        type: .hotest
                                    )
                                )
                            }
                        }
                        
                        if !store.newestManga.isEmpty {
                            HorizontalMangaSectionView(
                                namespace: namespace,
                                title: "Newest Manga",
                                mangas: store.newestManga
                            ) {
                                onNavigateManga($0)
                            } seeAllAction: {
                                onNavigateGenericExplore(
                                    param: GenericExploreParam(
                                        id: "/manga-list/new-manga", 
                                        name: "Newest Manga",
                                        type: .newest
                                    )
                                )
                            }
                        }
                        
                    case .failed(let message):
                        EmptyStateView(message: message)
                        
                    default:
                        LoadingView()
                    }
                }
                .padding(.top, Space.xs)
                .padding(.bottom, Space.lg)
            }
            .navigationTitle("Explore")
            .toolbarTitleDisplayMode(.inlineLarge)
            .refreshable {
                store.send(.refresh)
            }
            .sheet(item: $store.scope(
                state: \.destination?.genreSheet,
                action: \.destination.genreSheet
            )) { genreSheetStore in
                NavigationStack {
                    GenreSheetView(store: genreSheetStore)
                }
            }
            .task {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .manga(let mangaStore):
                MangaView(
                    namespace: namespace,
                    store: mangaStore
                )
                .navigationTransition(
                    .zoom(sourceID: self.store.matchedSourceID, in: namespace)
                )
                
            case .genericExplore(let genericExploreStore):
                GenericExploreView(
                    namespace: namespace,
                    store: genericExploreStore
                )
                .navigationTransition(
                    .zoom(sourceID: self.store.matchedSourceID, in: namespace)
                )
                
            case .reader(let readerStore):
                ReaderView(store: readerStore)
                    .navigationTransition(
                        .zoom(sourceID: self.store.matchedSourceID, in: namespace)
                    )
            }
        }
    }
    
    private func onNavigateManga(_ selected: Manga?) {
        if let manga = selected {
            store.send(.setMatchedSourceID(manga.id))
            store.send(.mangaTapped(manga.id))
        }
    }
    
    private func onNavigateGenericExplore(param: GenericExploreParam) {
        store.send(.genericExploreTapped(param))
    }
}

#Preview {
    ExploreView(
        store: Store(
            initialState: .init(),
            reducer: { ExploreFeature() },
            withDependencies: {
                $0.sourceManager = MockSourceManager(
                    hotest: MangaFixtures.popularManga,
                    newest: MangaFixtures.latestManga
                )
            }
        )
    )
}
