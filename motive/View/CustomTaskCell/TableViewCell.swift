//
//  TableViewCell.swift
//  motive
//
//  Created by Jelena on 03/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import UIKit

enum TaskCompletionStatus: String {
    case done = "check-circle"
    case inProgress = "circle"
    
    func value() -> String {
        return self.rawValue
    }
}

class TableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var closed: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
