//
//  TaskService.swift
//  motive
//
//  Created by Jelena on 07/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskService {
    static let shared = TaskService()

    private init() {}

    func add(_ newTaskName: String) {
        if hasAnyText(newTaskName) {
            TaskClient.shared.create(["name": newTaskName, "closed": false, "created": Date()])
        }
    }
    
    func update(_ task: Task, with dictionary: [String: Any?]) {
        var values: [String: Any?] = dictionary
        if !hasAnyText(values["name"] as Any?) { values["name"] = nil }
        if !hasAnyText(values["taskDescription"] as Any?) {
            values["taskDescription"] = ""
        }
        TaskClient.shared.update(task, with: values)
    }
    
    func saveToggledTaskClosed(_ task: Task) {
        let isOpen = !task.closed
        let values = isOpen ? ["closed": isOpen, "closingDate": nil ] : ["closed": isOpen, "closingDate": Date() ]
        TaskClient.shared.update(task, with: values)
    }
    
    func getTasksByClosed(_ showClosedTasks: Bool) -> Results<Task>  {
        let filter = NSPredicate(format: "closed = %@", NSNumber(value: showClosedTasks))
        return TaskClient.shared.list(by: filter)
    }
    
    func getOpenTasksWithDueDates() -> Results<Task>  {
        let filter = NSPredicate(format: "closed = false AND dueDate != nil")
        return TaskClient.shared.list(by: filter)
    }
    
    func delete(_ task: Task) {
        TaskClient.shared.update(task, with: ["visible": false])
    }
    
    private func handleError(_ error: Error) {
        print("TaskService error \(error)")
    }
    
    private func hasAnyText(_ str: Any?) -> Bool {
        if str == nil { return false }
        return  (str as! String).trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
