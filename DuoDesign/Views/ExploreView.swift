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
        // iPhone Duo: NavigationSplitView'ü bilerek seçtik. Dış ekranda (compact
        // width) tek sütuna iner, iç ekranda (regular width) liste + detay olur.
        // Cihaz yarı katlıyken sütunları katlanma çizgisine göre kendisi ayarlar.
        // Yani pozisyon (pose) için tek satır özel kod yazmamıza gerek yok.
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
            // iPhone Duo: Sabit genişlik/padding yerine sistemin kenar boşluklarını
            // kullanıyoruz. Böylece aynı içerik dış ekranda, iç ekranda ve split
            // view'ün dar sütununda doğru boşlukla görünür.
            .scenePadding()
        }
        .navigationTitle(destination.name)
        .toolbar {
            // iPhone Duo: Bu toolbar dış ekranda ve yatay iç ekranda yana geçer
            // ve dikey dizilir. Dikey alan kısıtlı olduğu için bazı butonlar
            // sığmayabilir; hangisinin görünür kalacağını biz belirliyoruz.
            //
            // Ayrıca her butonda Label (başlık + ikon) kullanıyoruz: dikey barda
            // sadece ikon görünür, taşma menüsünde ise başlık gerekir.
            // Butonlar arasına sabit boşluk (Spacer vb.) koymuyoruz.

            // iPhone Duo: Yüksek öncelik → yer daraldığında en son bunlar gizlenir.
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

            // iPhone Duo: Düşük öncelik → yer yetmezse ilk önce bunlar "…"
            // menüsüne taşınır. Simülatörde dış ekranda "Book" bu yüzden menüye gider.
            ToolbarItemGroup {
                Button {} label: {
                    Label("Directions", systemImage: "map")
                }
                Button {} label: {
                    Label("Book", systemImage: "airplane")
                }
            }
            .visibilityPriority(.low)

            // iPhone Duo: Sistemin kendi taşma menüsü ("…" butonu). Kendi "…"
            // Menu'müzü yazmıyoruz, çünkü sistem taşan butonları da buraya ekler
            // ve dikey barda doğru yere yerleştirir. "…" ikonu sadece buna ayrılmıştır.
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
