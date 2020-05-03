//
//  DateFormatMapper.swift
//  motive
//
//  Created by Jelena on 23.10.2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation

    
import ObjectMapper
public class DateFormatMapper: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    let dateFormatter = DateFormatter()
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormatter.dateFormat = dateFormat
    }

    public func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            return self.dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    public func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return self.dateFormatter.string(from: date)
        }
        return nil
    }
}
