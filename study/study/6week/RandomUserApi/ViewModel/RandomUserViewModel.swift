//
//  RandomUserViewModel.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import Foundation
import Combine
import Alamofire

class RandomUserViewModel: ObservableObject {
    // MARK: Properties
    var subscription = Set<AnyCancellable>()
    
    @Published var randomUsers = [RandomUser]()
    
    let url = "https://randomuser.me/api/?results=50"
    
    init() {
        fetchRandomUsers()
    }
    
    func fetchRandomUsers() {
        AF.request(url)
            .publishDecodable(type: RandomUserResponse.self)
            .compactMap { $0.value?.results }
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] (receivedValue: [RandomUser]) in
                print(receivedValue.description)
                self?.randomUsers.append(contentsOf: receivedValue)
            }
            .store(in: &subscription)
    }
}
