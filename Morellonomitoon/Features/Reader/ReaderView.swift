//
//  ReaderView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 28/11/25.
//

import ComposableArchitecture
import SwiftUI

struct ReaderView: View {
    
    @Bindable var store: StoreOf<ReaderFeature>
    
    var body: some View {
        ScrollView {
            switch store.loadingState {
            case .loaded:
                if let imageURLs = store.reader?.imageURLs {
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(imageURLs, id: \.self) { imageURL in
                            LazyImageView(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(height: 420)
                            }
                        }
                    }
                }
                
            case .failed(let message):
                EmptyStateView(message: message)
                
            default:
                LoadingView()
            }
        }
        .navigationTitle(store.reader?.mangaName ?? store.mangaId)
        .navigationSubtitle(store.reader?.chapterTitle ?? store.chapterId)
        .toolbarVisibility(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.chapterToolbarTapped)
                } label: {
                    Image(systemName: "list.bullet.below.rectangle")
                        .foregroundStyle(.primary)
                }
            }
            
            if let prev = store.reader?.previousChapter {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        store.send(.previousChapterTapped(prev))
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            if let next = store.reader?.nextChapter {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        store.send(.nextChapterTapped(next))
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .sheet(item: $store.scope(
            state: \.destination?.chapterSheet,
            action: \.destination.chapterSheet
        )) { chapterSheetStore in
            NavigationStack {
                ChapterSheetView(store: chapterSheetStore)
            }
        }
        .task {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        ReaderView(
            store: Store(
                initialState: ReaderFeature.State(
                    mangaId: "solo-leveling", chapterId: "chapter-1"
                ),
                reducer: { ReaderFeature() },
                withDependencies: {
                    $0.sourceManager = MockSourceManager(
                        chapterReader: .init(id: "chapter-1",
                                             mangaID: "solo-leveling")
                    )
                }
            )
        )
    }
}
