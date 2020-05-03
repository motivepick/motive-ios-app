//
//  TaskRemote.swift
//  motive
//
//  Created by Jelena on 12.10.2019.
//  Copyright © 2019 Motivepick. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import RealmSwift
import ObjectMapper

class TaskRemote {
    static let shared = TaskRemote()

    let realm = try! Realm()
    
    let url = "https://api.motivepick.com"
    let jwtToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzNjEyODk0MTYiLCJzY29wZXMiOlsiUk9MRV9VU0VSIl0sImlzcyI6Im1vdGl2ZSIsImlhdCI6MTU3MTQyMTYxMH0.EIWFP-SHp7bsqwXkNyvIAdwW_XMl87WmrKaH2_rTIJVsPtD34hc82KqvKn13e1UawHBantdU8CvvoMCZJ0A8Sw"

    init() {
        let properties = [
            HTTPCookiePropertyKey.domain: "api.motivepick.com",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "MOTIVE_SESSION",
            HTTPCookiePropertyKey.value: jwtToken,
        ]
        
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?
            .setCookie(HTTPCookie(properties: properties)!)
    }
    
    func loadTasks(completion: @escaping ([Task]) -> Void) {
        Alamofire.request("\(url)/tasks").responseString { response in
             switch response.result {
             case .success(let value):
                let tasks = Mapper<Task>().mapArray(JSONString: value)
                TaskClient.shared.createMany(tasks!)
                    
//                     completion(tasks)
                 case .failure(let error):
                     print(error)
                     completion([])
             }
         }
    }
    
    
    func getTasksByIsClosed (isClosed: Bool) -> Results<Task> {
        return realm
            .objects(Task.self)
            .filter("closed = %@", NSNumber(value: isClosed))
    }
    
}
