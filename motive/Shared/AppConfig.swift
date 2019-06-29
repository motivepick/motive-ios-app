//
//  AppConfig.swift
//  motive
//
//  Created by Jelena on 11/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation

struct AppConfig {
    // **** Realm Cloud Users:
    // **** Replace MY_INSTANCE_ADDRESS with the hostname of your cloud instance
    // **** e.g., "mycoolapp.us1.cloud.realm.io"
    // ****
    // ****
    // **** ROS On-Premises Users
    // **** Replace the AUTH_URL and REALM_URL strings with the fully qualified versions of
    // **** address of your ROS server, e.g.: "http://127.0.0.1:9080" and "realm://127.0.0.1:9080"
    
    static let MY_INSTANCE_ADDRESS = "MY_INSTANCE_ADDRESS" // <- update this
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/ToDo")!
    
    static let API_ENDPOINT = "https://api.motivepick.com"
    static let API_URL = URL(string: API_ENDPOINT)
    static let VK_OAUTH2_URL = URL(string: "\(API_ENDPOINT)/oauth2/authorization/vk?mobile")
    static let FB_OAUTH2_URL = URL(string: "\(API_ENDPOINT)/oauth2/authorization/facebook?mobile")
}
