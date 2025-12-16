//
//  MangaInfoSheetFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 28/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MangaInfoSheetFeature {
    
    @ObservableState
    struct State: Equatable {
        let manga: Manga
    }
    
    enum Action {
        case onAppear
        case cancelButtonTapped
        case genreTapped(GenericExploreParam)
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .genreTapped:
                return .none
            }
        }
    }
}
