////
////  TaskServiceSync.swift
////  motive
////
////  Created by Jelena on 12.10.2019.
////  Copyright © 2019 Motivepick. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
//class TaskServiceSync {
//    //singleton
//    static let shared = TaskServiceSync()
//    let realm = try! Realm()
//
//    private init() {
//    
//    }
//
//
//    func listTasks(_ closed: Bool) -> Results<Task>  {
//        TaskRemoteService.shared.
//        return TaskService.shared.getTasksByClosed(closed)
//    }
//    
//    // Application Code
//    func updateUserFromServer() {
//        let url = URL(string: "http://myapi.example.com/user")
//        URLSession.shared.dataTask(with: url!) { data, _, _ in
//            let realm = try! Realm()
//            createOrUpdateUser(in: realm, with: data!)
//        }
//    }
//
//    public func createOrUpdateUser(in realm: Realm, with data: Data) {
//        let object = try! JSONSerialization.jsonObject(with: data) as! [String: String]
//        try! realm.write {
//            realm.create(User.self, value: object, update: .modified)
//        }
//    }
//
//    // Test Code
//
//    let testRealmURL = URL(fileURLWithPath: "...")
//
//    func testThatUserIsUpdatedFromServer() {
//        let config = Realm.Configuration(fileURL: testRealmURL)
//        let testRealm = try! Realm(configuration: config)
//        let jsonData = "{\"email\": \"help@realm.io\"}".data(using: .utf8)!
//        createOrUpdateUser(in: testRealm, with: jsonData)
//        let expectedUser = User()
//        expectedUser.email = "help@realm.io"
//        XCTAssertEqual(testRealm.objects(User.self).first!, expectedUser,
//                       "User was not properly updated from server.")
//    }
//    
//}
