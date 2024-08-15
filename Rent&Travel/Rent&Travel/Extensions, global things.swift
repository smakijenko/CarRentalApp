//
//  Extensions, global things.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 17/07/2024.
//

import Foundation
import SwiftUI

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

extension Color{
    static let project = ProjectColors()
}

struct ProjectColors{
    let logoBlue = Color("logoBlue")
    let logoOrange = Color("logoOrange")
}

func alertHandler(text: Text?) -> Alert{
    return Alert(title: text ?? Text("There is a problem with the connection."))
}
