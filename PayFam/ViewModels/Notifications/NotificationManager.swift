//
//  NotificationManager.swift
//  PayFam
//
//  Created by Mattosha on 10/12/2022.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager {
    
    static let instance =  NotificationManager() // Singleton
    
    
    func requestAuthorization() {
        let options : UNAuthorizationOptions = [.alert, .sound , .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options:options) { success, error in
            if let error  = error {
                print("Notification Authorization Error : \(error)")
            }else{
                print("Notification Authorization Success")
            }
        }
    }
    
    func notify(title: String, subTitle : String,body : String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.sound = .default
        content.badge = (UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false )
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
       
        
    }
    
}
