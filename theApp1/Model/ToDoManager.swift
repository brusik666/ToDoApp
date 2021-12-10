//
//  ToDoManager.swift
//  theApp1
//
//  Created by Brusik on 07.12.2021.
//

import Foundation

struct ToDoDataManager {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
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
