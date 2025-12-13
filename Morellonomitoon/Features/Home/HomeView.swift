//
//  HomeView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    
    @Bindable var store: StoreOf<HomeFeature>
    @Namespace private var namespace
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Space.xl) {
                    switch store.loadingState {
                    case .loaded:
                        if let manga = store.featuredManga {
                            FeaturedCardView(
                                imageURL: manga.thumbnailURL,
                                title: manga.title,
                                chapter: manga.latestChapter ?? ""
                            )
                            .matchedTransitionSource(
                                id: manga.id,
                                in: namespace
                            )
                            .onTapGesture {
                                onNavigateManga(manga)
                            }
                        }
                        
                        if !store.popularDisplayed.isEmpty {
                            HorizontalMangaSectionView(
                                namespace: namespace,
                                title: "Popular Manga",
                                mangas: store.popularDisplayed
                            ) {
                                onNavigateManga($0)
                            }
                        }
                        
                        if !store.latestManga.isEmpty {
                            GridMangaSectionView(
                                namespace: namespace,
                                title: "Latest Manga Releases",
                                mangas: store.latestManga
                            ) {
                                onNavigateManga($0)
                            } seeAllAction: {
                                onNavigateGenericExplore(
                                    param: GenericExploreParam(
                                        id: "/manga-list/latest-manga",
                                        name: "Latest manga",
                                        type: .latest
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
            .navigationTitle("Morellonomitoon")
            .toolbarTitleDisplayMode(.inlineLarge)
            .sheet(item: $store.scope(
                state: \.destination?.settingSheet,
                action: \.destination.settingSheet
            )) { settingSheetStore in
                NavigationStack {
                    SettingSheet(store: settingSheetStore)
                }
            }
            .refreshable {
                store.send(.refresh)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.settingTapped)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .task {
                store.send(.onAppear)
            }
        } destination: { store in
            switch store.case {
            case .manga(let mangaStore):
                MangaView(namespace: namespace, store: mangaStore)
                    .navigationTransition(
                        .zoom(sourceID: self.store.matchedSourceID, in: namespace)
                    )
                
            case .reader(let readerStore):
                ReaderView(store: readerStore)
                    .navigationTransition(
                        .zoom(sourceID: self.store.matchedSourceID, in: namespace)
                    )
                
            case .genericExplore(let genericExploreStore):
                GenericExploreView(namespace: namespace, store: genericExploreStore)
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
    HomeView(
        store: Store(
            initialState: .init(),
            reducer: { HomeFeature() },
            withDependencies: {
                $0.sourceManager = MockSourceManager(
                    popular: MangaFixtures.popularManga,
                    latest: MangaFixtures.latestManga
                )
            }
        )
    )
}
