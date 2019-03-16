//
//  Task.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import Foundation

struct Task {
    let name: String
    let description: String?
    
    init(_ name: String, _ description: String? = nil) {
        self.name = name
        self.description = description
    }
}
