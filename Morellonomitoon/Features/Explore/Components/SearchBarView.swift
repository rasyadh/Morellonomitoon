//
//  SearchBarView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 21/11/25.
//

import SwiftUI

struct SearchBarView: View {
    @State private var query = ""
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textFieldStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .glassEffect()
    }
}

#Preview {
    SearchBarView()
}
