//
//  ToDoTableViewController.swift
//  theApp1
//
//  Created by Brusik on 08.08.2021.
//

import UIKit
import UserNotifications

class ToDoTableViewController: UITableViewController, ToDoCellDelegate, UNUserNotificationCenterDelegate{
    
    typealias DataSource = ToDoTableViewDiffableDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, ToDo>
    
    private let section1 = "1"
    private let todoReminderManager = ReminderManager.shared
    
    var todos = [ToDo]() {
        didSet {
            ToDo.saveToDos(todos)
        }
    }
        var todoSnapshot: Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([section1])
        snapshot.appendItems(todos, toSection: section1)
        return snapshot
    }
    var tableViewDataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedTodos = ToDo.loadToDos() {
            todos = savedTodos
        } else {
            todos = ToDo.loadSampleTodos()
        }
        configuringBarButtonItems()
        configureTableViewDataSource(tableView)
        tableViewDataSource.apply(todoSnapshot)
    }
    
    private func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, todo) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoCellTableViewCell
            cell.delegate = self
            cell.isCompleteButton.isSelected = todo.isComplete
            cell.titleLabel.text = todo.title

            return cell
        })
    }

    private func configuringBarButtonItems() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableViewDataSource.apply(todoSnapshot)
        }
    }
    
    @IBAction func unwindToTodoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return}
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let todo = sourceViewController.todo {
            if let indexOfExistingTodo = todos.firstIndex(of: todo) {
                todos[indexOfExistingTodo] = todo
                for notif in todoReminderManager.scheduledNotifications {
                    print(notif.content.body)
                }
            } else {
                todos.append(todo)
            }
        }
        tableViewDataSource.apply(todoSnapshot, animatingDifferences: false, completion: nil)
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
        if todoReminderManager.scheduledNotifications.contains(where: { request in
            request.identifier == todos[indexPath.row].title
        }) {
            detailController?.shouldRemindSwitchBeenOn = true
        } else {
            detailController?.shouldRemindSwitchBeenOn = false }
        return detailController
    }
    
    func checkMarkTapped(sender: ToDoCellTableViewCell) {
        
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete.toggle()
            todos[indexPath.row] = todo
            tableViewDataSource.apply(todoSnapshot, animatingDifferences: false, completion: nil)
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
