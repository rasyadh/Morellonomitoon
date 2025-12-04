//
//  HorizontalMangaSectionView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

struct HorizontalMangaSectionView: View {
    
    let namespace: Namespace.ID
    let title: String
    let mangas: IdentifiedArrayOf<Manga>
    let action: (Manga) -> ()
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: Space.md) {
                    ForEach(mangas) { manga in
                        MangaCardView(
                            imageURL: manga.thumbnailURL,
                            title: manga.title,
                            chapter: manga.latestChapter ?? ""
                        )
                        .frame(width: 120)
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
}

#Preview {
    @Previewable @Namespace var namespace
    
    HorizontalMangaSectionView(
        namespace: namespace,
        title: "Popular Manga",
        mangas: IdentifiedArrayOf(uniqueElements: MangaFixtures.popularManga),
        action: { _ in },
        seeAllAction: { }
    )
}
