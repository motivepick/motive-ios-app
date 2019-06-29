//
//  Token.swift
//  motive
//
//  Created by Jelena on 29/06/2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct TokenService {
    static let KEICHAIN_KEY = "token"
    static let USER_LOGGED_IN_KEY = "isUserLoggedIn"
    static let shared = TokenService()
    
    private init() {}
    
    func saveToken(_ token: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(token, forKey: TokenService.KEICHAIN_KEY, withAccessibility: .afterFirstUnlock)
        if saveSuccessful {
            UserDefaults.standard.set(true, forKey: TokenService.USER_LOGGED_IN_KEY)
            UserDefaults.standard.synchronize()
        } else {
            print("Problems saving token")
        }
    }
    
    func getToken() -> String? {
        return KeychainWrapper.standard.string(forKey: TokenService.KEICHAIN_KEY)
    }
    
    func removeToken() {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: TokenService.KEICHAIN_KEY)
        if removeSuccessful {
            UserDefaults.standard.set(false, forKey: TokenService.USER_LOGGED_IN_KEY)
            UserDefaults.standard.synchronize()
        } else {
            print("Problems removing token")
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
}
