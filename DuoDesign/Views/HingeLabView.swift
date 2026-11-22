//
//  HingeLabView.swift
//  DuoDesign
//
//  PRINCIPLE 6 – Keep custom UI out of reserved regions.
//
//  Standard components (alerts, sheets, menus, split views, scroll views)
//  move around the fold and the cameras automatically. Your *custom*
//  overlays, floating buttons and Layouts must check reserved regions
//  themselves with GeometryProxy.reservedRegions(kind:):
//
//  • .division  → the fold. Active only while partially open.
//  • .occlusion → something covers the screen (camera, Dynamic Island).
//
//  Pass .includeInactive to reserve space for a region that will appear
//  later, so the layout doesn't jump.
//
//  PRINCIPLE 7 – Read the hinge only when you really need it.
//
//  .onHingeChange reports the hinge status and angle. Most apps never need
//  it – size classes and reserved regions are enough – but it's handy for
//  special experiences such as a camera or a "laptop mode" UI.
//

import SwiftUI

struct HingeLabView: View {
    @State private var hinge: DeviceHinge?
    @State private var showRegions = true

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                // iPhone Duo: Rezerve bölgeleri GeometryProxy üzerinden okuyoruz.
                // .division  → katlanma çizgisi (sadece yarı katlıyken aktif)
                // .occlusion → ekranı örten şeyler (kamera, Dynamic Island)
                // .includeInactive ile henüz aktif olmayan bölgeleri de alıyoruz;
                // ileride çıkacak bir bölgeye önceden yer ayırıp layout'un
                // zıplamasını önlemek istediğimizde işe yarar. Burada ise
                // ekranda aktif/pasif durumunu göstermek için kullanıyoruz.
                let divisions = proxy.reservedRegions(kind: .division, options: .includeInactive)
                let occlusions = proxy.reservedRegions(kind: .occlusion, options: .includeInactive)
                // iPhone Duo: Layout kararlarını sadece AKTİF çizgiye göre veriyoruz.
                let activeDivision = divisions.first { $0.isActive }

                ZStack {
                    ScrollView {
                        cards(divisions: divisions, occlusions: occlusions, avoiding: activeDivision)
                            .padding(.bottom, 80)
                            .animation(.smooth, value: activeDivision?.frame)
                    }

                    // iPhone Duo: Sadece eğitim amaçlı; rezerve bölgeleri ekranda
                    // çizerek nereden uzak durmamız gerektiğini gösteriyoruz.
                    if showRegions {
                        RegionOverlay(regions: divisions, tint: .pink)
                        RegionOverlay(regions: occlusions, tint: .orange)
                    }

                    // iPhone Duo: Kendi yazdığımız yüzen buton. Sistem bileşenleri
                    // (sheet, alert, menu) çizgiden kendiliğinden kaçar ama özel
                    // overlay'ler kaçmaz! Normalde ortada duran buton katlanma
                    // çizgisinin tam üstüne denk gelir; bu yüzden çizgi aktifken
                    // butonu sağ tarafa taşıyoruz. Etkileşimli öğeler çizgiden uzak durmalı.
                    FloatingActionButton()
                        .position(
                            x: floatingButtonX(in: proxy.size, avoiding: activeDivision),
                            y: proxy.size.height - 40
                        )
                        .animation(.spring, value: activeDivision?.frame)
                }
            }
            .navigationTitle("Hinge Lab")
            .toolbar {
                ToolbarItem {
                    Toggle(isOn: $showRegions) {
                        Label("Show Regions", systemImage: "square.dashed")
                    }
                }
            }
        }
        // iPhone Duo: Menteşenin durumunu (kapalı/yarı açık/tam açık) ve açısını
        // dinliyoruz. ÇOĞU UYGULAMANIN BUNA İHTİYACI YOKTUR: layout için size
        // class ve rezerve bölgeler yeterli. Bu API kamera veya "laptop modu"
        // gibi özel deneyimler içindir. hinge nil ise view menteşe bilgisi
        // sağlayan bir hiyerarşide değildir (ör. menteşesiz bir iPhone).
        .onHingeChange { _, newContext in
            hinge = newContext.hinge
        }
    }

    /// Approximate half width of the floating button, used to test overlap with the fold.
    private let buttonHalfWidth: CGFloat = 80

    // iPhone Duo: Butonun yatay konumunu çizgiye göre hesaplıyoruz.
    private func floatingButtonX(in size: CGSize, avoiding division: ReservedRegion?) -> CGFloat {
        let center = size.width / 2
        // iPhone Duo: Sadece merkez noktası değil, butonun tüm genişliği
        // kontrol ediliyor. İlk denemede sadece merkeze baktık; dikey tab bar
        // view'ü daralttığı için merkez çizginin hemen solunda kaldı ve buton
        // yine çizginin üstüne denk geldi.
        guard let division,
              division.frame.minX < center + buttonHalfWidth,
              division.frame.maxX > center - buttonHalfWidth else {
            return center
        }
        // Center the button in the area after the fold.
        return division.frame.maxX + (size.width - division.frame.maxX) / 2
    }

    // MARK: - Cards

    /// Without a fold the cards are stacked. When the fold is active, we place
    /// one card on each side of it – a custom layout that respects the division.
    @ViewBuilder
    private func cards(divisions: [ReservedRegion], occlusions: [ReservedRegion], avoiding division: ReservedRegion?) -> some View {
        // iPhone Duo: Çizgi aktifken kartları alt alta değil, çizginin iki
        // yanına koyuyoruz; böylece hiçbir kartın metni ikiye bölünmüyor.
        // Çizgi yokken (kapalı veya tam açık) normal dikey düzen kullanılıyor.
        if let division, division.frame.width > 0 {
            HStack(alignment: .top, spacing: 0) {
                // iPhone Duo: Sol kart çizginin başladığı yere (minX) kadar.
                hingeCard
                    .padding()
                    .frame(width: max(division.frame.minX, 0))
                // iPhone Duo: Çizginin olduğu alan boş bırakılıyor.
                Color.clear
                    .frame(width: division.frame.width)
                regionsCard(divisions: divisions, occlusions: occlusions)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        } else {
            VStack(spacing: 16) {
                hingeCard
                regionsCard(divisions: divisions, occlusions: occlusions)
            }
            .scenePadding()
        }
    }

    private var hingeCard: some View {
        InfoPanel {
            Label("Hinge", systemImage: "rectangle.portrait.split.2x1")
                .font(.headline)

            if let hinge {
                LabeledContent("Status", value: statusText(hinge.status))
                LabeledContent("Angle", value: hinge.angle.degrees.formatted(.number.precision(.fractionLength(0))) + "°")
                Gauge(value: min(max(hinge.angle.degrees, 0), 180), in: 0...180) {
                    EmptyView()
                }
                .tint(.pink)
            } else {
                Text("No hinge updates yet. Open or fold iPhone Duo to see changes.")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func regionsCard(divisions: [ReservedRegion], occlusions: [ReservedRegion]) -> some View {
        InfoPanel {
            Label("Reserved Regions", systemImage: "square.dashed")
                .font(.headline)

            if divisions.isEmpty && occlusions.isEmpty {
                Text("No reserved regions overlap this view.")
                    .foregroundStyle(.secondary)
            }
            ForEach(divisions) { region in
                RegionRow(title: "Division (fold)", region: region, tint: .pink)
            }
            ForEach(occlusions) { region in
                RegionRow(title: "Occlusion", region: region, tint: .orange)
            }
        }
    }

    private func statusText(_ status: DeviceHinge.Status) -> String {
        switch status {
        case .closed: "Closed"
        case .partiallyOpen: "Partially Open"
        case .fullyOpen: "Fully Open"
        // iPhone Duo: Status bir enum değil struct; ileride yeni durumlar
        // eklenebileceği için default şart.
        default: "Unknown"
        }
    }
}

private struct RegionRow: View {
    let title: String
    let region: ReservedRegion
    let tint: Color

    var body: some View {
        HStack {
            Circle()
                .fill(tint)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(title)
                Text("x: \(Int(region.frame.minX))  w: \(Int(region.frame.width))  h: \(Int(region.frame.height))")
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(region.isActive ? "Active" : "Inactive")
                .font(.caption.bold())
                .foregroundStyle(region.isActive ? tint : .secondary)
        }
    }
}

/// Draws reserved regions so you can see where the system wants you to keep clear.
private struct RegionOverlay: View {
    let regions: [ReservedRegion]
    let tint: Color

    var body: some View {
        ForEach(regions) { region in
            Rectangle()
                .fill(tint.opacity(region.isActive ? 0.25 : 0.08))
                .strokeBorder(tint, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                .frame(width: region.frame.width, height: region.frame.height)
                .position(x: region.frame.midX, y: region.frame.midY)
        }
        .allowsHitTesting(false)
    }
}

private struct FloatingActionButton: View {
    var body: some View {
        Button("Add Trip", systemImage: "plus") {}
            .font(.headline)
            .buttonStyle(.glassProminent)
            .controlSize(.large)
    }
}

#Preview {
    HingeLabView()
}
