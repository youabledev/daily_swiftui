//
//  SequenceOperationTest.swift
//  study
//
//  Created by zumin you on 2023/11/18.
//

import SwiftUI
import Combine

@Observable
class SequenceOperationTestViewModel {
    @ObservationIgnored var subject = PassthroughSubject<Int, Error>()
    @ObservationIgnored var cancelable = Set<AnyCancellable>()
    @ObservationIgnored let items: [Int] = Array(0..<100)
    
    var data: [String] = []
    
    init() {
        
    }
    
    func startFirstOperation() {
        subject
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    private func publishData() {
        data.removeAll()
        
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.subject.send(index)
            }
        }
    }
}

struct SequenceOperationTest: View {
    @State private var vm = SequenceOperationTestViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button("first") {
                    vm.startFirstOperation()
                }
                .buttonStyle(.borderedProminent)
            } //: HStack
            
            ScrollView {
                VStack {
                    ForEach(vm.data, id: \.self) {
                        Text($0)
                    }
                } //: VStack
            } //: ScrollView
        } //: VStack
    }
}

#Preview {
    SequenceOperationTest()
}
