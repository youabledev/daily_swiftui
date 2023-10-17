//
//  UserInfo.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import Foundation

@Observable
class UserInfo {
    var name: String
    var age: Int
    var phoneNumber: String
    
    init(name: String, age: Int, phoneNumber: String) {
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
    }
}
