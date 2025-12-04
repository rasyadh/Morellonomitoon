//
//  LazyImageView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 22/11/25.
//

import ComposableArchitecture
import NukeUI
import SwiftUI

struct LazyImageView<Content: View, Placeholder: View>: View {
    @Dependency(\.sourceManager) private var sourceManager
    
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        LazyImage(url: url) { state in
            if let image = state.image {
                content(image)
            } else {
                placeholder()
            }
        }
        .pipeline(sourceManager.current.imagePipeline)
    }
}

#Preview {
    LazyImageView(
        url: URL(string: "https://m.media-amazon.com/images/S/compressed.photo.goodreads.com/books/1696899289i/194805543.jpg")
    ) { image in
        image
            .resizable()
            .scaledToFit()
            .frame(height: 180)
            .clipped()
    } placeholder: {
        RoundedRectangle(cornerRadius: 0)
            .fill(.gray.opacity(0.2))
            .frame(height: 180)
    }
    .padding()
}
