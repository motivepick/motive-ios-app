//
//  DateUtils.swift
//  motive
//
//  Created by Jelena on 11/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation


extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}



struct DateUtils {
    static private let dateFormatter = DateFormatter()
    static private let calendar = Calendar(identifier: .gregorian)
    
    static func isToday(dueDate: Date) -> Bool {
        let today = Date().startOfDay
        let comparison = today.compare(dueDate.startOfDay)
        return comparison == ComparisonResult.orderedSame
    }
    
    static func isTomorrow(dueDate: Date) -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: +1, to: Date())
        let comparison = tomorrow!.startOfDay.compare(dueDate.startOfDay)
        return comparison == ComparisonResult.orderedSame
    }
    
    static func isDateInPast(dueDate: Date) -> Bool {
        let today = Date().startOfDay
        let comparison = today.compare(dueDate)
        return comparison == ComparisonResult.orderedDescending
    }
    
    static func isDateThisWeek(dueDate: Date) -> Bool {
        let week = Calendar.current.date(byAdding: .day, value: +7, to: Date())
        let comparison = week!.endOfDay.compare(dueDate.startOfDay)
        return comparison == ComparisonResult.orderedDescending
    }
    
    static func isDateThisCalendarWeek(dueDate: Date) -> Bool {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: dueDate)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return false }
        return currentWeekOfYear == dateWeekOfYear
    }
    
    
    static func getDateFormatter() -> DateFormatter {
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter
    }
    
    static func getTasksSchedule() {
        
    }
}
