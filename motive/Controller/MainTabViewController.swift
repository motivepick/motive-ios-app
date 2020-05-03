//
//  MainTabViewController.swift
//  motive
//
//  Created by Jelena on 16/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainTabViewController: UITabBarController {
    var itemLabels = ["Tasks", "Schedule"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstButton()
        setSecondButton()
    }
    

    private func setFirstButton() {
        let item = (self.tabBar.items?[0])! as UITabBarItem
        item.title = "Tasks"
        item.image = UIImage.fontAwesomeIcon(name: FontAwesome.listUl, style: .solid, textColor: UIColor.red, size: CGSize(width: 30, height: 30))
    }
    
    private func setSecondButton() {
        let item = (self.tabBar.items?[1])! as UITabBarItem
        item.title = "Schedule"
        item.image = UIImage.fontAwesomeIcon(name: FontAwesome.calendarAlt, style: .regular, textColor: UIColor.red, size: CGSize(width: 30, height: 30))
    }
}
