//
//  GenericExploreView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 28/11/25.
//

import ComposableArchitecture
import SwiftUI

struct GenericExploreView: View {
    
    let namespace: Namespace.ID
    let store: StoreOf<GenericExploreFeature>
    
    var body: some View {
        ScrollView {
            switch store.loadingState {
            case .loaded:
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
                            store.send(.mangaTapped(manga.id))
                        }
                        .onAppear {
                            if manga.id == store.mangas.last?.id {
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
                
            case .failed(let message):
                EmptyStateView(message: message)
                
            default:
                LoadingView()
            }
        }
        .navigationTitle(store.name.capitalized)
        .refreshable {
            store.send(.refresh)
        }
        .task(id: "task-generic-explore-\(store.id)") {
            store.send(.onAppear)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    NavigationStack {
        GenericExploreView(
            namespace: namespace,
            store: Store(
                initialState: GenericExploreFeature.State(
                    id: "all",
                    name: "All",
                    type: .genre
                ),
                reducer: { GenericExploreFeature() },
                withDependencies: {
                    $0.sourceManager = MockSourceManager(
                        latest: MangaFixtures.latestManga,
                    )
                }
            )
        )
    }
}
