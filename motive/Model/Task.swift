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
    @objc dynamic var visible: Bool = true
    @objc dynamic var dueDate: Date?
    @objc dynamic var taskDescription: String?
    
    @objc dynamic var created: Date?
    @objc dynamic var closingDate: Date?

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
        visible         <- map["visible"]
        dueDate         <- (map["dueDate"], DateFormatMapper(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"))
        created         <- (map["created"], DateFormatMapper(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"))
        closingDate     <- (map["closingDate"], DateFormatMapper(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS"))
        taskDescription <- map["description"]
    }
}
