//
//  RandomUser.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import Foundation

struct RandomUserResponse: Codable, CustomStringConvertible {
    let results: [RandomUser]
    
    var description: String { "user count :: \(results.count)"}
}

struct RandomUser: Codable, Identifiable {
    var id: String {
        return "\(userID.name)\(userID.value ?? "")"
    }
    
    var userID: RandomUserID
    var name: RandomUserName
    var picture: RandomUserPicture
    
    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case name
        case picture
    }
}

struct RandomUserID: Codable {
    let name: String
    let value: String?
}

struct RandomUserName: Codable {
    let title: String
    let first: String
    let last: String
}

struct RandomUserPicture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
