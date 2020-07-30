//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by Ian Becker on 7/29/20.
//  Copyright © 2020 Karl Pfister. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    var task: Task? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var dueDateValue: Date?
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateTextField.inputView = dueDatePicker
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, let dueDate = dueDateTextField.text, let notes = notesTextView.text, !name.isEmpty && !dueDate.isEmpty && !notes.isEmpty else {return}
        
        if let task = task {
            TaskController.sharedInstance.update(task: task, name: name, notes: notes, due: dueDateValue)
        } else {
            TaskController.sharedInstance.add(taskWithName: name, notes: notes, due: dueDateValue)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateTextField.text = dueDatePicker.date.stringValue()
        dueDateValue = sender.date
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        nameTextField.resignFirstResponder()
        dueDateTextField.resignFirstResponder()
        notesTextView.resignFirstResponder()
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let task = task else {return}
        nameTextField.text = task.name
        dueDateTextField.text = task.due?.stringValue()
        notesTextView.text = task.notes
    }
}
