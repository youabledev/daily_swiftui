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
    var fetchMoreSubject = PassthroughSubject<(), Never>()
    
    @Published var randomUsers = [RandomUser]()
    @Published var pageInfo: Info? {
        didSet {
            print(pageInfo?.description ?? "")
        }
    }
    @Published var isLoading: Bool = false
    
    init() {
        fetchRandomUsers()
        
        // send(값이 방출) 되면 sink 클로저 실행
        refreshActionSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchRandomUsers()
            }
            .store(in: &subscription)
        
        fetchMoreSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.isLoading {
                    self.fetchMore()
                }
            }
            .store(in: &subscription)
    }
    
    fileprivate func fetchMore()  {
        guard let page = pageInfo?.page else { return }
        
        let pageToLoad = page + 1
        self.fetchRandomUsers(pageToLoad)
    }
    
    fileprivate func fetchRandomUsers(_ currentPage: Int? = nil) {
        let page = currentPage == nil ? 1 : currentPage!
        
        self.isLoading = true
        
        AF.request(RandomUserRouter.getUsers(page: page))
            .publishDecodable(type: RandomUserResponse.self)
//            .compactMap { $0.value?.results }
            .compactMap { $0.value }
            .sink(receiveCompletion: fetchRandomUserCompletion(completion:), receiveValue: fetchRandomUserResponse(_:))
//            .sink { completion in
//                print(completion)
//            } receiveValue: { [weak self] receivedValue in
//                print(receivedValue.description)
////                self?.randomUsers.append(contentsOf: receivedValue)
//                self?.randomUsers += receivedValue.results
//                self?.pageInfo = receivedValue.info
//                
//                self?.isLoading = false
//            }
            .store(in: &subscription)
    }
    
    fileprivate func fetchRandomUserResponse(_ randomUserResponse: RandomUserResponse) {
        self.randomUsers += randomUserResponse.results
        self.pageInfo = randomUserResponse.info
        self.isLoading = false
    }
    
    fileprivate func fetchRandomUserCompletion(completion: Subscribers.Completion<DataResponsePublisher<RandomUserResponse>.Failure>) {
        
    }
}
