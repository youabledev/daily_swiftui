//
//  passThroughPublisherTest.swift
//  study
//
//  Created by zumin you on 2023/11/18.
//

import SwiftUI
import Combine

@Observable
class PassThroughPublisherTestViewModel {
    @ObservationIgnored let passThroughPublisher = PassthroughSubject<String, Error>()
    @ObservationIgnored var cancelable = Set<AnyCancellable>()
    
    var data: [String] = []
    
    init() {
        let items = ["one", "two", "three"]
        
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 + Double(index)) {
                self.passThroughPublisher.send(items[index])
            }
        }
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        passThroughPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
            }
            .store(in: &cancelable)
    }
}

struct PassThroughPublisherTest: View {
    @State private var vm = PassThroughPublisherTestViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                } //: ForEach
            } //: VStack
        } //: ScrollView
    }
}

#Preview {
    PassThroughPublisherTest()
}
