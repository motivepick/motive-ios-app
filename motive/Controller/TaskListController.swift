//
//  TaskListController.swift
//  motive
//
//  Created by Jelena on 02/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskListController: UITableViewController, UITextFieldDelegate {
    var items: Results<Task>?

    @IBOutlet weak var newTaskField: UITextField!
    @IBOutlet weak var showClosedTasksButton: UIButton!
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var navBarItem: UINavigationItem!
    
    let strokeEffect: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
    ]
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    
    let red = UIColor.init(red: 227.0/255.0, green: 84.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    let green = UIColor.init(red: 120.0/255.0, green: 209.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    
    var showClosedTasks = false
    
    var selectedTask: Task?
    
    //TODO: add borders around TaskInfoView
    //TODO: apply color palette of motive
    //TODO: handle empty state
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTaskField.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTaskCell")

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))

        showCompletedTasks(showClosedTasks)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.tableView.endEditing(true)
        self.view.endEditing(true)
    }
    
    //MARK: - Tableview Datasource Methods

    // render number of cells. If no items to render, then render 1 cell with special content to handle empty table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    
//     USING custom cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! TableViewCell
        let today = calendar.startOfDay(for: Date())
        
        if let item = items?[indexPath.row] {
            cell.closed?.tag = indexPath.row;
            cell.closed?.addTarget(self, action: #selector(onCloseTask(sender:)), for: .touchUpInside)
            cell.dueDate?.text = item.dueDate != nil ? dateFormatter.string(from: item.dueDate! as Date) : nil
            
            if item.closed {
                cell.name?.attributedText = NSAttributedString(string: item.name, attributes: strokeEffect)
                cell.name?.textColor = UIColor.lightGray
                cell.dueDate?.textColor = UIColor.lightGray
                cell.closed?.setTitle(TableViewCell.TaskCompletionStatus.done.value(), for: .normal)
            } else {
                cell.name?.attributedText = NSAttributedString(string: item.name, attributes: nil)
                cell.name?.textColor = UIColor.black
                cell.closed?.setTitle(TableViewCell.TaskCompletionStatus.inProgress.value(), for: .normal)
                
                if (item.dueDate != nil) {
                    let comparison = today.compare(item.dueDate! as Date)

                    // ComparisonResult.orderedDescending ? "past" : "future"
                    cell.dueDate?.textColor = comparison == ComparisonResult.orderedDescending ? red : green
                }
            }
        } else {
            cell.name?.text = "No Items Added"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let task = items?[indexPath.row] {
            selectedTask = task
            self.performSegue(withIdentifier: "Go To Task Details", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Go To Task Details" {
            let destination = segue.destination as! TaskController
            destination.task = selectedTask
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }

    @objc func onCloseTask(sender: UIButton){
        let index = sender.tag
        if let task = items?[index] {
            TaskService.shared.saveToggledTaskClosed(task)
            self.reloadData()
        }
    }
    
    
    @IBAction func onToggleShowCompletedTasks(_ sender: UIButton) {
        showClosedTasks = !showClosedTasks
        showCompletedTasks(showClosedTasks)
    }
    
    func showCompletedTasks(_ show: Bool) {
        showClosedTasksButton?.setTitle(showClosedTasks ? "SHOW OPEN TASKS": "SHOW CLOSED TASKS", for: .normal)

        items = TaskService.shared.getTasksByClosed(showClosedTasks)
        self.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    

    //MARK: - Add New Items
    //TODO: - hide keyboard on click outside
    //TODO: - stick input to header
    //TODO: - set input constraints
    // TODO: ADD item to BEGINNEG of list
    @IBAction func onAddNewTask(_ sender: UITextField) {
        if let newTaskName = newTaskField.text {
            TaskService.shared.add(newTaskName)
            self.reloadData()
            newTaskField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK - Model Manipulation Methods
    func reloadData() {
        taskCountLabel.text = "\(items?.count ?? 0) tasks"
        self.tableView.reloadData()
    }
}

