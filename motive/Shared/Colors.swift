//
//  Colors.swift
//  motive
//
//  Created by Jelena on 11/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    struct AppColor {
        static let DARKER_RED = UIColor.init(hex: 0xE35446)
        static let DARKER_GREEN = UIColor.init(hex: 0x78D174)
        static let GRAY = UIColor.init(hex: 0x8E8E93)
        static let BEIGE = UIColor.init(hex: 0xF2E7F5)
    }
}

