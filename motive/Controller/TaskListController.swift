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
    let realm = try! Realm()
    
    var items: Results<Task>?

    @IBOutlet weak var newTaskField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTaskField.delegate = self
        tableView.separatorStyle = .none
        
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods

    // render number of cells. If no items to render, then render 1 cell with special content to handle empty table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.name
            cell.accessoryType = item.closed ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    

    //MARK: - Add New Items
    //TODO: - hide keyboard on click outside
    //TODO: - stick input to header
    //TODO: - set input constraints
    @IBAction func onAddNewTask(_ sender: UITextField) {
        if let newTaskName = newTaskField.text {
            let hasAnyText = newTaskName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            if hasAnyText {
                
                do {
                    try self.realm.write {
                        let item = Task()
                        item.name = newTaskName
                        item.closed = false
                        
                        realm.add(item)
                        newTaskField.text = ""
                        
                        self.tableView.reloadData()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            } else {
                newTaskField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK - Model Manipulation Methods
    
    func loadItems() {
        items = realm.objects(Task.self)
        tableView.reloadData()
    }
}

