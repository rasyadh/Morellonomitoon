//
//  GenreSheetView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import ComposableArchitecture
import SwiftUI

struct GenreSheetView: View {
    
    @Bindable var store: StoreOf<GenreSheetFeature>
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Space.sm),
                    GridItem(.flexible(), spacing: Space.sm)
                ],
                alignment: .leading,
                spacing: Space.sm
            ) {
                ForEach(store.filteredGenres) { genre in
                    Button {
                        store.send(.genreTapped(
                            GenericExploreParam(id: genre.id, name: genre.name)
                        ))
                    } label: {
                        HStack(spacing: Space.md) {
                            Image(systemName: genre.properties.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(genre.properties.color)
                            
                            Text(genre.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Space.lg)
        }
        .searchable(
            text: $store.query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search genre..."
        )
        .navigationTitle("Genre")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Image(systemName: "multiply.circle")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GenreSheetView(
            store: Store(
                initialState: GenreSheetFeature.State(
                    genres: IdentifiedArrayOf(uniqueElements: GenreFixtures.genres)
                ),
                reducer: { GenreSheetFeature() },
            )
        )
    }
}
