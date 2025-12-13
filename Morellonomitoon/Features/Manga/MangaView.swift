//
//  MangaView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import ComposableArchitecture
import SwiftUI

struct MangaView: View {
    
    let namespace: Namespace.ID
    @Bindable var store: StoreOf<MangaFeature>
    
    var body: some View {
        ScrollView {
            switch store.loadingState {
            case .loaded:
                MangaHeaderSectionView(
                    manga: store.manga,
                    height: 480,
                ) {
                    store.send(.onMoreTapped)
                }
                
                if let chapters = store.manga.chapters {
                    ChapterListView(
                        namespace: namespace,
                        chapters: chapters,
                        latestReadChapterURL: store.bookmark?.latestChapterURL
                    ) { param in
                        store.send(.chapterTapped(param))
                    }
                }
                
            case .failed(let message):
                EmptyStateView(message: message)
                
            default:
                LoadingView()
            }
        }
        .if(store.loadingState == .loaded) { view in
            view.ignoresSafeArea(edges: .top)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.sortTapped)
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            store.sort == .desc ?
                                .primary : AppColors.primary,
                            store.sort == .desc ?
                                AppColors.primary : .primary
                        )
                }
            }
            
            ToolbarSpacer(.fixed)
            
            ToolbarItem {
                Button {
                    store.send(.bookmarkTapped)
                } label: {
                    if store.bookmark != nil {
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(AppColors.primary)
                    } else {
                        Image(systemName: "bookmark")
                            .foregroundStyle(.primary)
                    }
                }
            }
            
            if let url = store.manga.url {
                ToolbarItem {
                    ShareLink(item: url) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .sheet(item: $store.scope(
            state: \.destination?.mangaInfoSheet,
            action: \.destination.mangaInfoSheet
        )) { mangaInfoSheetStore in
            NavigationStack {
                MangaInfoSheet(store: mangaInfoSheetStore)
            }
        }
        .refreshable {
            store.send(.refresh)
        }
        .task {
            store.send(.onAppear)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    NavigationStack {
        MangaView(
            namespace: namespace,
            store: Store(
                initialState: MangaFeature.State(id: "solo-leveling"),
                reducer: { MangaFeature() },
                withDependencies: {
                    $0.sourceManager = MockSourceManager()
                }
            )
        )
    }
}
