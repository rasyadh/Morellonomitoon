//
//  MangaCardView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 19/11/25.
//

import ComposableArchitecture
import NukeUI
import SwiftUI

struct MangaCardView: View {
    
    let imageURL: URL?
    let title: String
    let chapter: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Space.xs) {
            MangaLazyImageView(url: imageURL)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(chapter)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.horizontal, Space.xs)
        }
    }
}

#Preview {
    MangaCardView(
        imageURL: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1696899289i/194805543.jpg"),
        title: "Solo Leveling",
        chapter: "Chapter 1"
    )
    .frame(width: 120, height: 180)
}
