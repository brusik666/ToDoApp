//
//  Reminder.swift
//  theApp1
//
//  Created by Brusik on 01.12.2021.
//

import Foundation
import UserNotifications

class ReminderManager: NSObject, UNUserNotificationCenterDelegate {

    
    
    let notificationCenter = UNUserNotificationCenter.current()
    let notificationCategoryId = "ToDoNotification"
    let remindActionID = "remindTomorrow"
    let doneActionID = "done"
    let dismissActionID = "dismiss"
    
    var scheduledNotifications: [UNNotificationRequest] {
        var scheduledNotifications: [UNNotificationRequest] = []
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .default).async {
            self.notificationCenter.getPendingNotificationRequests { notifications in
                scheduledNotifications = notifications
                group.leave()
            }
        }
        group.wait()
        return scheduledNotifications
    }

    private override init() {}
    
    static let shared = ReminderManager()
    
    private func authorizeIfNeeded(completion: @escaping (Bool) -> ()) {
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
                
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                    completion(granted)
                }
                
            case .denied, .provisional:
                completion(false)
            default: break
            }
        }
    }
    
    func schedule(todoWithIdentifier todoTitle: String, triggeringDate todoDueDate: Date, completion: @escaping (Bool) -> ()) {
        notificationCenter.delegate = self
        authorizeIfNeeded { (granted) in
            guard granted else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "\(todoTitle) in 24 hours."
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = self.notificationCategoryId
            
            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: todoDueDate.addingTimeInterval(-60*60*24))
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: todoTitle, content: content, trigger: trigger)
            
            self.notificationCenter.add(request) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }

            let remindTomorrowAction = UNNotificationAction(identifier: self.remindActionID, title: "Remind Tomorrow", options: [])
            let todoIsDoneAction = UNNotificationAction(identifier: self.doneActionID, title: "Already Done", options: [])
            let dismissRemindAction = UNNotificationAction(identifier: self.dismissActionID, title: "Dismiss Reminder", options: [])
            
            let todoCategory = UNNotificationCategory(identifier: self.notificationCategoryId, actions: [remindTomorrowAction, todoIsDoneAction, dismissRemindAction], intentIdentifiers: [], options: [])
            
            self.notificationCenter.setNotificationCategories([todoCategory])
        }
    }
    
    func unschedule(todoWithIdentifier todoTitle: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [todoTitle])
    }
}
