//
//  ArrangementDemoView.swift
//  DuoDesign
//
//  PRINCIPLE 3 – Use ArrangementView for two related views.
//
//  ArrangementView takes a primary and a secondary view and arranges them
//  for the current pose:
//
//  • .overlay – think ZStack. On a flat display the primary view floats
//    over the secondary view. When the device is partially folded the two
//    views move to either side of the fold so nothing is split in half.
//
//  • .split – think HStack / VStack. The views always sit next to each
//    other: primary on top (portrait) or leading (landscape).
//
//  Rules: keep navigation OUTSIDE the arrangement view, and don't put the
//  arrangement view inside a ScrollView, Grid or NavigationSplitView.
//

import SwiftUI

struct ArrangementDemoView: View {
    enum Style: String, CaseIterable, Identifiable {
        case overlay = "Overlay"
        case split = "Split"
        var id: Self { self }
    }

    @State private var style: Style = .overlay
    @State private var destination = Destination.samples[0]

    var body: some View {
        // iPhone Duo: Navigation (NavigationStack, toolbar) ArrangementView'ün
        // DIŞINDA kalmalı. ArrangementView içine NavigationSplitView/TabView
        // koymuyoruz; ArrangementView'ü de ScrollView/Grid içine koymuyoruz.
        NavigationStack {
            arrangement
                .navigationTitle("Arrangement")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Picker("Style", selection: $style) {
                            ForEach(Style.allCases) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
        }
    }

    @ViewBuilder
    private var arrangement: some View {
        // iPhone Duo: ZStack/HStack yerine ArrangementView kullanıyoruz.
        // Neden? Düz ekranda kartı görselin üstüne bindirmek güzel; ama cihaz
        // yarı katlandığında kart katlanma çizgisinin üstüne denk gelir ve
        // ikiye bölünür. ArrangementView bunu bizim yerimize çözer: katlıyken
        // iki görünümü çizginin iki yanına taşır. Bunun için hiç kod yazmıyoruz.
        let view = ArrangementView {
            // iPhone Duo: Primary = kullanıcının etkileşimde olduğu asıl içerik.
            // Split stilinde cihaz kapalı + yataydayken sadece primary gösterilir,
            // bu yüzden en önemli içeriği buraya koyuyoruz.
            DestinationInfo(destination: $destination)
        } secondary: {
            // iPhone Duo: Secondary = arka plandaki büyük görsel bağlam
            // (Haritalar uygulamasındaki harita gibi).
            DestinationArtwork(destination: destination, symbolScale: 0.3)
                .ignoresSafeArea()
                .animation(.smooth, value: destination)
        }

        // iPhone Duo: İki stil iki farklı tasarım fikrini temsil eder:
        // .overlay → ZStack gibi (katlanınca yan yana geçer)
        // .split   → HStack/VStack gibi (her zaman ayrı durur)
        switch style {
        case .overlay:
            view.arrangementViewStyle(.overlay)
        case .split:
            view.arrangementViewStyle(.split)
        }
    }
}

private struct DestinationInfo: View {
    @Binding var destination: Destination

    var body: some View {
        InfoPanel {
            HStack {
                VStack(alignment: .leading) {
                    Text(destination.name)
                        .font(.title2.bold())
                    Text(destination.country)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                RatingBadge(rating: destination.rating)
            }

            Text(destination.summary)
                .font(.callout)

            HStack {
                Button("Previous", systemImage: "chevron.backward") { move(by: -1) }
                Spacer()
                Button("Next", systemImage: "chevron.forward") { move(by: 1) }
            }
            .buttonStyle(.glass)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private func move(by offset: Int) {
        let all = Destination.samples
        guard let index = all.firstIndex(of: destination) else { return }
        destination = all[(index + offset + all.count) % all.count]
    }
}

#Preview {
    ArrangementDemoView()
}
