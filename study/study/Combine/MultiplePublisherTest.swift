//
//  MultiplePublisherTest.swift
//  study
//
//  Created by zumin you on 2023/11/19.
//

import SwiftUI
import Combine

class MultiplePublisherTestViewModel: ObservableObject {
    let stringPublisher = PassthroughSubject<String, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    var cancellable = Set<AnyCancellable>()
    
    @Published var data: [String] = []
    
    init() {
        
    }
    
    func testCombineLatest() {
        stringPublisher
            .combineLatest(boolPublisher)
            .map { string, bool in
                return "\(string)  \(bool)"
            }
//            .removeDuplicates()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancellable)
        
        let items = ["1", "2", "3", "4", "5", "6", "7"]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                if index == 2 {
                    self.boolPublisher.send(true)
                } else if index == 5 {
                    self.boolPublisher.send(false)
                }
                self.stringPublisher.send(items[index])
            }
        }
            
    }
}

struct MultiplePublisherTest: View {
    @StateObject private var vm = MultiplePublisherTestViewModel()
    
    var body: some View {
        ScrollView {
            Button("combine latest") {
                vm.testCombineLatest()
            }
            .buttonStyle(.borderedProminent)
            
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                }
            } //: VStack
        }
    }
}

#Preview {
    MultiplePublisherTest()
}
