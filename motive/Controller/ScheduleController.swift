//
//  ScheduleController.swift
//  motive
//
//  Created by Jelena on 12/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class ScheduleController: UITableViewController {
    var items: [Schedule:List<Task>] = [:]
    var sections: Array<Schedule> = []

    var selectedTask: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getTasksSchedule()
    }
    
    //MARK: - Tableview Datasource Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sections[section])"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items[sections[section]]?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! TableViewCell
        
        let section = self.sections[indexPath.section]
        let sectionItems = items[section]
        
        if let item = sectionItems?[indexPath.row] {
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

        let section = self.sections[indexPath.section]
        let sectionItems = items[section]

        if let task = sectionItems?[indexPath.row] {
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
        let touchPoint: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        
        if let indexPath = self.tableView.indexPathForRow(at: touchPoint){
            let section = self.sections[indexPath.section]
            let sectionItems = items[section]
            if let item = sectionItems?[indexPath.row] {
                TaskService.shared.saveToggledTaskClosed(item)
                self.reloadData()
            }
        }
    }
    
    func reloadData() {
        getTasksSchedule()
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "customTaskCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    func getTasksSchedule() {
        let tasks = TaskService.shared.getOpenTasksWithDueDates()
        let scheduledTaskTuple = Scheduler().groupTasksByDates(tasks)
        sections = scheduledTaskTuple.sections
        items = scheduledTaskTuple.groupedTasks
    }
}
