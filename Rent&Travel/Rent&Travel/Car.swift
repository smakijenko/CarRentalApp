//
//  Car.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 28/07/2024.
//

import Foundation

struct Car: Codable, Identifiable, Equatable{
    var id: Int
    var name: String
    var body: String
    var engin: String
    var fuel: String
    var gearbox: String
    var fuelCons: Double
    var maxPeople: Int
    var AC: String
    var pricePerDay: Int
}
