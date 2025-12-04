//
//  ScrollableTabBarView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import SwiftUI

struct ScrollableTabBarView: View {
    
    let tabs: [String]
    let selectedTab: String
    let onSelect: (String) -> Void
    
    @Namespace private var animation
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(tabs, id: \.self) { tab in
                        ZStack {
                            if selectedTab == tab {
                                Text(tab)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(AppColors.primary)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(
                                        Capsule()
                                            .fill(AppColors.primary.opacity(0.3))
                                            .matchedGeometryEffect(id: "tabBackground", in: animation)
                                    )
                                    .id("background-\(tab)")
                            }
                            
                            Button {
                                withAnimation(.easeOut) {
                                    onSelect(tab)
                                    proxy.scrollTo(tab, anchor: .center)
                                }
                            } label: {
                                Text(tab)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(
                                        selectedTab == tab ? AppColors.primary : .white
                                    )
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .contentShape(Capsule())
                            }
                            .background {
                                Capsule().fill(Color.clear)
                            }
                            .id(tab)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }
        }
    }
}

#Preview {
    ScrollableTabBarViewPreview()
}

private struct ScrollableTabBarViewPreview: View {
    @State private var selectedTab: String = "Chapters"
    
    var body: some View {
        ScrollableTabBarView(
            tabs: ["Chapters", "Details", "More like this"],
            selectedTab: selectedTab,
            onSelect: { selectedTab = $0 }
        )
    }
}
