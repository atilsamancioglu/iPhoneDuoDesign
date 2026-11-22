//
//  PrinciplesView.swift
//  DuoDesign
//
//  A short summary of the iPhone Duo design principles shown in this app.
//  A plain List already scrolls cleanly across the fold.
//

import SwiftUI

struct Principle: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let symbol: String
    let color: Color
}

extension Principle {
    static let all: [Principle] = [
        Principle(
            title: "Build to resize",
            detail: "Use size classes, layout margins and safe areas. No fixed widths or screen-specific code.",
            symbol: "arrow.up.left.and.arrow.down.right",
            color: .blue
        ),
        Principle(
            title: "Two size classes, every pose",
            detail: "Compact width for the outer display, regular width for the inner display.",
            symbol: "rectangle.portrait.on.rectangle.portrait",
            color: .indigo
        ),
        Principle(
            title: "Let standard containers adapt",
            detail: "NavigationSplitView, sheets, alerts and menus move around the fold automatically.",
            symbol: "sidebar.left",
            color: .teal
        ),
        Principle(
            title: "Respect reserved regions",
            detail: "Keep custom controls away from the fold (division) and the cameras (occlusion).",
            symbol: "square.dashed",
            color: .pink
        ),
        Principle(
            title: "Use ArrangementView",
            detail: "Show two related views layered (overlay) or side by side (split) in every pose.",
            symbol: "square.split.2x1",
            color: .orange
        ),
        Principle(
            title: "Even grid columns",
            detail: "2, 4, 6 … columns divide cleanly at the fold.",
            symbol: "square.grid.2x2",
            color: .green
        ),
        Principle(
            title: "Vertical toolbars",
            detail: "Bars move to the side. Use Labels, priorities and the system overflow menu.",
            symbol: "sidebar.squares.left",
            color: .purple
        ),
        Principle(
            title: "Same features in every pose",
            detail: "Don't remove functionality when the device closes – only adapt the layout.",
            symbol: "checkmark.seal",
            color: .mint
        )
    ]
}

struct PrinciplesView: View {
    var body: some View {
        NavigationStack {
            List(Principle.all) { principle in
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: principle.symbol)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(principle.color.gradient, in: .rect(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(principle.title)
                            .font(.headline)
                        Text(principle.detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Duo Principles")
        }
    }
}

#Preview {
    PrinciplesView()
}
