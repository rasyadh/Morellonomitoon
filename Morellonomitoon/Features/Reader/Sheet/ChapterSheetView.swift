//
//  ChapterSheetView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 29/11/25.
//

import ComposableArchitecture
import SwiftUI

struct ChapterSheetView: View {
    
    let store: StoreOf<ChapterSheetFeature>
    
    var body: some View {
        List {
            Section(header: Text("Jump to chapter")) {
                ForEach(store.chapters) { chapter in
                    Button {
                        store.send(.chapterTapped(chapter))
                    } label: {
                        HStack(alignment: .center) {
                            Text(chapter.title)
                                .font(.body)
                                .foregroundStyle(.primary)
                            
                            Spacer()
                            
                            if store.currentChapterID == chapter.id {   
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(AppColors.primary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Chapters")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button {
                    store.send(.cancelButtonTapped)
                } label: {
                    Image(systemName: "multiply.circle")
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChapterSheetView(
            store: Store(
                initialState: ChapterSheetFeature.State(
                    currentChapterID: "chapter-1", chapters: []
                ),
                reducer: { ChapterSheetFeature() },
            )
        )
    }
}
