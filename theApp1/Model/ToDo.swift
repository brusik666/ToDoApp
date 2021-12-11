import Foundation
import UserNotifications
import UIKit

struct ToDo: Equatable, Comparable, Codable, Hashable {
   
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

    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.title == rhs.title && lhs.hashValue == rhs.hashValue
    }
    
    static func < (lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.dueDate < rhs.dueDate
    }
}




