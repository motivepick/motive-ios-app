//
//  TaskController.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import UIKit
import RealmSwift

class TaskController: UIViewController, UITextFieldDelegate {
    
    var task: Task?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var dueDateField: UITextField!
    @IBOutlet weak var taskDescriptionField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    private let dateFormatter = DateFormatter()
    
    //TODO: dueDAte toolbar colors
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateField.delegate = self
        taskDescriptionField.delegate = self
        
        createDueDatePicker()
        createDueDatePickerToolbar()
        setupDateFormatter()
        
        self.dueDateField.tintColor = .clear
        self.view.addSubview(dueDateField)
        
        addTapGesture()

        setInitialFieldsValues()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go to Task Description" {
            let destination = segue.destination as! TaskDescriptionController
            destination.task = task
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskDescriptionField.text = task?.taskDescription
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onDeleteButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        TaskService.shared.delete(task!)
    }
    
    @IBAction func onTaskNameUpdated(_ sender: UITextField) {
        TaskService.shared.update(task!, with: ["name": nameField.text])
    }
    
    //MARK: Handle Due Date
    @objc func onDateChange(datePicker: UIDatePicker) {
        dueDateField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func onCancelPickingDueDate () {
        dueDateField.text = task?.dueDate != nil ? dateFormatter.string(from: (task?.dueDate)! as Date) : ""
        view.endEditing(true)
    }
    
    @objc func onDonePickingDueDate () {
        TaskService.shared.update(task!, with: ["dueDate": datePicker?.date])
        view.endEditing(true)
    }

    // on ClearButton pressed
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        dueDateField.text = ""
        TaskService.shared.update(task!, with: ["dueDate": nil])
        view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dueDateFieldTag = 1
        let descriptionFieldTag = 2
        
        if textField.tag == dueDateFieldTag && task?.dueDate == nil {
            dueDateField.text = dateFormatter.string(from: Date())
        }
        
        if textField.tag == descriptionFieldTag {
            performSegue(withIdentifier: "Go to Task Description", sender: self)
            view.endEditing(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dueDateField.text = task?.dueDate != nil ? dateFormatter.string(from: (task?.dueDate)! as Date) : ""
    }
    
    //MARK: Setup View
    private func setInitialFieldsValues() {
        nameField.text = task?.name
        taskDescriptionField.text = task?.taskDescription
        
        if let dueDate = task?.dueDate {
            dueDateField.text = dateFormatter.string(from: dueDate as Date)
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createDueDatePicker() {
        datePicker = UIDatePicker()
        
        datePicker?.backgroundColor = UIColor.white
        
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.onDateChange(datePicker:)), for: .valueChanged)
      
        //set Datepicker as input
        dueDateField.inputView = datePicker
    }

    private func createDueDatePickerToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor.red
        toolBar.sizeToFit()

        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.onCancelPickingDueDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDonePickingDueDate))

        toolBar.setItems([cancel, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.dueDateField.inputAccessoryView = toolBar
    }

    private func setupDateFormatter() {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    }
}
