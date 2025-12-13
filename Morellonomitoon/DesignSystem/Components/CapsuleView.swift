//
//  CapsuleView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import SwiftUI

struct CapsuleView: View {
    
    enum CapsuleType {
        case success
        case error
        case warning
        case information
        case unknown
        
        var color: Color {
            switch self {
            case .success:
                return .green
            case .error:
                return .red
            case .warning:
                return .orange
            case .information:
                return .blue
            case .unknown:
                return .gray
            }
        }
    }
    
    let title: String
    let type: CapsuleType
    
    var body: some View {
        Text(title)
            .font(.callout)
            .bold()
            .padding(.horizontal, Space.sm)
            .padding(.vertical, Space.xs)
            .foregroundStyle(.white)
            .glassEffect(
                .regular.tint(type.color).interactive(),
                in: .rect(cornerRadius: 8)
            )
    }
}

#Preview {
    CapsuleView(
        title: "Ongoing",
        type: .information
    )
}
