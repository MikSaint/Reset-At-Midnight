//
//  ContentView.swift
//  ResetAtMidnight
//
//  Created by Mik on 2020-10-27.
//

import SwiftUI

//****************************************************************************************************

extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }
    static var early:  Date { return Date().earlier } // Debugging only
        
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    // Debugging only
    var earlier: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
}

//****************************************************************************************************

struct ContentView: View {
    @State var Today = Date()
    @State var TomorrowDate = Date() // iOS can't save Dates into userdefaults, so this is made a a temp var.
    @State var TomorrowString = UserDefaults.standard.string(forKey: "Tomorrow") ?? "No Date Saved" // Actually saves tomorrow as a string
    @State var NewDay = UserDefaults.standard.bool(forKey: "NewDay") // Remember if today is actually a new day
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Used as an updater to check if
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Debugging only
            if Today >= TomorrowDate {
                ZStack {
                    Circle().foregroundColor(.green).padding()
                    Text(" New Day")
                }
            } else {
                ZStack {
                    Circle().foregroundColor(.red).padding()
                    Text("Not New Day")
                }
            }
            
            // Debugging only
            Text("Today is:\n" + "\(Today.description(with: Locale(identifier: "current")))")
                .padding()
            Text("Tomorrow is:\n" + "\(TomorrowDate.description(with: Locale(identifier: "current")))")
                .padding()
            Text("Tomorrow Raw String:\n" + "\(TomorrowString)")
                .padding()
            
            // Stores Tomorrows Date
            Button(action: {
                TomorrowDate = Date().dayAfter
                ConvertTomorrowStringtoDate()
                StoreTomorrow()
                NewDay = false
                
            }) {
                Text("Store Tomorrow")
            }.padding()
            
            // Debugging only
            Button(action: {
                TomorrowDate = Date().earlier
                
            }) {
                Text("Reset tomorrow to an earlier time")
            }.padding()
            
        }.padding()
        
        .onAppear() {
            ConvertTomorrowStringtoDate() // Convert Tomorrow String as a Date()
        }
        
        .onReceive(timer) { _ in
            Today = Date() // Used to update Todays Date consistently becuase iOS won't do this by default
            if Today >= TomorrowDate {
                NewDay = true
                UserDefaults.standard.set(NewDay, forKey: "NewDay")
                StoreTomorrow() // Convert Date into a String and save to CoreData
            }
        }
    }
    
    func StoreTomorrow() {
        let date = Date().dayAfter
        let dff = DateFormatter()
        dff.dateStyle = .medium
        dff.timeStyle = .long
        dff.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        dff.locale = Locale(identifier: "current")
        UserDefaults.standard.set(dff.string(from: date), forKey: "Tomorrow")
        print("Stored \(dff.string(from: date)) into data")
    }
    
     func ConvertTomorrowStringtoDate() {
         let dateString = TomorrowString // the date string to be parsed
         let df = DateFormatter()
         df.locale = Locale(identifier: "current")
         df.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
         if let date = df.date(from: dateString) {
            TomorrowDate = date
         } else {
             print("Unable to parse date string")
         }
    }
}

//****************************************************************************************************

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
