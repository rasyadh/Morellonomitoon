//
//  TabFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

enum AppTab {
    case home
    case explore
    case bookmark
    case search
}

@Reducer
struct TabFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: AppTab = .home
        
        var home = HomeFeature.State()
        var explore = ExploreFeature.State()
        var bookmark = BookmarkFeature.State()
        var search = SearchFeature.State()
    }
    
    enum Action {
        case selectTab(AppTab)
        case quickActionReceived(QuickActionType)
        
        case home(HomeFeature.Action)
        case explore(ExploreFeature.Action)
        case bookmark(BookmarkFeature.Action)
        case search(SearchFeature.Action)
        
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case openRoute(AppRoute)
        }
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.home, action: \.home) { HomeFeature() }
        Scope(state: \.explore, action: \.explore) { ExploreFeature() }
        Scope(state: \.bookmark, action: \.bookmark) { BookmarkFeature() }
        Scope(state: \.search, action: \.search) { SearchFeature() }
        
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
                
            case let .quickActionReceived(type):
                state.selectedTab = mapQuickAction(type)
                return .none
                
            case .home(_), .explore(_), .bookmark(_), .search(_):
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
    
    private func mapQuickAction(_ type: QuickActionType) -> AppTab {
        switch type {
        case .bookmark:
            return .bookmark
        case .search:
            return .search
        }
    }
}
