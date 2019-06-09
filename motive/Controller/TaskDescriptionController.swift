//
//  TaskDescriptionController.swift
//  motive
//
//  Created by Jelena on 08/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import RealmSwift

class TaskDescriptionController: UIViewController, UITextViewDelegate, UINavigationBarDelegate {
    
    var task: Task?
    
    let placeholder = "A place for your notes"

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskDescriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskDescriptionField.delegate = self
        setInitialFieldsValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupToolBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveDescription()

        super.viewWillDisappear(animated)
        tearDownToolBar()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    //MARK: Handle Description Change
    func textViewDidBeginEditing(_ textView: UITextView) {
        if hasAnyText(task?.taskDescription ?? "") {
            taskDescriptionField.text = task?.taskDescription
        } else {
            taskDescriptionField.text = ""
            taskDescriptionField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveDescription()
    }
    
    //MARK: Handle Keyboard Appear
    @objc func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.5){
            self.bottomConstraint.constant = keyboardHeight + 15
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        UIView.animate(withDuration: 0.5){
            self.bottomConstraint.constant = 15.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func setInitialFieldsValues() {
        if hasAnyText(task?.taskDescription ?? "") {
            taskDescriptionField.text = task?.taskDescription
        } else {
            self.setPlaceholder()
        }
    }
    
    private func setupToolBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 236/255, blue: 231/255, alpha: 1.0)
    }
    
    private func tearDownToolBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    private func setPlaceholder() {
        taskDescriptionField.text = placeholder
        taskDescriptionField.textColor = UIColor.lightGray
    }
    
    private func saveDescription() {
        if taskDescriptionField.text != placeholder {
            TaskService.shared.update(task!, with: ["taskDescription": taskDescriptionField.text])
        }
    }
    
    private func hasAnyText(_ str: String) -> Bool {
        return  str.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
}
