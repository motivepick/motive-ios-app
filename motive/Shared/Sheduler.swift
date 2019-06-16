//
//  Sheduler.swift
//  motive
//
//  Created by Jelena on 15/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

enum Schedule: Int, CaseIterable {
    case SUNDAY
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    case OVERDUE
    case NEXT
    case TODAY
    case TOMORROW
}

struct Scheduler {
    func groupTasksByDates(_ tasks: Results<Task>) -> (sections: Array<Schedule>, groupedTasks: [Schedule:List<Task>]) {
        var sectionsOrdered: Array<Schedule> = []
        
        let groupedTasks = tasks.reduce(into: [Schedule:List<Task>](), { results, task in
            let date = task.dueDate! as Date
            let section: Schedule
            
            if DateUtils.isDateInPast(dueDate: date) {
                section = Schedule.OVERDUE
            }  else if DateUtils.isDateThisWeek(dueDate: date) {
                if DateUtils.isToday(dueDate: date) {
                    section = Schedule.TODAY
                } else if DateUtils.isTomorrow(dueDate: date) {
                    section = Schedule.TOMORROW
                } else {
                    let weekday = Calendar.current.component(.weekday, from: date)
                    section = Schedule.init(rawValue: weekday - 1)!
                }
            } else {
                section = Schedule.NEXT
            }
            
            if results[section] == nil {
                results[section] = List()
                sectionsOrdered.append(section)
            }
            results[section]?.append(task)
        })
        
        
        
        return (sections: sectionsOrdered, groupedTasks: groupedTasks)
    }
}
