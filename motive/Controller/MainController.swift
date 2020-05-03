//
//  MainController.swift
//  motive
//
//  Created by Evgeny Mironenko on 17/03/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import UIKit

class MainController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let taskService = TaskRemoteService() // TODO: how to use DI?
    private var tasks: [Task] = []
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        activityIndicator.backgroundColor = UIColor.white
        super.viewDidLoad()
        
        reloadTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTasks()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenTask" {
            let destination = segue.destination as! TaskController
            destination.task = tableView.indexPathForSelectedRow.map { it in self.tasks[it.row] }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        // set the text from the data model
        cell.textLabel?.text = self.tasks[indexPath.row].name
        
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        self.performSegue(withIdentifier: "OpenTask", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            self.tasks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // TODO delete
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
    @IBAction func onRefresh(_ sender: UIBarButtonItem) {
        reloadTasks()
    }
    
    @IBAction func onLogout(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Logout", sender: self)
    }
    
    private func reloadTasks() {
        taskService.loadTasks() { tasks in
            self.tasks = tasks
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}
