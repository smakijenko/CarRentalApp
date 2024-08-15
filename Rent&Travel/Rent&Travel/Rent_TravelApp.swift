//
//  Rent_TravelApp.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 17/07/2024.
//

import SwiftUI

@main
struct Rent_TravelApp: App {
    @State private var showLunchView: Bool = true
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView()
                    .zIndex(1.0)
                if showLunchView {
                    LunchView(showLunchView: $showLunchView)
                        .transition(.move(edge: .leading))
                        .zIndex(2.0)
                }
            }
            .animation(.linear, value: !showLunchView)
        }
    }
}

