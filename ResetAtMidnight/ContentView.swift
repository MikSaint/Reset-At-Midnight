//
//  ContentView.swift
//  ResetAtMidnight
//
//  Created by Mik on 2020-10-24.
//


import SwiftUI
import Combine
import Foundation 

//****************************************************************************************************

extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}

//****************************************************************************************************


struct ContentView: View {
    @State var Today = Date()
    @State var NewDay: Bool = UserDefaults.standard.bool(forKey: "NewDay")
    @State var Tomorrow = Date(timeIntervalSinceNow: UserDefaults.standard.double(forKey: "Tomorrow"))
    @State var CardEnabled: Bool = UserDefaults.standard.bool(forKey: "CardEnabled")
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
       
        VStack {
            
            // For some reason removing this stops the updateing of the timer
            if Tomorrow == Today && NewDay == true && CardEnabled == true {
            }

            if CardEnabled == true {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).padding().foregroundColor(.green)
                    Button(action: {
                        CheckNewDay()
                    }) {
                        Text("Mark today as done")
                    }
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).padding().foregroundColor(.red).cornerRadius(20)
                    Text("Not New Day\n")
                }
            }
            
            
            Button(action: {
                CardEnabled = true
                NewDay = true
                UserDefaults.standard.set(CardEnabled, forKey: "CardEnabled")
                UserDefaults.standard.set(NewDay, forKey: "NewDay")
            }) {
                Text("Set NewDay & CaredEnabled as true\n")
            }
            
            Text("Today " + "\(Date().description(with: Locale(identifier: "en-US")))").padding()
            Text("\(Today)").padding()

            Text("Tomorrow Code " + "\(Date().dayAfter.description(with: Locale(identifier: "en-US")))").padding()
            Text("Tomorrow Saved " + "\(Tomorrow.description(with: Locale(identifier: "en-US")))").padding()

            
            Text ("Card Enabled: " + "\(String(CardEnabled))")
            Text ("Newday: " + "\(String(NewDay))")

        }.padding(21.0)
        
        //Constant New Day Checker. This timer checks if it's a new day: If tommorrow is smaller then today, then make the newday true
        .onReceive(timer) { _ in
           Today = Date()
            
           if Today >= Tomorrow {
                NewDay = true
                print(Date(timeIntervalSinceNow: 0 * 60))
                print("New Day")
                print(Today)
                print(Tomorrow)
                print(Date().dayAfter)
                UserDefaults.standard.set(NewDay, forKey: "NewDay")
           }
//
//           if NewDay == true {
//                CardEnabled = true
//                UserDefaults.standard.set(CardEnabled, forKey: "CardEnabled")
//
//           }
       
       }
    }
    
    
    func CheckNewDay() {
        
        if NewDay == true {
            CardEnabled = false
            Tomorrow = Date().dayAfter
            NewDay = false
            
            UserDefaults.standard.set(CardEnabled, forKey: "CardEnabled")
            UserDefaults.standard.set(Date().dayAfter, forKey: "Tomorrow")
            UserDefaults.standard.set(NewDay, forKey: "NewDay")

        }
    }
}
        

//****************************************************************************************************
  
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
