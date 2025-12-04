//
//  RecentSearchesView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 03/12/25.
//

import SwiftUI

struct RecentSearchesView: View {
    
    let recents: [String]
    let action: (String) -> Void
    let clearAll: () -> Void
    
    var body: some View {
        List {
            Section("Recent Searches") {
                ForEach(recents, id: \.self) { term in
                    Button {
                        action(term)
                    } label: {
                        Text(term)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                
                Button("Clear All") {
                    clearAll()
                }
                .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    RecentSearchesView(
        recents: ["Solo leveling", "Max level newbie"],
        action: { _ in },
        clearAll: { }
    )
}
