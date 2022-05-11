//
//  ToDoManager.swift
//  theApp1
//
//  Created by Brusik on 07.12.2021.
//

import Foundation

class ToDoDataBase {
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    var existingTodos: [ToDo] {
        get {
            if let savedTodos = loadToDos() {
              //  savedTodos.sort {$0.dueDate < $1.dueDate}
                return savedTodos
            } else {
                return loadSampleTodos()
            }
        } set {
            let todos = newValue
            saveToDos(todos)
        }
    }
    var existingTodosByCompletion: [[ToDo]] {
        var uncompleteTodos = [ToDo]()
        var completeTodos = [ToDo]()
        
        existingTodos.forEach { todo in
            if todo.isComplete {
                completeTodos.append(todo)
            } else {
                uncompleteTodos.append(todo)
            }
        }
        return [uncompleteTodos, completeTodos]
    }
    
    
    func addToDo(todo: ToDo) {
        existingTodos.append(todo)
    }
    
    func deleteToDo(todo: ToDo) {
        guard let index = existingTodos.firstIndex(of: todo) else { return }
        existingTodos.remove(at: index)
    }

    private func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: ToDoDataBase.archiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
     
    private func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ToDoDataBase.archiveURL, options: .noFileProtection)
    }
    
    private func loadSampleTodos() -> [ToDo] {
        let todo1 = ToDo(title: "Feed my cats", isComplete: false, dueDate: Date(), notes: nil)
        let todo2 = ToDo(title: "Play with Johny", isComplete: false, dueDate: Date(), notes: "Make a cartrack and then play Lego")
        let todo3 = ToDo(title: "NovaPoshta", isComplete: true, dueDate: Date(), notes: "Get a fragile from shops")
        let todoSampleArray = [todo1, todo2, todo3]
        return todoSampleArray
    }
}
