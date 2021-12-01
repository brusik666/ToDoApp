//
//  ToDoTableViewController.swift
//  theApp1
//
//  Created by Brusik on 08.08.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    typealias DataSource = UITableViewDiffableDataSource<String, ToDo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, ToDo>
    
    var todos = [ToDo]()
    var todoSnapshot: Snapshot!
    var tableViewDataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedTodos = ToDo.loadToDos() {
            todos = savedTodos
        } else {
            todos = ToDo.loadSampleTodos()
        }
        configuringBarButtonItems()
        
        todoSnapshot = Snapshot()
        todoSnapshot.appendSections(["1"])
        todoSnapshot.appendItems(todos, toSection: "1")

        configureTableViewDataSource(tableView)
        tableViewDataSource.apply(todoSnapshot)
    
    }
    
    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, todo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoCellTableViewCell
            cell.delegate = self
            cell.configure(with: todo)
            return cell
        })
    }
    
    func configuringBarButtonItems() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
            
        //} else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
        }
    }
    
    @IBAction func unwindToTodoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return}
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let todo = sourceViewController.todo {
            if let indexOfExistingTodo = todos.firstIndex(of: todo) {
                todos[indexOfExistingTodo] = todo
                
            } else {
                todos.append(todo)
                todoSnapshot.appendItems([todo], toSection: "1")
            }
        }
        tableViewDataSource.apply(todoSnapshot)
        ToDo.saveToDos(todos)
    }
    
    func presentNeedAuthorizationAlert() {
        let title = "Authorization needed"
        let message = "We need you to grant permission to send you reminders. Please go to iOS Settings app and grant us notification permissions."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {return nil}
        tableView.deselectRow(at: indexPath, animated: true)
        let detailController = ToDoDetailTableViewController(coder: coder)
        detailController?.todo = todos[indexPath.row]
        return detailController
    }
    
    func checkMarkTapped(sender: ToDoCellTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete.toggle()
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    func shareButtonTapped(sender: ToDoCellTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let todo = todos[indexPath.row]
            let activityController = UIActivityViewController(activityItems: ["I need to \(todo.title)", todo.notes ?? ""], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = sender
            
            present(activityController, animated: true, completion: nil)
        }
        
    }
    
}
