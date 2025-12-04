//
//  AppView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 18/11/25.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    
    let store: StoreOf<AppFeature>
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            TabViewContainer(store: store.scope(
                state: \.tab,
                action: \.tab
            ))
            .onOpenURL { url in
                if let route = DeepLinkHandler().parse(url: url) {
                    store.send(.deepLink(route))
                }
            }
        }
    }
}

#Preview {
    AppView(
        store: Store(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
    )
    .preferredColorScheme(.dark)
    .tint(AppColors.primary)
}
