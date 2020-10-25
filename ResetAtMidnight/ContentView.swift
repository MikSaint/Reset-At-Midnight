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
        
        //This timer checks if its a new day: If tommorrow is smaller then today, then make the newday true
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
        
        
        
        
//        VStack {
//          DateCheck1()
//            Text("\(self.userDefaultSettings.username)")
//        }
//
//    }
    
//      class UserDefaultSettings: ObservableObject {
//
//          @Published var username: String {
//             didSet {
//                 UserDefaults.standard.set(username, forKey: "username")
//             }
//          }
//
//
//          @Published var marriagestatus: String {
//             didSet {
//                 UserDefaults.standard.set(marriagestatus, forKey: "marriagestatus")
//             }
//          }
//          public var marriagestatuss = ["Single", "Married", "Separated", "Divorced"]
//
//
//          /// This is your setter for the birthday date
//          @Published var bdDay: Date {
//             didSet {
//                 UserDefaults.standard.set(bdDay.timeIntervalSince1970, forKey: "bdDay")
//             }
//          }
//
//          /// This is your formatted date as you prefer
//          var formattedBirthday: String {
//             let dateFormatter = DateFormatter()
//             dateFormatter.dateStyle = .full
//             return dateFormatter.string(from: bdDay)
//          }
//
//          init() {
//             self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
//             self.marriagestatus = UserDefaults.standard.object(forKey: "marriagestatus") as? String ?? "Single"
//             self.bdDay = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "bdDay"))
//            print(self.bdDay)
//          }

//      }


//}
    

    
  

//****************************************************************************************************
  
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
