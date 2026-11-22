//
//  Destination.swift
//  DuoDesign
//
//  Simple sample data used by every demo screen.
//

import SwiftUI

struct Destination: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let symbol: String
    let colors: [Color]
    let summary: String
    let highlights: [String]
    let bestSeason: String
    let rating: Double

    var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension Destination {
    static let samples: [Destination] = [
        Destination(
            name: "Cappadocia",
            country: "Türkiye",
            symbol: "balloon.2.fill",
            colors: [.orange, .pink],
            summary: "Fairy chimneys, cave hotels and hundreds of hot air balloons rising at sunrise.",
            highlights: ["Sunrise balloon flight", "Göreme Open Air Museum", "Underground cities"],
            bestSeason: "Apr – Jun",
            rating: 4.9
        ),
        Destination(
            name: "Kyoto",
            country: "Japan",
            symbol: "leaf.fill",
            colors: [.red, .purple],
            summary: "Temples, bamboo forests and quiet gardens that change with every season.",
            highlights: ["Fushimi Inari", "Arashiyama bamboo grove", "Tea ceremony"],
            bestSeason: "Mar – May",
            rating: 4.8
        ),
        Destination(
            name: "Reykjavík",
            country: "Iceland",
            symbol: "sparkles",
            colors: [.teal, .indigo],
            summary: "Northern lights, geothermal lagoons and dramatic volcanic landscapes.",
            highlights: ["Aurora hunting", "Golden Circle", "Blue Lagoon"],
            bestSeason: "Sep – Mar",
            rating: 4.7
        ),
        Destination(
            name: "Santorini",
            country: "Greece",
            symbol: "sun.max.fill",
            colors: [.cyan, .blue],
            summary: "White villages on volcanic cliffs above the deep blue Aegean Sea.",
            highlights: ["Oia sunset", "Red Beach", "Caldera boat tour"],
            bestSeason: "May – Oct",
            rating: 4.8
        ),
        Destination(
            name: "Banff",
            country: "Canada",
            symbol: "mountain.2.fill",
            colors: [.green, .teal],
            summary: "Turquoise lakes and snowy peaks in the heart of the Canadian Rockies.",
            highlights: ["Lake Louise", "Moraine Lake", "Icefields Parkway"],
            bestSeason: "Jun – Sep",
            rating: 4.9
        ),
        Destination(
            name: "Marrakesh",
            country: "Morocco",
            symbol: "moon.stars.fill",
            colors: [.yellow, .orange],
            summary: "Colorful souks, riads and the lively Jemaa el-Fnaa square at night.",
            highlights: ["Majorelle Garden", "Medina souks", "Atlas Mountains day trip"],
            bestSeason: "Mar – May",
            rating: 4.6
        ),
        Destination(
            name: "Lofoten",
            country: "Norway",
            symbol: "snowflake",
            colors: [.blue, .mint],
            summary: "Fishing villages and sharp mountains rising straight out of the Arctic sea.",
            highlights: ["Reine viewpoint", "Midnight sun", "Kayaking the fjords"],
            bestSeason: "Jun – Aug",
            rating: 4.8
        ),
        Destination(
            name: "Patagonia",
            country: "Chile",
            symbol: "wind",
            colors: [.indigo, .cyan],
            summary: "Granite towers, glaciers and endless wind at the end of the world.",
            highlights: ["Torres del Paine", "Grey Glacier", "W Trek"],
            bestSeason: "Nov – Mar",
            rating: 4.9
        )
    ]
}
