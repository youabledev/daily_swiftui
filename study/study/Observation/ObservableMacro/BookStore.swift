//
//  BookStore.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import Foundation
import Observation

@Observable 
class CarFactory {
    var address: String = "Seoul"
    var isOpen: Bool = false
    var car = Car(name: "Bentley", version: "v11")
    
    init(address: String, isOpen: Bool) {
        self.address = address
        self.isOpen = isOpen
    }
}

@Observable
class Car: ObservableObject {
    var name: String
    var version: String
    
    init(name: String, version: String) {
        self.name = name
        self.version = version
    }
}

final class ObservedCarFactory: ObservableObject {
    @Published var address: String = ""
    @Published var isOpen: Bool = false
    @Published var car = Car(name: "Bentley", version: "v12")
}
