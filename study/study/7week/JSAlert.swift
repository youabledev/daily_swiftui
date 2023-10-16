//
//  JSAlert.swift
//  study
//
//  Created by zumin you on 2023/10/16.
//

import Foundation

struct JSAlert: Identifiable {
    enum TYPE: CustomStringConvertible {
        case JS_ALERT, JS_BRIDGE
        
        var description: String {
            switch self {
            case .JS_ALERT: return "JS 얼럿"
            case .JS_BRIDGE: return "JS 브릿지"
            }
        }
    }
    
    let id: UUID = UUID()
    var message: String = ""
    var type: TYPE
    
    init(_ message: String? = nil, type: TYPE) {
        self.message = message ?? "no message"
        self.type = type
    }
}
