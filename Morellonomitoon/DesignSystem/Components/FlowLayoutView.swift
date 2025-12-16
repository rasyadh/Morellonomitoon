//
//  FlowLayoutView.swift
//  Morellonomitoon
//
//  Created by Rasyadh Abdul Aziz on 16/12/25.
//

import SwiftUI

enum FlowAlignment {
    case leading
    case center
    case trailing
}

struct FlowLayoutView: Layout {
    
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 8
    var alignment: FlowAlignment = .leading
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if x + size.width > maxWidth {
                x = 0
                y += rowHeight + lineSpacing
                rowHeight = 0
            }
            
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        
        return CGSize(width: maxWidth, height: y + rowHeight)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let rows = computeRows(in: bounds, subviews: subviews)
        
        var y = bounds.minY
        
        for row in rows {
            let rowWidth = row.reduce(0) { $0 + $1.size.width } +
            spacing * CGFloat(max(row.count - 1, 0))
            
            let startX: CGFloat = {
                switch alignment {
                case .leading:
                    return bounds.minX
                case .center:
                    return bounds.minX + (bounds.width - rowWidth) / 2
                case .trailing:
                    return bounds.maxX - rowWidth
                }
            }()
            
            var x = startX
            let rowHeight = row.map(\.size.height).max() ?? 0
            
            for element in row {
                element.subview.place(
                    at: CGPoint(x: x, y: y),
                    proposal: ProposedViewSize(element.size)
                )
                x += element.size.width + spacing
            }
            
            y += rowHeight + lineSpacing
        }
    }
    
    // MARK: - Helpers
    
    private func computeRows(
        in bounds: CGRect,
        subviews: Subviews
    ) -> [[(subview: LayoutSubview, size: CGSize)]] {
        var rows: [[(LayoutSubview, CGSize)]] = []
        var currentRow: [(LayoutSubview, CGSize)] = []
        var currentWidth: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            
            if currentWidth + size.width > bounds.width, !currentRow.isEmpty {
                rows.append(currentRow)
                currentRow = []
                currentWidth = 0
            }
            
            currentRow.append((view, size))
            currentWidth += size.width + spacing
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
}
