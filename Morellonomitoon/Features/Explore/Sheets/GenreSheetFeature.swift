//
//  GenreSheetFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct GenreSheetFeature {
    
    @ObservableState
    struct State: Equatable {
        var query: String = ""
        var genres: IdentifiedArrayOf<Genre>
        var filteredGenres: IdentifiedArrayOf<Genre>
        
        init(genres: IdentifiedArrayOf<Genre>) {
            self.genres = genres
            self.filteredGenres = genres
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case filterGenre
        case cancelButtonTapped
        case genreTapped(GenericExploreParam)
    }
    
    enum CancelID {
        case filter
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.query):
                return .run { send in
                    try await Task.sleep(for: .milliseconds(500))
                    await send(.filterGenre)
                }
                .cancellable(id: CancelID.filter)
            
            case .filterGenre:
                state.filteredGenres = self.onFilterGenre(
                    query: state.query,
                    genre: state.genres
                )
                return .none
                
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .genreTapped:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
    
    private func onFilterGenre(query: String, genre: IdentifiedArrayOf<Genre>) -> IdentifiedArrayOf<Genre> {
        if query.isEmpty {
            return genre
        } else {
            return genre.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }
}

extension GenreSheetFeature.CancelID: @nonisolated Hashable, Sendable {}
