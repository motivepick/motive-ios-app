//
//  RealmService.swift
//  motive
//
//  Created by Jelena on 07/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskService {
    //singleton
    static let shared = TaskService()
    
    let realm = try! Realm()

    private init() {}

    func add(_ newTaskName: String) {
        if hasAnyText(newTaskName) {
            do {
                try realm.write {
                    let item = Task()
                    item.name = newTaskName
                    item.closed = false
                    
                    realm.add(item)
                }
            } catch {
                handleError(error)
            }
        }
    }
    
    func update(_ task: Task, with dictionary: [String: Any?]) {
        do {
            try realm.write() {
                for (key, value) in dictionary {
                    if key == "name" {
                        if hasAnyText(value as! String) {
                            task.setValue(value, forKey: key)
                        }
                    } else if key == "taskDescription" {
                        if hasAnyText(value as! String) {
                            task.setValue(value, forKey: key)
                        } else {
                            task.setValue((value as! String).trimmingCharacters(in: .whitespacesAndNewlines), forKey: key)
                        }
                    } else {
                        task.setValue(value, forKey: key)
                    }
                }
            }
        } catch {
            handleError(error)
        }
    }
    
    func saveToggledTaskClosed(_ task: Task) {
        do{
            try realm.write {
                task.closed = !task.closed
            }
        } catch {
            handleError(error)
            
        }
    }
    
    func getTasksByClosed(_ showClosedTasks: Bool) -> Results<Task>  {
        return realm
            .objects(Task.self)
            .filter("closed = %@", NSNumber(value: showClosedTasks))
    }
    
    func delete(_ task: Task) {
        do {
            try realm.write() {
                realm.delete(task)
            }
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        print("TaskService error \(error)")
    }
    
    private func hasAnyText(_ str: String) -> Bool {
        return  str.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
