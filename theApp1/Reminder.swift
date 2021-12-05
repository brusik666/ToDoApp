//
//  Reminder.swift
//  theApp1
//
//  Created by Brusik on 01.12.2021.
//

import Foundation
import UserNotifications

class Reminder: NSObject, UNUserNotificationCenterDelegate {

    static let shared = Reminder()
    let notificationCenter = UNUserNotificationCenter.current()
    
    let notificationCategoryId = "ToDoNotification"
    let remindActionID = "remindTomorrow"
    let doneActionID = "done"
    let dismissActionID = "dismiss"
    
    private override init() {}
    
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
    
    func schedule(todo: ToDo, completion: @escaping (Bool) -> ()) {
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
            content.body = "\(todo.title) in 24 hours."
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = self.notificationCategoryId
            
            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: todo.dueDate.addingTimeInterval(-60*60*24))
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: todo.id.uuidString, content: content, trigger: trigger)
            
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
    
    func unschedule(todo: ToDo) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case remindActionID:
            
        case doneActionID:
            
        case dismissActionID:
            
        }
    }
    
}
