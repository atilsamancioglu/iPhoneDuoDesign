//
//  Components.swift
//  DuoDesign
//
//  Small reusable views. Note that none of them use fixed widths:
//  on iPhone Duo the same view must look right on the outer display,
//  on the inner display, and on either side of the fold.
//

import SwiftUI

/// Colorful artwork made from a gradient and an SF Symbol (no image assets needed).
struct DestinationArtwork: View {
    let destination: Destination
    var symbolScale: CGFloat = 0.35

    var body: some View {
        // iPhone Duo: İkon boyutu sabit değil, view'ün o anki boyutuna oranla
        // hesaplanıyor. Aynı view dış ekranda, iç ekranda ve çizginin iki
        // yanında farklı boyutlarda kullanıldığı için böyle yapıyoruz.
        GeometryReader { proxy in
            ZStack {
                destination.gradient
                Image(systemName: destination.symbol)
                    .font(.system(size: min(proxy.size.width, proxy.size.height) * symbolScale))
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(radius: 8)
            }
        }
    }
}

struct DestinationRow: View {
    let destination: Destination

    var body: some View {
        HStack(spacing: 12) {
            DestinationArtwork(destination: destination, symbolScale: 0.5)
                .frame(width: 48, height: 48)
                .clipShape(.rect(cornerRadius: 12))
            // iPhone Duo: Split view'ün yan sütunu iç ekranda oldukça dar.
            // Puan rozeti sağda dururken "Cappadocia" ikiye bölünüyordu; bu
            // yüzden puanı alt satıra aldık ve satırları tek satıra sınırladık.
            VStack(alignment: .leading, spacing: 2) {
                Text(destination.name)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(destination.country) · ★ \(destination.rating.formatted(.number.precision(.fractionLength(1))))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 4)
    }
}

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        Label(rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.yellow.opacity(0.25), in: .capsule)
    }
}

struct DestinationCard: View {
    let destination: Destination

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            DestinationArtwork(destination: destination)
                .aspectRatio(4 / 3, contentMode: .fit)
            VStack(alignment: .leading, spacing: 4) {
                Text(destination.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(destination.country)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(.background.secondary)
        .clipShape(.rect(cornerRadius: 20))
    }
}

/// A rounded "glass" panel used for information cards.
struct InfoPanel<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(20)
        // iPhone Duo: Sabit genişlik yok; panel içinde bulunduğu alana yayılır
        // (tam ekran, çizginin bir yanı ya da ArrangementView'ün bir tarafı).
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 28))
    }
}
