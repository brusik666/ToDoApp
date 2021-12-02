//
//  ToDoTableViewController.swift
//  theApp1
//
//  Created by Brusik on 08.08.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    typealias DataSource = CustomDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, ToDo>
    let section = "1"
    
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
        
        
        configureSnapshot()
        configureTableViewDataSource(tableView)
        tableViewDataSource.apply(todoSnapshot)
    
    }
    
    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, todo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoCellTableViewCell
            cell.delegate = self
            cell.isCompleteButton.isSelected = todo.isComplete
            cell.titleLabel.text = todo.title

            return cell
        })
    }
    
    func configureSnapshot() {
        todoSnapshot = Snapshot()
        todoSnapshot.appendSections([section])
        todoSnapshot.appendItems(todos, toSection: section)
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
            print("xyu")
            
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
                todoSnapshot.appendItems([todo], toSection: section)
            }
        }
        tableViewDataSource.apply(todoSnapshot, animatingDifferences: false, completion: nil)
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
       //     sender.configure(with: todo)
            var snapshot = Snapshot()
            snapshot.appendSections([section])
            snapshot.appendItems(todos)
            tableViewDataSource.apply(snapshot, animatingDifferences: false, completion: nil)
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
