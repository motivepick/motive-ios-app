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
    
    let strokeEffect: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
    ]
    
    let dateFormatter = DateFormatter()
    let calendar = Calendar(identifier: .gregorian)
    
    let red = UIColor.init(red: 227.0/255.0, green: 84.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    let green = UIColor.init(red: 120.0/255.0, green: 209.0/255.0, blue: 116.0/255.0, alpha: 1.0)
    
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

        loadItems()
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
            cell.dueDate?.text = item.dueDate != nil ? dateFormatter.string(from: item.dueDate!) : nil
            
            if item.closed {
                cell.name?.attributedText = NSAttributedString(string: item.name, attributes: strokeEffect)
                cell.name?.textColor = UIColor.lightGray
                cell.dueDate?.textColor = UIColor.lightGray
                cell.closed?.setTitle(TaskCompletionStatus.done.value(), for: .normal)
            } else {
                cell.name?.attributedText = NSAttributedString(string: item.name, attributes: nil)
                cell.name?.textColor = UIColor.black
                cell.closed?.setTitle(TaskCompletionStatus.inProgress.value(), for: .normal)
                
                if (item.dueDate != nil) {
                    let comparison = today.compare(item.dueDate!)

                    // ComparisonResult.orderedDescending ? "past" : "future"
                    cell.dueDate?.textColor = comparison == ComparisonResult.orderedDescending ? red : green
                }
            }
        } else {
            cell.name?.text = "No Items Added"
        }

        return cell
    }
    
    @objc func onCloseTask(sender: UIButton){
        let index = sender.tag
        if let task = items?[index] {
            do{
                try realm.write {
                    task.closed = !task.closed
                }
                self.tableView.reloadData()
            } catch {
                print("error \(error)")
            }
        }
    }
 
//    // USING normal cell
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("ENDTER")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
//
//        if let item = items?[indexPath.row] {
//                    print("SE \(item.name)")
//            cell.textLabel?.text = item.name
//        } else {
//            cell.textLabel?.text = "No Items Added"
//        }
//
//        return cell
//    }
    
    
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

