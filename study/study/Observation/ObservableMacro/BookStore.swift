//
//  BookStore.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import Foundation
import Observation
import Combine

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
class Car {
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
    @Published var car: Car
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.car = Car(name: "Bentley", version: "v12")
        
//        car.objectWillChange
//            .sink { [weak self] _ in
//                self?.objectWillChange.send()
//            }
//            .store(in: &cancellables)
    }
}


//class Car: ObservableObject {
//    @Published var name: String // 이 내부에서 변경이 감지되기 때문에 ObservedCarFactory에서 car.name이 변경되더라도 이 변경을 감지 할 수 없음
//    @Published var version: String
//    
//    init(name: String, version: String) {
//        self.name = name
//        self.version = version
//    }
//}
