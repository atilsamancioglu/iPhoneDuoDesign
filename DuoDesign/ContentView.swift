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
        // iPhone Duo: Standart TabView kullanıyoruz. Dış ekranda ve iç ekran
        // yataydayken sistem tab bar'ı otomatik olarak yana (dikey eksene) alır.
        // Neden? Dış ekran geniş ama kısa; dikey alanı korumak için. Bu yerleşimi
        // asla override etmiyoruz, özel bir tab bar da yazmıyoruz.
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
