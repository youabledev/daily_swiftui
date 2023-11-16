//
//  AdvancedCombineView.swift
//  study
//
//  Created by zumin you on 2023/11/17.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher: [String] = [] // 1
    @Published var basicPublisher: String = ""
    
    let currentValuePublisher = CurrentValueSubject<String, Never>("one")
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.basicPublisher = ["one", "two", "three"]
//        } // 1
        
        let items = ["one", "two", "three"]
        
        for i in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.basicPublisher = items[i]
            }
        }
    }
}

class AdvancedCombineViewModel: ObservableObject {
    let dataService = AdvancedCombineDataService()
    var cancelable = Set<AnyCancellable>()
    
    @Published var data: [String] = []
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$basicPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedValue in
//                self?.data = returnedValue // 1
                self?.data.append(returnedValue)
            }
            .store(in: &cancelable )

    }
}

struct AdvancedCombineView: View {
    @StateObject private var vm = AdvancedCombineViewModel()
    
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
    AdvancedCombineView()
}
