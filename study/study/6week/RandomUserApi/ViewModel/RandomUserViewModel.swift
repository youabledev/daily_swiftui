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
    var refreshActionSubject = PassthroughSubject<(), Never>()
    
    @Published var randomUsers = [RandomUser]()
    
    let url = "https://randomuser.me/api/?results=50"
    
    init() {
        fetchRandomUsers()
        
        refreshActionSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchRandomUsers()
            }
            .store(in: &subscription)
    }
    
    fileprivate func fetchRandomUsers() {
        AF.request(url)
            .publishDecodable(type: RandomUserResponse.self)
            .compactMap { $0.value?.results }
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] (receivedValue: [RandomUser]) in
                print(receivedValue.description)
//                self?.randomUsers.append(contentsOf: receivedValue)
                self?.randomUsers = receivedValue
            }
            .store(in: &subscription)
    }
}
