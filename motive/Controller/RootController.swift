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
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabViewController") as! MainTabViewController

        let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        
        app.window!.rootViewController = mainTabController
        app.window!.makeKeyAndVisible()

    }
}

