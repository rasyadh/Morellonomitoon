//
//  SearchView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    
    @Bindable var store: StoreOf<SearchFeature>
    @Namespace private var namespace
    @Environment(\.isSearching) private var isSearching: Bool
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            VStack {
                switch store.loadingState {
                case .loaded:
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: Space.lg),
                                GridItem(.flexible(), spacing: Space.lg),
                                GridItem(.flexible(), spacing: Space.lg)
                            ],
                            alignment: .leading,
                            spacing: Space.lg
                        ) {
                            ForEach(store.mangas) { manga in
                                MangaCardView(
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
                                .onAppear {
                                    if manga.id == store.mangas.last?.id && store.page < store.maxPage {
                                        store.send(.loadMore)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, Space.lg)
                        .padding(.top, Space.xs)
                        .padding(.bottom, Space.lg)
                        
                        if store.isLoadingMore {
                            LoadingView()
                        }
                    }
                    
                case .failed(let message):
                    EmptyStateView(message: message)
                    
                case .loading:
                    LoadingView()
                    
                case .idle:
                    if !store.recentSearches.isEmpty {
                        RecentSearchesView(
                            recents: store.recentSearches) { term in
                                store.send(.recentSearchTapped(term))
                            } clearAll: {
                                store.send(.clearRecent)
                            }
                    } else {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(
                text: $store.query
            )
            .onSubmit(of: .search, {
                store.send(.submitSearch(store.query))
            })
            .onChange(of: store.query, { oldValue, newValue in
                if store.query.isEmpty && !isSearching {
                    store.send(.cancelSearch)
                }
            })
            .onAppear {
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
            }
        }
    }
    
    private func onNavigateManga(_ selected: Manga?) {
        if let manga = selected {
            store.send(.setMatchedSourceID(manga.id))
            store.send(.mangaTapped(manga.id))
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            store: Store(
                initialState: SearchFeature.State(),
                reducer: { SearchFeature() },
                withDependencies: {
                    $0.userDefaults = .previewValue
                }
            )
        )
    }
}
