//
//  BookmarkView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import ComposableArchitecture
import SwiftUI

struct BookmarkView: View {
    
    @Bindable var store: StoreOf<BookmarkFeature>
    @Namespace private var namespace
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
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
                        ForEach(store.bookmarks) { bookmark in
                            MangaCardView(
                                imageURL: bookmark.thumbnailURL,
                                title: bookmark.title,
                                chapter: bookmark.latestChapter ?? ""
                            )
                            .matchedTransitionSource(
                                id: bookmark.id,
                                in: namespace
                            )
                            .onTapGesture {
                                onNavigateManga(bookmark)
                            }
                        }
                    }
                    .padding(.horizontal, Space.lg)
                    .padding(.top, Space.xs)
                    .padding(.bottom, Space.lg)
                    
                case .failed(let message):
                    EmptyStateView(message: message)
                    
                default:
                    LoadingView()
                }
            }
            .navigationTitle("Bookmark")
            .toolbarTitleDisplayMode(.inlineLarge)
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
    BookmarkView(
        store: Store(
            initialState: .init(),
            reducer: { BookmarkFeature() },
            withDependencies: { _ in }
        )
    )
}
