//
//  MangaInfoSheet.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 28/11/25.
//

import ComposableArchitecture
import SwiftUI

struct MangaInfoSheet: View {
    
    let store: StoreOf<MangaInfoSheetFeature>
    
    var body: some View {
        ScrollView {
            VStack(spacing: Space.lg) {
                VStack(alignment: .center, spacing: Space.md) {
                    Text(store.manga.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    if !store.manga.authors.isEmpty {
                        Text(store.manga.authorsString)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    
                    if !store.manga.genres.isEmpty {
                        FlowLayoutView(spacing: Space.xs, lineSpacing: Space.sm, alignment: .center) {
                            ForEach(store.manga.genres) { genre in
                                Button {
                                    store.send(.genreTapped(GenericExploreParam(
                                        id: genre.id, name: genre.name, type: .genre
                                    )))
                                } label: {
                                    Text(genre.name)
                                        .font(.callout)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, Space.md)
                                        .padding(.vertical, Space.sm)
                                }
                                .glassEffect(.regular.interactive())
                            }
                        }
                    }
                    
                    HStack(alignment: .center, spacing: Space.md) {
                        CapsuleView(
                            title: store.manga.status.rawValue.capitalized,
                            type: getCapsuleType(status: store.manga.status)
                        )
                        
                        if (store.manga.statistics?.views ?? 0) > 0 {
                            HStack(alignment: .center, spacing: Space.xs) {
                                Image(systemName: "eye.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.secondary)
                                
                                Text(store.manga.statistics?.viewCount ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if (store.manga.statistics?.rating ?? 0.0) > 0.0 {
                            HStack(alignment: .center, spacing: Space.xs) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.secondary)
                                
                                Text(store.manga.statistics?.ratingView ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Text(store.manga.description ?? "")
                    .font(.callout)
                    .foregroundStyle(.primary.opacity(0.7))
            }
            .padding(.horizontal)
            .padding(.vertical, Space.sm)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Image(systemName: "multiply.circle")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
    
    private func getCapsuleType(status: MangaStatus) -> CapsuleView.CapsuleType {
        switch status {
        case .ongoing:
            return .information
        case .completed:
            return .success
        case .hiatus:
            return .warning
        case .cancelled:
            return .error
        default:
            return .unknown
        }
    }
}

#Preview {
    NavigationStack {
        MangaInfoSheet(
            store: Store(
                initialState: MangaInfoSheetFeature.State(
                    manga: MangaFixtures.manga
                ),
                reducer: { MangaInfoSheetFeature() },
            )
        )
    }
}
