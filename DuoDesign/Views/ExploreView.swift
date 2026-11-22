//
//  ExploreView.swift
//  DuoDesign
//
//  PRINCIPLE 1 – Let standard containers adapt for you.
//
//  NavigationSplitView collapses to a single column on the outer display
//  (compact width) and expands to list + detail on the inner display
//  (regular width). It also adjusts its columns around the fold
//  automatically. No per-pose code is needed.
//
//  PRINCIPLE 2 – Follow the system's vertical toolbars.
//
//  On the outer display (and in landscape on the inner display) toolbars
//  move to the side. Give every item a title AND a symbol (Label), put
//  the most used actions first, assign visibility priorities and let the
//  rest go to the system overflow menu.
//

import SwiftUI

struct ExploreView: View {
    @State private var selection: Destination.ID?
    @State private var favorites: Set<Destination.ID> = []

    private var selectedDestination: Destination? {
        Destination.samples.first { $0.id == selection }
    }

    var body: some View {
        NavigationSplitView {
            List(Destination.samples, selection: $selection) { destination in
                DestinationRow(destination: destination)
            }
            .navigationTitle("Explore")
        } detail: {
            if let destination = selectedDestination {
                DestinationDetailView(
                    destination: destination,
                    isFavorite: favoriteBinding(for: destination)
                )
            } else {
                ContentUnavailableView(
                    "Pick a Destination",
                    systemImage: "map",
                    description: Text("Choose a destination from the list.")
                )
            }
        }
    }

    private func favoriteBinding(for destination: Destination) -> Binding<Bool> {
        Binding {
            favorites.contains(destination.id)
        } set: { isFavorite in
            if isFavorite {
                favorites.insert(destination.id)
            } else {
                favorites.remove(destination.id)
            }
        }
    }
}

struct DestinationDetailView: View {
    let destination: Destination
    @Binding var isFavorite: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DestinationArtwork(destination: destination)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 24))

                VStack(alignment: .leading, spacing: 6) {
                    Text(destination.country.uppercased())
                        .font(.caption.bold())
                        .foregroundStyle(.secondary)
                    Text(destination.summary)
                        .font(.title3)
                }

                HStack {
                    Label(destination.bestSeason, systemImage: "calendar")
                    Spacer()
                    RatingBadge(rating: destination.rating)
                }
                .font(.subheadline)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Highlights")
                        .font(.headline)
                    ForEach(destination.highlights, id: \.self) { highlight in
                        Label(highlight, systemImage: "checkmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                }
            }
            // Use layout margins instead of fixed widths.
            .scenePadding()
        }
        .navigationTitle(destination.name)
        .toolbar {
            // Most important actions: keep them visible as long as possible.
            ToolbarItemGroup {
                Button {
                    isFavorite.toggle()
                } label: {
                    Label("Favorite", systemImage: isFavorite ? "heart.fill" : "heart")
                }
                ShareLink(item: destination.name) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            .visibilityPriority(.high)

            // Less important actions: these can move into overflow first.
            ToolbarItemGroup {
                Button {} label: {
                    Label("Directions", systemImage: "map")
                }
                Button {} label: {
                    Label("Book", systemImage: "airplane")
                }
            }
            .visibilityPriority(.low)

            // The system overflow menu (the "…" button). Don't create your
            // own ellipsis menu – this one works on the vertical bar too.
            ToolbarOverflowMenu {
                Button("Report a Problem", systemImage: "exclamationmark.bubble") {}
                Button("Download for Offline", systemImage: "arrow.down.circle") {}
            }
        }
    }
}

#Preview {
    ExploreView()
}
