//
//  GalleryView.swift
//  DuoDesign
//
//  PRINCIPLE 4 – Design for size classes, not for poses.
//
//  Two size classes cover every pose of iPhone Duo:
//  • compact width  → outer display
//  • regular width  → inner display
//
//  PRINCIPLE 5 – Use an even number of grid columns.
//
//  When the device is partially folded the fold sits in the center of the
//  inner display. An even column count (2, 4, …) lets the grid divide
//  cleanly at the fold instead of cutting a card in half.
//
//  Because the side tab bar takes some width, the center of our view is
//  not exactly the center of the screen. So while the fold is active we
//  read its frame and place half of the columns on each side of it.
//

import SwiftUI

struct GalleryView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    /// Always even: 2 columns on the outer display, 4 on the inner display.
    private var columnCount: Int {
        horizontalSizeClass == .regular ? 4 : 2
    }

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                // Only active regions are returned by default.
                let fold = proxy.reservedRegions(kind: .division).first

                ScrollView {
                    if let fold, columnCount > 2 {
                        foldedGrid(around: fold)
                    } else {
                        grid(Destination.samples, columns: columnCount)
                            .scenePadding()
                    }
                }
                .animation(.smooth, value: fold?.frame)
            }
            .navigationTitle("Gallery")
            .safeAreaInset(edge: .bottom) {
                Text("\(columnCount) columns · \(horizontalSizeClass == .regular ? "regular" : "compact") width")
                    .font(.footnote.monospaced())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect()
            }
        }
    }

    /// Half of the columns on each side of the fold, so no card is split.
    private func foldedGrid(around fold: ReservedRegion) -> some View {
        let half = columnCount / 2
        let indexed = Array(Destination.samples.enumerated())
        let leading = indexed.filter { $0.offset % columnCount < half }.map(\.element)
        let trailing = indexed.filter { $0.offset % columnCount >= half }.map(\.element)

        return HStack(alignment: .top, spacing: 0) {
            grid(leading, columns: half)
                .padding()
                .frame(width: max(fold.frame.minX, 0))
            Color.clear
                .frame(width: fold.frame.width)
            grid(trailing, columns: half)
                .padding()
                .frame(maxWidth: .infinity)
        }
    }

    private func grid(_ destinations: [Destination], columns: Int) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: columns),
            spacing: 16
        ) {
            ForEach(destinations) { destination in
                DestinationCard(destination: destination)
            }
        }
    }
}

#Preview {
    GalleryView()
}
