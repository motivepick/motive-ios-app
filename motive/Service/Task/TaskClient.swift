//
//  TaskClient.swift
//  motive
//
//  Created by Jelena on 12.10.2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskClient {
    static let shared = TaskClient()
    
    let realm = try! Realm()

    private init() {}
    
    func create(_ object: [String: Any?]) {
        do {
            try realm.write {
                realm.create(Task.self, value: object, update: .modified)
            }
        } catch {
            handleError(error)
        }
    }
    
    func update(_ object: Task, with values: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in values {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            handleError(error)
        }
    }
    
    func delete(_ object: Task) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            handleError(error)
        }
    }
    
    func list(by filter: NSPredicate) -> Results<Task> {
        return realm
            .objects(Task.self)
            .filter(filter)
    }
    
    private func handleError(_ error: Error) {
        print("TaskService error \(error)")
    }
}
