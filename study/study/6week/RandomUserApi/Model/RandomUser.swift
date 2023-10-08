//
//  RandomUser.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import Foundation

struct RandomUserResponse: Codable, CustomStringConvertible {
    let results: [RandomUser]
    let info: Info
    
    var description: String { "user count :: \(results.count)"}
}

struct Info: Codable, CustomStringConvertible {
    var seed: String
    var resultsCount: Int
    var page: Int
    var version: String
    
    var description: String {
        return "seed: \(seed), resultsCount: \(resultsCount), page: \(page), version: \(version)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case seed
        case resultsCount = "results"
        case page
        case version
    }
}

struct RandomUser: Codable, Identifiable {
//    var id: String {
//        return "\(userID.name)\(userID.value ?? "")"
//    }
    var id = UUID()
    
    var userID: RandomUserID
    var name: RandomUserName
    var picture: RandomUserPicture
    
    private enum CodingKeys: String, CodingKey {
        case userID = "id"
        case name
        case picture
    }
}

extension RandomUser: Equatable {
    static func == (lhs: RandomUser, rhs: RandomUser) -> Bool {
        return lhs.id == rhs.id
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
