//
//  ViewController.swift
//  motive
//
//  Created by Evgeny Mironenko on 04/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

// TODO: find app icon <= how to reuse it
// TODO: login scren positioning of items

class RootController: UIViewController {
    @IBAction func onLoginWithVK(_ sender: UIButton) {
        UIApplication.shared.open(AppConfig.VK_OAUTH2_URL!, options: [:], completionHandler: nil)
    }
    
    @IBAction func onLoginWithFacebook(_ sender: UIButton) {
        UIApplication.shared.open(AppConfig.FB_OAUTH2_URL!, options: [:], completionHandler: nil)
    }
    
    @IBAction func onLoginWithAppleID(_ sender: UIButton) {
        print("Logged in with Apple ID")
    }
}

