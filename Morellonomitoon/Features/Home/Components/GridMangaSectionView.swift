//
//  GridMangaSectionView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 19/11/25.
//

import ComposableArchitecture
import SwiftUI

struct GridMangaSectionView: View {
    
    let namespace: Namespace.ID
    let title: String
    let mangas: IdentifiedArrayOf<Manga>
    let action: (Manga) -> Void
    let seeAllAction: (() -> Void)?
    
    init(namespace: Namespace.ID,
         title: String,
         mangas: IdentifiedArrayOf<Manga>,
         action: @escaping (Manga) -> Void,
         seeAllAction: (() -> Void)? = nil
    ) {
        self.namespace = namespace
        self.title = title
        self.mangas = mangas
        self.action = action
        self.seeAllAction = seeAllAction
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Space.md) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                if let allAction = seeAllAction {
                    Button {
                        allAction()
                    } label: {
                        Text("See all")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Space.lg)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Space.lg),
                    GridItem(.flexible(), spacing: Space.lg),
                    GridItem(.flexible(), spacing: Space.lg)
                ],
                alignment: .leading,
                spacing: Space.lg
            ) {
                ForEach(mangas) { manga in
                    MangaCardView(
                        imageURL: manga.thumbnailURL,
                        title: manga.title,
                        chapter: manga.latestChapter ?? ""
                    )
                    .matchedTransitionSource(
                        id: manga.id,
                        in: namespace
                    )
                    .onTapGesture {
                        action(manga)
                    }
                }
            }
            .padding(.horizontal, Space.lg)
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    GridMangaSectionView(
        namespace: namespace,
        title: "Latest Manga Releases",
        mangas: IdentifiedArrayOf(uniqueElements: MangaFixtures.latestManga)
    ) { _ in
    } seeAllAction: { }
}
