//
//  TableViewCell.swift
//  motive
//
//  Created by Jelena on 03/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import UIKit

extension TableViewCell {
    public enum TaskCompletionStatus: String {
        case done = "check-circle"
        case inProgress = "circle"
        
        func value() -> String {
            return self.rawValue
        }
    }
}


class TableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var closed: UIButton!
    
    private let dateFormatter = DateUtils.getDateFormatter()
    
    private let strokeEffect: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.strikethroughColor: UIColor.lightGray,
    ]
    
    func renderContent(itemName: String, isClosed: Bool, itemDueDate: NSDate?) {
        dueDate?.text = itemDueDate != nil ? dateFormatter.string(from: itemDueDate! as Date) : nil
        
        if isClosed {
            name?.attributedText = NSAttributedString(string: itemName, attributes: strokeEffect)
            name?.textColor = UIColor.lightGray
            dueDate?.textColor = UIColor.lightGray
            closed?.setTitle(TableViewCell.TaskCompletionStatus.done.value(), for: .normal)
        } else {
            name?.attributedText = NSAttributedString(string: itemName, attributes: nil)
            name?.textColor = UIColor.black
            closed?.setTitle(TableViewCell.TaskCompletionStatus.inProgress.value(), for: .normal)
        
            if let date = itemDueDate {
                dueDate?.textColor = DateUtils.isDateInPast(dueDate: date as Date) ? UIColor.AppColor.DARKER_RED : UIColor.AppColor.DARKER_GREEN
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
