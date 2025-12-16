//
//  ChapterListView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 03/12/25.
//

import SwiftUI

struct ChapterListView: View {
    
    let namespace: Namespace.ID
    let chapters: [Chapter]
    let latestReadChapterURL: URL?
    let action: (ChapterParam) -> Void
    
    var body: some View {
        LazyVStack(spacing: Space.sm) {
            ForEach(chapters) { chapter in
                Button {
                    action(
                        ChapterParam(
                            mangaID: chapter.mangaID,
                            chapterID: chapter.id
                        )
                    )
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: Space.xs) {
                            Text(chapter.title)
                                .font(.default)
                                .fontWeight(.medium)
                                .foregroundStyle(
                                    latestReadChapterURL == chapter.url ? AppColors.primary : .primary
                                )
                            
                            Text("\(chapter.view) views")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .center, spacing: Space.sm) {
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                            
                            Text(chapter.uploadedAt)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .glassEffect(
                        .regular.interactive(),
                        in: .rect(cornerRadius: 16)
                    )
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(
                    id: chapter.id,
                    in: namespace
                )
            }
        }
        .padding(.horizontal)
        .padding(.bottom, Space.lg)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    ChapterListView(
        namespace: namespace,
        chapters: [],
        latestReadChapterURL: nil,
        action: { _ in }
    )
}
