//
//  LunchView.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 18/07/2024.
//

import SwiftUI

struct LunchView: View {
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    private let duration: Double = 1.3
    @State private var isAnimated: Bool = false
    @State private var counter: Double = 0
    @State private var showCar: Bool = true
    @Binding var showLunchView: Bool
    
    var body: some View {
        ZStack{
            Color.project.logoBlue
                .ignoresSafeArea()
            Image("logoTransparentCar")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .offset(x: isAnimated ? 280 : 0, y: -6)
                .animation(.easeInOut(duration: duration), value: isAnimated)
                .opacity(showCar ? 1 : 0)
            Image("logoTransparentText")
                .resizable()
                .frame(width: 150, height: 150, alignment: .center)
                .offset(y: -6)
        }
        .onAppear{
            isAnimated = true
        }
        .onReceive(timer, perform: { _ in
            counter += 0.1
            if counter >= duration{
                showLunchView = false
                showCar = false
            }
        })
    }
}

#Preview {
    LunchView(showLunchView: .constant(true))
}
