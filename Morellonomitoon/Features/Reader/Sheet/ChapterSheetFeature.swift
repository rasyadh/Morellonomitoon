//
//  ChapterSheetFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 29/11/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ChapterSheetFeature {
    
    @ObservableState
    struct State: Equatable {
        let currentChapterID: String
        let chapters: [Chapter]
    }
    
    enum Action {
        case cancelButtonTapped
        case chapterTapped(Chapter)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .chapterTapped:
                return .none
            }
        }
    }
}
