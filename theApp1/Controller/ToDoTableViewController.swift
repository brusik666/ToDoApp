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
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ToDo>
    
    private let todoReminderManager = ReminderManager.shared
    
    let database = ToDoDataBase()
    
    var todoSnapshot: Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(database.existingTodosByCompletion[0], toSection: Section.uncompleteToDo)
        snapshot.appendItems(database.existingTodosByCompletion[1], toSection: Section.completeToDo)
        return snapshot
    }
    var tableViewDataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuringBarButtonItems()
        configureTableViewDataSource(tableView)
        tableView.register(TableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableViewSectionHeader.identifier)
        
        tableViewDataSource.apply(todoSnapshot)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewSectionHeader.identifier) as! TableViewSectionHeader
        switch section {
        case 0: headerView.setTitle(title: Section.uncompleteToDo.title!)
        case 1: headerView.setTitle(title: Section.completeToDo.title!)
        default: break
        }
        tableView.addSubview(headerView)
        return headerView
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

    
    @IBAction func unwindToTodoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else {return}
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        
        if let todo = sourceViewController.todo {
            if let indexOfExistingTodo = database.existingTodos.firstIndex(of: todo) {
                database.existingTodos[indexOfExistingTodo] = todo
            } else {
                database.addToDo(todo: todo)
            }
        }
        tableViewDataSource.apply(todoSnapshot, animatingDifferences: false, completion: nil)
    }
    
    func presentNeedAuthorizationAlert() {
        let title = "Authorization needed"
        let message = "We need you to grant permission to send you reminders. Please go to iOS Settings app and grant notification permissions."
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
        detailController?.todo = database.existingTodosByCompletion[indexPath.section][indexPath.row]
        return detailController
    }
    
    func checkMarkTapped(sender: ToDoCellTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let todo = database.existingTodosByCompletion[indexPath.section][indexPath.row]
        if let index = database.existingTodos.firstIndex(of: todo) {
            database.existingTodos[index].isComplete.toggle()
        }
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.25) {
            self.tableViewDataSource.apply(self.todoSnapshot, animatingDifferences: true, completion: nil)
        }
    }
    func shareButtonTapped(sender: ToDoCellTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            let todo = database.existingTodos[indexPath.row]
            let activityController = UIActivityViewController(activityItems: ["I need to \(todo.title)", todo.notes ?? ""], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = sender
            
            present(activityController, animated: true, completion: nil)
        }
    }
}
