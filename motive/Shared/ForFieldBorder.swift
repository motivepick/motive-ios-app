//
//  ForFieldBorder.swift
//  motive
//
//  Created by Jelena on 03.05.2020.
//  Copyright © 2020 Motivepick. All rights reserved.
//

import UIKit

extension UIView {
    func addBorderAndColorToTextField(color: UIColor, width: CGFloat, corner_radius: CGFloat = 0, clipsToBounds: Bool = false) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = corner_radius
        self.clipsToBounds = clipsToBounds
    }
}
