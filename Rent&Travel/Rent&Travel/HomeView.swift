//
//  HomeView.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 17/07/2024.
//

import SwiftUI
struct HomeView: View {
    @State var currentDateTime: String = ""
    @State var pickUpDate = Date()
    @State var returnDate = Date()
    @State var dayPeriod = 0 //default
    @ObservedObject var DBManager = DataBaseManager.shared
    @State var showCarChoosingView = false
    @State var formattedPickUpDate = ""
    @State var formattedReturnDate = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.project.logoBlue.ignoresSafeArea()
                VStack(spacing: 0){
                    HeaderView(currentDateTime: $currentDateTime)
                        .onAppear{
                            updateDateTime()
                            DBManager.updateAllAvailableCars()
                        }
                    DateSelectView(
                        pickUpDate: $pickUpDate,
                        returnDate: $returnDate,
                        formattedPickUpDate: $formattedPickUpDate,
                        formattedReturnDate: $formattedReturnDate,
                        DBManager: DBManager)
                    .onChange(of: DBManager.availableCarsDueToDate) {
                        showCarChoosingView = true
                        dayPeriod = countDays(pickUpDate: pickUpDate, returnDate: returnDate)
                    }
                    Text("ALL AVAILABLE CARS: ")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(10)
                    AllAvailableCarsView(cars: $DBManager.allAvailableCars)
                    Spacer()
                }
                .padding(.horizontal, 20)
                
            }
            .alert(isPresented: $DBManager.showAlert, content: {
                alertHandler(text: DBManager.alertText)
            })
            .navigationDestination(isPresented: $showCarChoosingView) {
                CarChoosingView(dayPeriod: $dayPeriod, formattedPickUpDate: formattedPickUpDate, formattedReturnDate: formattedReturnDate)
            }
        }
        .tint(.orange)
    }
    func updateDateTime(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentDateTime = getCurrentDateTime()
        }
        
        func getCurrentDateTime() -> String {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            return dateFormatter.string(from: date)
        }
    }
    
    func countDays(pickUpDate: Date, returnDate: Date) -> Int{
        let date1 = pickUpDate.timeIntervalSince1970
        let date2 = returnDate.timeIntervalSince1970
        let diffranceBetween = (date2 - date1) / 86400
        return Int(diffranceBetween.rounded(.up))
    }
}

struct HeaderView: View {
    @Binding var currentDateTime: String
    
    var body: some View {
        HStack{
            Image("logoTransparent")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 75, height: 75)
            Text(currentDateTime)
                .foregroundStyle(.white)
                .font(.title2)
                .fontWeight(.ultraLight)
        }
    }
}

struct DateSelectView: View {
    @Binding var pickUpDate: Date
    @Binding var returnDate: Date
    @Binding var formattedPickUpDate: String
    @Binding var formattedReturnDate: String
    @State private var startingDate = Date()
    @State private var lastPossibleDate = Calendar.current.date(from: DateComponents(year: 2025)) ?? Date()
    var DBManager: DataBaseManager
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.blue)
            .frame(maxHeight: 200)
            .opacity(0.4)
            .shadow(color: .black, radius: 10)
            .overlay(
                VStack{
                    Text("SELECT RENTAL DATES:")
                    VStack {
                        DatePicker("PICK UP DATE:", selection: $pickUpDate, in: startingDate ... lastPossibleDate, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: pickUpDate) {
                                pickUpDate = setProperDate(date: pickUpDate)
                            }
                        DatePicker("RETURN DATE:", selection: $returnDate, in: pickUpDate ... lastPossibleDate, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: returnDate) {
                                returnDate = setProperDate(date: returnDate)
                            }
                    }
                    .colorScheme(.dark)
                    .scaledToFit()
                    .minimumScaleFactor(0.1)
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        formattedPickUpDate = dateFormatter.string(from: pickUpDate)
                        formattedReturnDate = dateFormatter.string(from: returnDate)
                        DBManager.showAvailableCarsDueToDate(pickUpDate: formattedPickUpDate, returnDate: formattedReturnDate)
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.gray)
                                .frame(width: 120, height: 40)
                                .opacity(0.1)
                                .overlay(Text("SEARCH"))
                        }
                    })
                }
                    .font(.title3)
                    .foregroundStyle(.white)
            )
    }
    
    func setProperDate(date: Date) -> Date{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            return date
        }
        
        var newMinute = minute
        
        if 0 ..< 15 ~= minute {newMinute = 0}
        else if 15 ..< 30 ~= minute {newMinute = 15}
        else if 30 ..< 45 ~= minute {newMinute = 30}
        else {newMinute = 45}
        
        return calendar.date(bySettingHour: hour, minute: newMinute, second: 0, of: date) ?? Date()
    }
}

struct AllAvailableCarsView: View {
    @Binding var cars: [Car]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(cars){ car in
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.black)
                            .frame(width: 204, height: 324)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(width: 200, height: 320)
                            .opacity(0.8)
                            .overlay{
                                ZStack{
                                    VStack{
                                        Rectangle()
                                            .frame(width: 75, height: 20)
                                            .foregroundStyle(.logoOrange)
                                        Spacer()
                                        Image(car.name)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .scaledToFit()
                                        HStack{
                                            VStack(spacing: 5){
                                                Image(systemName: "car")
                                                Image(systemName: "car.side")
                                                Image(systemName: "engine.combustion")
                                                Image(systemName: "fuelpump")
                                                Image(systemName: "gearshift.layout.sixspeed")
                                                Image(systemName: "creditcard")
                                            }
                                            VStack(alignment: .leading, spacing: 4){
                                                Text(car.name)
                                                Text(car.body)
                                                Text(car.engin)
                                                Text(car.fuel)
                                                Text(car.gearbox)
                                                Text("\(car.pricePerDay) €/day")
                                            }
                                        }
                                        .font(.title3)
                                        Spacer()
                                        Rectangle()
                                            .frame(width: 75, height: 20)
                                            .foregroundStyle(.logoBlue)
                                            .opacity(0.95)   
                                    }
                                }
                            }
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    HomeView()
}
