//
//  NewClientForm.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 01/08/2024.
//

import SwiftUI

struct NewClientForm: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var DBManager = DataBaseManager.shared
    @Binding var fullPrice: Int
    let formattedPickUpDate: String
    let formattedReturnDate: String
    let selectedCar: Car
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var country: String = ""
    @State private var homeAddress: String = ""
    @State private var isInsurance = false
    @State private var basicOpacity:Double = 1
    @State private var fullOpacity: Double = 0.5
    @State private var basicTickColor: Color = .logoOrange
    @State private var fullTickColor: Color = .white
    @State private var sumUpPrice: Double = 0

    var body: some View {
        NavigationStack{
            ZStack{
                Color.logoBlue.ignoresSafeArea()
                    .onAppear{
                        sumUpPrice = Double(fullPrice)
                    }
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        VStack {
                            Image(selectedCar.name)
                                .resizable()
                                .scaledToFit()
                            Text(selectedCar.name)
                                .fontWeight(.semibold)
                            Text("FILL A FORM TO RESERVE THE CAR:")
                                .fontWeight(.medium)
                                .font(.title2)
                                .scaledToFit()
                                .minimumScaleFactor(0.1)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        
                        FormView(text: "NAME:", data: $name)
                            .onSubmit{
                                if !checkWord(word: name){
                                    name = ""
                                }
                            }
                        FormView(text: "SURNAME:", data: $surname)
                            .onSubmit{
                                if !checkWord(word: surname){
                                    surname = ""
                                }
                            }
                        FormView(text: "EMAIL:", data: $email)
                            .onSubmit {
                                if !checkEmail(email: email){
                                    email = ""
                                }
                            }
                        FormView(text: "PHONE NUMBER:", data: $phoneNumber)
                            .onSubmit {
                                if !checkPhoneNum(number: phoneNumber){
                                    phoneNumber = ""
                                }
                            }
                        FormView(text: "COUNTRY: ", data: $country)
                            .onSubmit{
                                if !checkWord(word: country){
                                    country = ""
                                }
                            }
                        FormView(text: "HOME ADRESS:", data: $homeAddress)
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                InsuranceView(
                                    title: "BASIC PACKAGE",
                                    text1: "Mandatory liability insurance and comprehensive cover.",
                                    text2: "The own contribution for each damage is between 500 € and 1,500 €, depending on the car.",
                                    text3: nil,
                                    text4: nil,
                                    opacity: basicOpacity,
                                    tickColor: basicTickColor
                                )
                                .onTapGesture {
                                    basicOpacity = 1
                                    fullOpacity = 0.5
                                    basicTickColor = .logoOrange
                                    fullTickColor = .white
                                    isInsurance = false
                                    sumUpPrice = Double(fullPrice)
                                }
                                InsuranceView(
                                    title: "FULL INSURANCE",
                                    text1: "The own contribution for each damage is 0 €.",
                                    text2: "Full protection for every part of the car.",
                                    text3: "Anti-theft protection.",
                                    text4: "Super Assistance 24h.",
                                    opacity: fullOpacity,
                                    tickColor: fullTickColor
                                )
                                .onTapGesture {
                                    basicOpacity = 0.5
                                    fullOpacity = 1
                                    basicTickColor = .white
                                    fullTickColor = .logoOrange
                                    isInsurance = true
                                    sumUpPrice = Double(fullPrice) * 1.5
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        VStack{
                            Text("FULL PRICE FOR THE CAR: \(String(format: "%.1f", sumUpPrice)) €")
                                .foregroundStyle(.white)
                                .font(.title2)
                                .fontWeight(.medium)
                                .scaledToFit()
                                .minimumScaleFactor(0.1)
                            
                            Button(action: {
                                DBManager.makeReservation(
                                    name: name,
                                    surname: surname,
                                    email: email,
                                    phoneNumber: phoneNumber,
                                    country: country,
                                    homeAddress: homeAddress,
                                    idCar: selectedCar.id,
                                    pickUpDate: formattedPickUpDate,
                                    returnDate: formattedReturnDate,
                                    isInsurance: String(isInsurance),
                                    price: sumUpPrice
                                )
                            }, label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.logoOrange)
                                    .frame(height: 75)
                                    .shadow(radius: 7)
                                    .overlay(
                                        Text("SUBMIT")
                                            .font(.title)
                                            .foregroundStyle(.logoBlue)
                                            .fontWeight(.semibold)
                                    )
                            })
                        }
                        .padding(.horizontal, 30)
                    }
                }
            }
            .alert(isPresented: $DBManager.showAlert) {
                Alert(
                    title: Text("Success"),
                    message: DBManager.alertText,
                    dismissButton: .default(Text("OK"), action: {
                        DBManager.showAvailableCarsDueToDate(pickUpDate: formattedPickUpDate, returnDate: formattedReturnDate)
                        dismiss()
                    })
                )
            }
        }
    }
}

struct FormView:View {
    var text: String
    @Binding var data: String
    var body: some View {
        VStack {
            Text(text)
                .foregroundStyle(.white)
            TextField("", text: $data)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(height: 65)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .background(.formGray)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 15)
                .padding(.horizontal, 30)
        }
    }
}

struct InsuranceView: View {
    let title: String
    let text1: String
    let text2: String
    let text3: String?
    let text4: String?
    var opacity: Double
    var tickColor: Color
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 254,height: 304)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250,height: 300)
                .foregroundStyle(.formGray)
                .overlay{
                    VStack(spacing: 10){
                        Text(title)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundStyle(tickColor)
                        VStack(alignment: .leading, spacing: 10){
                            HStack(alignment: .top){
                                Image(systemName: "checkmark")
                                    .foregroundStyle(tickColor)
                                Text(text1)
                            }
                            HStack(alignment: .top){
                                Image(systemName: "checkmark")
                                    .foregroundStyle(tickColor)
                                Text(text2)
                            }
                            if text3 != nil{
                                HStack(alignment: .top){
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(tickColor)
                                    Text(text3!)
                                }
                            }
                            if text4 != nil{
                                HStack(alignment: .top){
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(tickColor)
                                    Text(text4!)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.white)
                }
        }
        .opacity(opacity)
    }
}

func checkWord(word: String) -> Bool{
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    for l in word{
        if !alphabet.contains(l){
            return false
        }
    }
    return true
}

func checkPhoneNum(number: String) -> Bool{
    let chars = Array("0123456789+-")
    for n in number{
        if !chars.contains(n){
            return false
        }
    }
    return true
}

func checkEmail(email: String) -> Bool{
    var countAts = 0
    var countDots = 0
    for l in email{
        if l == "@"{
            countAts += 1
        }
        else if l == "."{
            countDots += 1
        }
    }
    if countAts == 1 && countDots >= 0{
        return true
    }
    return false
}

#Preview {
    NewClientForm(fullPrice: .constant(10), formattedPickUpDate: "2024-04-20 04:20", formattedReturnDate: "2024-04-20 16:20", selectedCar: Car(id: 3, name: "Toyota Yaris", body: "Hatchback", engin: "1.5 116HP", fuel: "Hybrid", gearbox: "Automatic",fuelCons: 5.3, maxPeople: 4, AC: "Manual", pricePerDay: 20))
}
