//
//  View+Extension.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 24/11/25.
//

import SwiftUI

extension View {
    func glassBorder(cornerRadius: CGFloat = 12) -> some View {
        self.modifier(GlassBorderModifier(cornerRadius: cornerRadius))
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
