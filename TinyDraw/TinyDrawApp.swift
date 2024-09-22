//
//  TinyDrawApp.swift
//  TinyDraw
//
//  Created by Péter Sebestyén on 2024.09.21.
//

import SwiftUI

@main
struct TinyDrawApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Drawing())
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Drawing())
}
