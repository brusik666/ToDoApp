import Foundation
import UserNotifications

struct ToDo: Equatable, Codable, Hashable {

    var id = UUID()
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    var remindNotificationsScheduled: Bool = false
    
    static let dueDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.title == rhs.title //|| lhs.id == rhs.id
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




