//
//  Task.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var closed: Bool = false
    @objc dynamic var dueDate: NSDate?
    @objc dynamic var taskDescription: String?
    
    @objc dynamic var created: NSDate?
    @objc dynamic var closingDate: NSDate?
}
