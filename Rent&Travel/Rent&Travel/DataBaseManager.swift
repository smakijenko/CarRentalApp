//
//  DataBaseManager.swift
//  Rent&Travel
//
//  Created by Stanisław Makijenko on 28/07/2024.
//

import Foundation
import SwiftUI

class DataBaseManager: ObservableObject {
    static let shared = DataBaseManager()
    @Published var allAvailableCars: [Car] = []
    @Published var availableCarsDueToDate: [Car] = []
    @Published var showAlert: Bool = false
    @Published var alertText: Text?
    
    
    func updateAllAvailableCars() {
        allAvailableCars.removeAll()
        resetVariables()
        guard let url = URL(string: "http://localhost/updateAllAvailableCars.php/") else {
            self.showAlert.toggle()
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("HTTP request error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                }
                return
            }
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                }
                return
            }
            do {
                let decodedCars = try JSONDecoder().decode([Car].self, from: data)
                DispatchQueue.main.async {
                    self.allAvailableCars = decodedCars
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                }
            }
        }.resume()
    }
    

    func showAvailableCarsDueToDate(pickUpDate: String, returnDate: String){
        availableCarsDueToDate.removeAll()
        resetVariables()
        guard let url = URL(string: "http://localhost/showAvailableCarsDueToDate.php/") else {
            DispatchQueue.main.async {
                self.showAlert.toggle()
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "pickUpDate=\(pickUpDate)&returnDate=\(returnDate)"
        request.httpBody = bodyData.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("HTTP request error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert = true
                }
                return
            }
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.showAlert = true
                }
                return
            }
            do {
                let decodedCars = try JSONDecoder().decode([Car].self, from: data)
//                decodedCars.removeAll() // just to test errors
                DispatchQueue.main.async {
                    if decodedCars.isEmpty{
                        self.showAlert.toggle()
                        self.alertText = Text("There are not available cars in the selected date")
                    }
                    else{
                        self.availableCarsDueToDate = decodedCars
                    }
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                }
            }
        }.resume()
    }
    
    func makeReservation(name: String, surname: String, email: String, phoneNumber: String, country: String, homeAddress: String, idCar: Int, pickUpDate: String, returnDate: String, isInsurance: String, price: Double){
        resetVariables()
        guard let url = URL(string: "http://localhost/makeReservation.php") else {
            DispatchQueue.main.async {
                self.showAlert.toggle()
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyData = "name=\(name)&surname=\(surname)&email=\(email)&phoneNumber=\(phoneNumber)&country=\(country)&homeAddress=\(homeAddress)&idCar=\(idCar)&pickUpDate=\(pickUpDate)&returnDate=\(returnDate)&isInsurance=\(isInsurance)&price=\(price)"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    print(error ?? "error")
                    self.showAlert.toggle()
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                    self.alertText = Text("Reservation made successfully")
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert.toggle()
                }
            }
        }
        .resume()
    }
    
    func resetVariables(){
        self.showAlert = false
        self.alertText = nil
    }
}
