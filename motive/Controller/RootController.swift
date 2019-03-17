//
//  ViewController.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func onLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Login", sender: self)
    }
}

