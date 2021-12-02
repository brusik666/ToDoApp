//
//  Reminder.swift
//  theApp1
//
//  Created by Brusik on 01.12.2021.
//

import Foundation
import UserNotifications

struct Reminder: Codable, Hashable {
    var isOn: Bool = false
    
    static let notificationCategoryId = "ToDoNotification"
    static let remindActionID = "remindTomorrow"
    static let doneActionID = "done"
    
    private func authorizeIfNeeded(completion: @escaping (Bool) -> ()) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                completion(true)
                
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                    completion(granted)
                }
                
            case .denied, .provisional:
                completion(false)
            default: break
            }
        }
    }
    
    func schedule(todo: ToDo, completion: @escaping (Bool) -> ()) {
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
            content.categoryIdentifier = Reminder.notificationCategoryId
            
            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: todo.dueDate.addingTimeInterval(-60*60*24))
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: todo.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func unschedule(todo: ToDo) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
    }
}
