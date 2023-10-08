//
//  RandomUserRouter.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import Foundation
import Alamofire

// "https://randomuser.me/api/?page=3&results=10&seed=abc"
let BASE_URL = "https://randomuser.me/api/"

enum RandomUserRouter: URLRequestConvertible {
    case getUsers(page: Int = 1, result: Int = 20)
    
    var baseURL: URL {
        return URL(string: BASE_URL)!
    }
    
    var endPoint: String {
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }
    
    var paramters: Parameters {
        switch self {
        case .getUsers(let page, let result):
            var paramters = Parameters()
            paramters["page"] = page
            paramters["results"] = result
            paramters["seed"] = "dev"
            return paramters
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint )
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .getUsers:
            request = try URLEncoding.default.encode(request, with: paramters)
        }
        
        return request
    }
}


