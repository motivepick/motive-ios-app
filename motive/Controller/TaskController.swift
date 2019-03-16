//
//  TaskController.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import UIKit

class TaskController: UIViewController {
    
    var task: Task?
    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskName.text = task?.name
        taskDescription.text = task?.description
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
