//
//  Task.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Task: Object {
    @objc dynamic var id: Int = UUID().hashValue
    @objc dynamic var name: String = ""
    @objc dynamic var closed: Bool = false
    @objc dynamic var dueDate: NSDate?
    @objc dynamic var taskDescription: String?
    
    @objc dynamic var created: NSDate?
    @objc dynamic var closingDate: NSDate?

    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
}

extension Task: Mappable {
    func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        closed          <- map["closed"]
        dueDate         <- map["dueDate"]
        created         <- map["created"]
        closingDate     <- map["closingDate"]
        taskDescription <- map["taskDescription"]
    }
}
