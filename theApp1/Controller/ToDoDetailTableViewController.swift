//
//  ToDoDetailTableViewController.swift
//  theApp1
//
//  Created by Brusik on 08.08.2021.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController, RemindManagerAvailable {
    
    private var isDatePickerHidden = true
    private var dateLabelIndexPath = IndexPath(row: 0, section: 1)
    private var datePickerIndexPath = IndexPath(row: 1, section: 1)
    private var notesIndexPath = IndexPath(row: 0, section: 2)
    var todo: ToDo?
    
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var remindMeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uppdateUI()
    }
    
    func uppdateUI() {
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            dueDatePickerView.date = todo.dueDate
            isCompleteButton.isSelected = todo.isComplete
            notesTextView.text = todo.notes
            if remindManager!.scheduledNotifications.contains(where: { request in
                request.identifier == todo.title
            }) {
                remindMeSwitch.isOn = true
            } 
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func isCompleteButtonT(_ sender: UIButton) {
        isCompleteButton.isSelected.toggle()
    }
    @IBAction func datePickerCHanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
        updateSaveButtonState()
    }
    
  /*  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  indexPath {
        case datePickerIndexPath where isDatePickerHidden == true :
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    } */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            dueDateLabel.textColor = .black
            updateDueDateLabel(date: dueDatePickerView.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
        
        guard remindMeSwitch.isOn else {
            remindManager!.unschedule(todoWithIdentifier: title)
            return
        }
        remindManager!.schedule(todoWithIdentifier: title, triggeringDate: dueDate) { authorizationPermissionGranted in
            if !authorizationPermissionGranted {
                let todoTableViewController = segue.destination as! ToDoTableViewController
                todoTableViewController.presentNeedAuthorizationAlert()
            }
        }
    }
}
