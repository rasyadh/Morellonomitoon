//
//  MangaLazyImageView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 22/11/25.
//

import ComposableArchitecture
import NukeUI
import SwiftUI

struct MangaLazyImageView: View {
    
    @Dependency(\.sourceManager) private var sourceManager
    
    let url: URL?
    let size: CGSize = CGSize(width: 120, height: 180)
    
    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(width: size.width, height: size.height)
                    .clipped()
            }
        }
        .pipeline(sourceManager.current.imagePipeline)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .glassBorder(cornerRadius: 12)
    }
}

#Preview {
    MangaLazyImageView(
        url: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1696899289i/194805543.jpg")
    )
}
