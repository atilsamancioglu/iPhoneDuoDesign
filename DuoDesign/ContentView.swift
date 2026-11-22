//
//  ContentView.swift
//  DuoDesign
//
//  A standard TabView. On iPhone Duo the system moves the tab bar to the
//  side on the outer display and in landscape on the inner display.
//  We don't override that placement – we just use the standard component.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Principles", systemImage: "lightbulb") {
                PrinciplesView()
            }
            Tab("Explore", systemImage: "map") {
                ExploreView()
            }
            Tab("Arrange", systemImage: "square.split.2x1") {
                ArrangementDemoView()
            }
            Tab("Gallery", systemImage: "square.grid.2x2") {
                GalleryView()
            }
            Tab("Hinge", systemImage: "rectangle.portrait.split.2x1") {
                HingeLabView()
            }
        }
    }
}

#Preview {
    ContentView()
}
