import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    lazy var dataBase = ToDoDataBase()
    lazy var remindManager = ReminderManager()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let title = response.notification.request.content.body
        var existingTodo: ToDo!
        var indexOfExistingTodo: Int!
        
        for todo in dataBase.existingTodos {
            guard todo.title == title else { continue }
            existingTodo = todo
        }
        
        indexOfExistingTodo = dataBase.existingTodos.firstIndex(of: existingTodo)
        
        
        switch response.actionIdentifier {
        case remindManager.doneActionID:
            existingTodo.isComplete = true
            print("done")
        case remindManager.dismissActionID:
            remindManager.unschedule(todoWithIdentifier: title)
        case remindManager.remindActionID:
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.minute, .hour, .day, .month], from: Date().addingTimeInterval(60)), repeats: false)
            let request = UNNotificationRequest(identifier: existingTodo.title, content: response.notification.request.content, trigger: trigger)
            remindManager.notificationCenter.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        default: break
        }
        
        dataBase.existingTodos[indexOfExistingTodo] = existingTodo
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        remindManager.notificationCenter.delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner, .list])
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.

    }


}

