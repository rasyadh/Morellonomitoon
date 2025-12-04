//
//  FeaturedCardView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import SwiftUI

struct FeaturedCardView: View {
    
    let imageURL: URL?
    let title: String
    let chapter: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LazyImageView(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 420)
                    .clipped()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.gray.opacity(0.2))
                    .frame(height: 420)
            }
            
            LinearGradient(
                colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.55)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            HStack {
                VStack(alignment: .leading, spacing: Space.xs) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(chapter)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer()
            }
            .padding(20)
        }
        .frame(height: 420)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
        )
        .glassBorder(cornerRadius: 24)
        .padding(.horizontal)
    }
}

#Preview {
    FeaturedCardView(
        imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/id/thumb/9/99/Solo_Leveling_Webtoon.png/500px-Solo_Leveling_Webtoon.png")!,
        title: "Solo Leveling",
        chapter: "Chapter 1"
    )
}
