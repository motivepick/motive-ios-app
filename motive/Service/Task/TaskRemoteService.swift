//
//  TaskService.swift
//  motive
//
//  Created by Evgeny Mironenko on 07/10/2018.
//  Copyright © 2018 Motivepick. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

import RealmSwift

class TaskRemoteService {
    
    
    
    
    static let sharedInstance = TaskRemoteService()

    let realm = try! Realm()
    
    let url = "https://api.motivepick.com"
    let jwtToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTgyNzM0MjkxOTYzNzcxIiwic2NvcGVzIjpbIlJPTEVfVVNFUiJdLCJpc3MiOiJtb3RpdmUiLCJpYXQiOjE1NTI3NzcxMjV9.3y8NYV_m3CnE80Nq1cZmMV6t8nnPBhiBS_nCmVwZCF1dLTliBgNipoXc3cpUpHChRzJNyKfKkRObI-N6aFbYcA"
    
    init() {
        let properties = [
            HTTPCookiePropertyKey.domain: "api.motivepick.com",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "SESSION",
            HTTPCookiePropertyKey.value: jwtToken,
        ]
        
        Alamofire.SessionManager.default.session.configuration.httpCookieStorage?
            .setCookie(HTTPCookie(properties: properties)!)
    }
    
    func loadTasks(completion: @escaping ([Task]) -> Void) {
//        Alamofire.request("\(url)/tasks").responseJSON { response in
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    print("JSON: \(json)")
//                    var tasks: [Task] = []
//                    for (_, object) in json {
//                        let name = object["name"].stringValue
//                        let description = object["description"].stringValue
//                        tasks.append(Task(name, description))
//                    }
//                    completion(tasks)
//                case .failure(let error):
//                    print(error)
//                    completion([])
//            }
//        }
    }
    
    
    func getTasksByIsClosed (isClosed: Bool) -> Results<Task> {
        return realm
            .objects(Task.self)
            .filter("closed = %@", NSNumber(value: isClosed))
    }
    
}
