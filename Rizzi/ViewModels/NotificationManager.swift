//
//  NotificationManager.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 07/09/23.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    init(){
        requestNotificationPermission()
    }
    
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
            if success {
                print("Permission Granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setUpNotification(task: Task){
        let content = UNMutableNotificationContent()
        content.title = "Rizzi"
        content.subtitle = task.taskDescription ?? ""
        content.sound = UNNotificationSound.default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.timeZone, .year, .month, .day, .hour, .minute], from: task.taskDeadline!),
            repeats: false)
        let request = UNNotificationRequest(identifier: task.taskId?.description ?? "", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
