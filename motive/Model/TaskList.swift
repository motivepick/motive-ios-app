//
//  TaskList.swift
//  motive
//
//  Created by Jelena on 12/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
    let tasks = List<Task>()
}
