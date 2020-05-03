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
    
    var showClosedTasks = false
    
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TaskRemote.shared.loadTasks  { tasks in
            print("loadng tASK")

            print(tasks)
//           self.items = tasks
           self.reloadData()
       }
        
        newTaskField.delegate = self
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        setupTableView()
//        addTapGesture()
        
        showCompletedTasks(showClosedTasks)
        
        showClosedTasksButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
    }

    //MARK: - Tableview Datasource Methods

    // render number of cells. If no items to render, then render 1 cell with special content to handle empty table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! TableViewCell
        
        if let item = items?[indexPath.row] {
            cell.closed?.tag = indexPath.row;
            cell.closed?.addTarget(self, action: #selector(onCloseTask(sender:)), for: .touchUpInside)
            cell.renderContent(itemName: item.name, isClosed: item.closed, itemDueDate: item.dueDate)
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
        cancelAddTask()
        let index = sender.tag
        if let task = items?[index] {
            TaskService.shared.saveToggledTaskClosed(task)
            self.reloadData()
        }
    }
    
    @IBAction func onToggleShowCompletedTasks(_ sender: UIButton) {
        cancelAddTask()
        showClosedTasks = !showClosedTasks
        showCompletedTasks(showClosedTasks)
    }
    
    func showCompletedTasks(_ show: Bool) {
//        showClosedTasksButton?.setTitle(showClosedTasks ? "SHOW OPEN TASKS": "SHOW CLOSED TASKS", for: .normal)
        showClosedTasksButton?.setTitle(showClosedTasks ? String.fontAwesomeIcon(name: .clipboardList) : String.fontAwesomeIcon(name: .clipboardCheck), for: .normal)

        items = TaskService.shared.getTasksByClosed(show)
        self.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    

    //MARK: - Add New Items
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

    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        let root = self.storyboard?.instantiateViewController(withIdentifier: "RootController") as! RootController
        
        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        app.window?.rootViewController = root
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newTaskField {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK - Model Manipulation Methods
    func reloadData() {
        taskCountLabel.text = "\(items?.count ?? 0) tasks"
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTaskCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        newTaskField.addBorderAndColorToTextField(color: UIColor.white, width: 1.0, corner_radius: 8.0, clipsToBounds: true)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        cancelAddTask()
    }
    
    func cancelAddTask() {
        newTaskField.text = ""
        view.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if items?.count ?? -1 > 0 {
            TableViewHelper.restore(viewController: self)
            return 1
        } else {
            TableViewHelper.EmptyMessage(viewController: self, message: "Seems like your task list is empty")
            return 0
        }
    }
}
