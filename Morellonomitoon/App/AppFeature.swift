//
//  AppFeature.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var tab = TabFeature.State()
    }
    
    enum Action {
        case tab(TabFeature.Action)
        case deepLink(AppRoute)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.tab, action: \.tab) {
            TabFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .deepLink(route):
                handleDeepLink(&state, route: route)
                return .none
                
            case .tab:
                return .none
            }
        }
    }
    
    private func handleDeepLink(_ state: inout State, route: AppRoute) {
        switch route {
        case let .mangaDetail(id: id):
            state.tab.selectedTab = .home
            state.tab.home.path.append(.manga(MangaFeature.State(id: id)))
            
            // add more deep links here
        default:
            break
        }
    }
}
