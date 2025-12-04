//
//  EmptyStateView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 27/11/25.
//

import SwiftUI

struct EmptyStateView: View {
    
    let message: String
    var image: String? = "exclamationmark.triangle"
    
    var body: some View {
        VStack(spacing: Space.lg) {
            Spacer()
            
            if let image {
                Image(systemName: image)
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
            }
            
            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    EmptyStateView(
        message: "Failed to load the data"
    )
}
