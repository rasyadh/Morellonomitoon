//
//  TabViewContainer.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

struct TabViewContainer: View {
    
    @Bindable var store: StoreOf<TabFeature>
    
    var body: some View {
        TabView(selection: $store.selectedTab.sending(\.selectTab)) {
            Tab(
                "Home",
                systemImage: "house",
                value: AppTab.home
            ) {
                HomeView(store: store.scope(state: \.home, action: \.home))
            }
            
            Tab(
                "Explore",
                systemImage: "rectangle.stack",
                value: AppTab.explore
            ) {
                ExploreView(store: store.scope(state: \.explore, action: \.explore))
            }
            
            Tab(
                "Bookmark",
                systemImage: "bookmark",
                value: AppTab.bookmark
            ) {
                BookmarkView(store: store.scope(state: \.bookmark, action: \.bookmark))
            }
            
            Tab(
                "Search",
                systemImage: "magnifyingglass",
                value: AppTab.search,
                role: .search
            ) {
                NavigationStack {
                    SearchView(
                        store: store.scope(state: \.search, action: \.search)
                    )
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(AppColors.primary)
    }
}

#Preview {
    TabViewContainer(
        store: Store(
            initialState: TabFeature.State()
        ) {
            TabFeature()
        }
    )
}
