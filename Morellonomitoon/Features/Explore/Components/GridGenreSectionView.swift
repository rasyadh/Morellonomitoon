//
//  GridGenreSectionView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import ComposableArchitecture
import SwiftUI

struct GridGenreSectionView: View {
    
    let namespace: Namespace.ID
    let genres: IdentifiedArrayOf<Genre>
    let action: (Genre) -> Void
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Space.sm),
                GridItem(.flexible(), spacing: Space.sm)
            ],
            alignment: .leading,
            spacing: Space.sm
        ) {
            ForEach(genres) { genre in
                Button {
                    action(genre)
                } label: {
                    HStack(spacing: Space.md) {
                        Image(systemName: genre.properties.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(genre.properties.color)
                        
                        Text(genre.name)
                            .font(.subheadline)
                            .bold()
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(id: genre.id, in: namespace)
            }
        }
        .padding(.horizontal, Space.lg)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    GridGenreSectionView(
        namespace: namespace,
        genres: IdentifiedArrayOf(uniqueElements: GenreFixtures.genres),
        action: { _ in }
    )
}
