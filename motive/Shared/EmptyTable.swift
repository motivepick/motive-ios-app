//
//  EmptyTable.swift
//  motive
//
//  Created by Jelena on 03.05.2020.
//  Copyright © 2020 Motivepick. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper {

    class func EmptyMessage(viewController:UITableViewController, message:String, withImage: UIImage? = nil) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
        
//        let imageName = "list.png"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
//        imageView.contentMode = .scaleAspectFit
//        imageView.center = viewController.view.center
//        viewController.view.addSubview(imageView)
        
    }
    
    class func restore(viewController:UITableViewController) {
            viewController.tableView.backgroundView = nil;
        }
    
    
}
