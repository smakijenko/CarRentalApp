//
//  CarChoosingView.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 30/07/2024.
//

import SwiftUI

struct CarChoosingView: View {
    @ObservedObject var DBManager = DataBaseManager.shared
    @Binding var dayPeriod: Int
    @State var fullPrice: Int = 100 // default
    @State private var showForm = false
    @State var selectedCar: Car?
    var formattedPickUpDate: String
    var formattedReturnDate: String
    let testCar = Car(id: 3, name: "Toyota Yaris", body: "Hatchback", engin: "1.5 116HP", fuel: "Hybrid", gearbox: "Automatic",fuelCons: 5.3, maxPeople: 4, AC: "Manual", pricePerDay: 20)
    
    //    var body: some View {
    //        ZStack{
    //            Color.project.logoBlue.ignoresSafeArea()
    //            VStack{
    //                Text("CHOOSE A CAR:")
    //                    .foregroundStyle(.white)
    //                    .font(.title2)
    //                    .fontWeight(.medium)
    //                ScrollView(.vertical, showsIndicators: false){
    //                    VStack(spacing: 20){
    //                        ForEach(0..<7){_ in
    //                            ZStack{
    //                                RoundedRectangle(cornerRadius: 10)
    //                                    .fill(.black)
    //                                    .frame(width:337, height: 234)
    //                                    .opacity(0.8)
    //                                RoundedRectangle(cornerRadius: 10)
    //                                    .fill(.white)
    //                                    .frame(width:333, height: 230)
    //                                    .opacity(0.8)
    //                                    .overlay(
    //                                        ZStack{
    //                                            HStack{
    //                                                let width: CGFloat = 20
    //                                                let height: CGFloat = 75
    //                                                Rectangle()
    //                                                    .frame(width: width, height: height)
    //                                                    .foregroundStyle(.logoOrange)
    //                                                Spacer()
    //                                                Rectangle()
    //                                                    .frame(width: width, height: height)
    //                                                    .foregroundStyle(.logoBlue)
    //                                                    .opacity(0.95)
    //                                            }
    //                                            HStack(spacing: 0){
    //                                                VStack(spacing: 15){
    //                                                    Image(testCar.name)
    //                                                        .resizable()
    //                                                        .aspectRatio(contentMode: .fill)
    //                                                        .frame(width: 100, height: 60)
    //                                                    Text(testCar.name.uppercased())
    //                                                        .font(.title2)
    //                                                        .fontWeight(.medium)
    //                                                        .multilineTextAlignment(.center)
    //                                                    HStack{
    //                                                        Text("FULL:")
    //                                                            .fontWeight(.semibold)
    //                                                        RoundedRectangle(cornerRadius: 20)
    //                                                            .frame(width: 60, height: 40)
    //                                                            .foregroundStyle(.red)
    //                                                            .opacity(0.8)
    //                                                            .shadow(radius: 20)
    //                                                            .overlay {
    //                                                                Text("\(dayPeriod * testCar.pricePerDay)€")
    //                                                                    .foregroundStyle(.white)
    //                                                                    .fontWeight(.semibold)
    //                                                                    .scaledToFit()
    //                                                                    .minimumScaleFactor(0.1)
    //                                                            }
    //                                                    }
    //                                                }
    //                                                HStack{
    //                                                    VStack(spacing: 5){
    //                                                        Image(systemName: "car.side")
    //                                                        Image(systemName: "engine.combustion")
    //                                                        Image(systemName: "fuelpump")
    //                                                        Image(systemName: "gearshift.layout.sixspeed")
    //                                                        Image(systemName: "gauge.with.dots.needle.bottom.50percent")
    //                                                        Image(systemName: "person.3")
    //                                                        Image(systemName: "snowflake")
    //                                                    }
    //                                                    VStack(alignment: .leading){
    //                                                        Text(testCar.body)
    //                                                        Text(testCar.engin)
    //                                                        Text(testCar.fuel)
    //                                                        Text(testCar.gearbox)
    //                                                        Text("\(String(format: "%.1f", testCar.fuelCons)) ℓ/100km")
    //                                                        Text("\(testCar.maxPeople)")
    //                                                        Text(testCar.AC)
    //                                                    }
    //                                                }
    //                                            }
    //                                        }
    //                                    )
    //                                    .onTapGesture{
    //                                        showForm = true
    //                                        fullPrice = dayPeriod * testCar.pricePerDay
    //
    //                                    }
    //                                    .sheet(isPresented: $showForm, content: {
    //                                        NewClientForm(fullPrice: $fullPrice, formattedPickUpDate: formattedPickUpDate, formattedReturnDate: formattedReturnDate, car: testCar)
    //                                    })
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    var body: some View {
        ZStack{
            Color.project.logoBlue.ignoresSafeArea()
            VStack{
                Text("CHOOSE A CAR:")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.medium)
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 20){
                        ForEach(DBManager.availableCarsDueToDate){ car in
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.black)
                                    .frame(width:337, height: 234)
                                    .opacity(0.8)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .frame(width:333, height: 230)
                                    .opacity(0.8)
                                    .overlay{
                                        ZStack{
                                                let width: CGFloat = 20
                                                let height: CGFloat = 75
                                            HStack{
                                                Rectangle()
                                                    .frame(width: width, height: height)
                                                    .foregroundStyle(.logoOrange)
                                                Spacer()
                                                VStack(spacing: 15){
                                                    Image(car.name)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: 100, height: 60)
                                                    Text(car.name.uppercased())
                                                        .font(.title2)
                                                        .fontWeight(.medium)
                                                        .multilineTextAlignment(.center)
                                                    HStack{
                                                        Text("FULL:")
                                                            .fontWeight(.semibold)
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .frame(width: 60, height: 40)
                                                            .foregroundStyle(.red)
                                                            .opacity(0.8)
                                                            .shadow(radius: 20)
                                                            .overlay {
                                                                Text("\(dayPeriod * car.pricePerDay)€")
                                                                    .foregroundStyle(.white)
                                                                    .fontWeight(.semibold)
                                                                    .scaledToFit()
                                                                    .minimumScaleFactor(0.1)
                                                            }
                                                    }
                                                }
                                                HStack{
                                                    VStack(spacing: 5){
                                                        Image(systemName: "car.side")
                                                        Image(systemName: "engine.combustion")
                                                        Image(systemName: "fuelpump")
                                                        Image(systemName: "gearshift.layout.sixspeed")
                                                        Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                                                        Image(systemName: "person.3")
                                                        Image(systemName: "snowflake")
                                                    }
                                                    VStack(alignment: .leading, spacing: 4){
                                                        Text(car.body)
                                                        Text(car.engin)
                                                        Text(car.fuel)
                                                        Text(car.gearbox)
                                                        Text("\(String(format: "%.1f", car.fuelCons)) ℓ/100km")
                                                        Text("\(car.maxPeople)")
                                                        Text(car.AC)
                                                    }
                                                }
                                                Spacer()
                                                Rectangle()
                                                    .frame(width: width, height: height)
                                                    .foregroundStyle(.logoBlue)
                                                    .opacity(0.95)
                                            }
                                        }
                                    }
                                    .onTapGesture{
                                        selectedCar = car
                                        showForm = true
                                        fullPrice = dayPeriod * car.pricePerDay
                                    }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedCar) { car in
            NewClientForm(fullPrice: $fullPrice, formattedPickUpDate: formattedPickUpDate, formattedReturnDate: formattedReturnDate, selectedCar: car)
        }
    }
    
}

#Preview {
    CarChoosingView(dayPeriod: .constant(10), formattedPickUpDate: "2024-04-20 04:20", formattedReturnDate: "2024-04-20 16:20")
}
