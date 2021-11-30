import Foundation
import UserNotifications

struct ToDo: Equatable, Codable, Hashable {

    var id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    
    static let dueDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
     
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadSampleTodos() -> [ToDo] {
        let todo1 = ToDo(title: "Feed my cats", isComplete: false, dueDate: Date(), notes: nil)
        let todo2 = ToDo(title: "Play with Johny", isComplete: false, dueDate: Date(), notes: "Make a cartrack and then play Lego")
        let todo3 = ToDo(title: "NovaPoshta", isComplete: true, dueDate: Date(), notes: "Get a fragile from shops")
        let todoSampleArray = [todo1, todo2, todo3]
        return todoSampleArray
    }
    
}

extension ToDo {
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
    
    static let notificationCategoryId = "ToDoNotification"
    static let remindActionID = "remindTomorrow"
    static let doneActionID = "done"
}

extension ToDo {
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
            content.categoryIdentifier = ToDo.notificationCategoryId
            
            let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month], from: self.dueDate.addingTimeInterval(-86400))
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)
            
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


