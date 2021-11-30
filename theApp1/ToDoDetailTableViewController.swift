//
//  ToDoDetailTableViewController.swift
//  theApp1
//
//  Created by Brusik on 08.08.2021.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    var isDatePickerHidden = true
    var dateLabelIndexPath = IndexPath(row: 0, section: 1)
    var datePickerIndexPath = IndexPath(row: 1, section: 1)
    var notesIndexPath = IndexPath(row: 0, section: 2)
    var todo: ToDo?
    
    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePickerView: UIDatePicker!
    @IBOutlet var notesTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            dueDatePickerView.date = todo.dueDate
            isCompleteButton.isSelected = todo.isComplete
            notesTextView.text = todo.notes
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
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch  indexPath {
        case datePickerIndexPath where isDatePickerHidden == true :
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            dueDateLabel.textColor = .black
            updateDueDateLabel(date: dueDatePickerView.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
}
