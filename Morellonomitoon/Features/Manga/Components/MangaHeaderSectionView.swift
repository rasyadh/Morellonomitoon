//
//  MangaHeaderSectionView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 27/11/25.
//

import SwiftUI
import WrappingHStack

struct MangaHeaderSectionView: View {
    
    let manga: Manga
    let height: CGFloat
    let action: () -> Void
    
    init(manga: Manga, height: CGFloat = 420, action: @escaping () -> Void) {
        self.manga = manga
        self.height = height
        self.action = action
    }
    
    var body: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .global).minY
            let sizeHeight = height + (minY > 0 ? minY : 0)
            
            ZStack(alignment: .bottomLeading) {
                LazyImageView(url: manga.thumbnailURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: sizeHeight)
                        .clipped()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.gray.opacity(0.2))
                        .frame(width: geo.size.width, height: sizeHeight)
                }
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.0),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.8),
                        Color.black.opacity(1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                VStack(alignment: .leading, spacing: Space.xs) {
                    CapsuleView(
                        title: manga.status.rawValue.capitalized,
                        type: getCapsuleType(status: manga.status)
                    )
                    .padding(.bottom, Space.xs)
                    
                    Text(manga.title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if !manga.authors.isEmpty {
                        Text(manga.authorsString)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    
                    if !manga.genres.isEmpty {
                        Text(manga.genresString)
                            .font(.subheadline)
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    
                    if let description = manga.description, !description.isEmpty {
                        HStack {
                            Text(manga.description ?? "")
                                .font(.callout)
                                .foregroundStyle(.primary.opacity(0.7))
                                .lineLimit(2)
                            
                            Button {
                                action()
                            } label: {
                                Text("MORE")
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal, Space.md)
                                    .padding(.vertical, Space.sm)
                            }
                            .glassEffect(.regular.interactive())
                        }
                        .padding(.vertical, Space.xs)
                    }
                    
                    HStack(alignment: .center, spacing: Space.md) {
                        if (manga.statistics?.views ?? 0) > 0 {
                            HStack(alignment: .center, spacing: Space.xs) {
                                Image(systemName: "eye.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.secondary)
                                
                                Text(manga.statistics?.viewCount ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if (manga.statistics?.rating ?? 0.0) > 0.0 {
                            HStack(alignment: .center, spacing: Space.xs) {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.secondary)
                                
                                Text(manga.statistics?.ratingView ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, Space.md)
            }
            .frame(height: sizeHeight)
            .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(height: height)
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
    MangaHeaderSectionView(
        manga: MangaFixtures.manga,
    ) {
        
    }
}
