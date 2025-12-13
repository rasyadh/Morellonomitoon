//
//  SettingSheet.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 13/12/25.
//

import ComposableArchitecture
import SwiftUI

struct SettingSheet: View {
    
    @Bindable var store: StoreOf<SettingSheetFeature>
    
    var body: some View {
        Form {
            Section("Reader") {
                Toggle(
                    "Chapters ordering (asc)",
                    isOn: $store.isChapterOrderAsc
                )
                .tint(AppColors.primary)
                .onChange(of: store.isChapterOrderAsc) { _, newValue in
                    store.send(.onChangeChapterOrder(newValue))
                }
                
                Toggle(
                    "Reader style (vertical)",
                    isOn: $store.isReaderVertical
                )
                .tint(AppColors.primary)
                .onChange(of: store.isReaderVertical) { _, newValue in
                    store.send(.onChangeReaderVertical(newValue))
                }
            }
            
            Section("Source") {
                Picker("Manga source", selection: $store.mangaSource) {
                    ForEach(MangaSources.allCases) { source in
                        Text(source.title)
                            .tag(source)
                    }
                }
                .onChange(of: store.mangaSource) { _, newValue in
                    store.send(.selectMangaSource(newValue))
                }
            }
        }
        .navigationTitle("Setting")
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
        .task {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationStack {
        SettingSheet(
            store: Store(
                initialState: SettingSheetFeature.State(),
                reducer: { SettingSheetFeature() },
            )
        )
    }
}
