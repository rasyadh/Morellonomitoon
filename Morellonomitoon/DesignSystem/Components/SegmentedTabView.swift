//
//  SegmentedTabView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 26/11/25.
//

import SwiftUI

struct SegmentedTabView: View {
    
    let segments: [String]
    @Binding var selected: String
    @Namespace var name
    
    var body: some View {
        ZStack {
            Color(AppColors.secondaryBackground)
            
            VStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
            }
            
            HStack(spacing: Space.zero) {
                ForEach(segments, id:\.self) { segment in
                    Button {
                        selected = segment
                    } label: {
                        VStack(spacing: Space.zero) {
                            Text(segment)
                                .font(.headline)
                                .bold()
                                .foregroundColor(
                                    selected == segment ? AppColors.primary : .gray
                                )
                                .padding(.top, Space.lg)
                            
                            Spacer(minLength: Space.zero)
                            
                            VStack(spacing: Space.zero) {
                                Spacer()
                                
                                ZStack {
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 1)
                                    if selected == segment {
                                        Capsule()
                                            .fill(AppColors.primary)
                                            .frame(height: 4)
                                            .matchedGeometryEffect(id: "Tab", in: name)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 56)
                    .contentShape(Rectangle())
                }
            }
        }
        .frame(height: 56)
        .clipShape(Rectangle())
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State private var selected = "Chapters"
    
    var body: some View {
        SegmentedTabView(
            segments: ["Chapters", "Details"],
            selected: $selected
        )
    }
}
