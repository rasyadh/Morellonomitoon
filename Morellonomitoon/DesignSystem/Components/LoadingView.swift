//
//  LoadingView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 27/11/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: Space.md) {
            ProgressView()
                .controlSize(.large)
                .padding()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
