//
//  MathmaticOperationTest.swift
//  study
//
//  Created by zumin you on 2023/11/18.
//

import SwiftUI
import Combine

@Observable
class MathmaticOperationTestViewModel {
    @ObservationIgnored var subject = PassthroughSubject<Int, Error>()
    @ObservationIgnored var cancelable = Set<AnyCancellable>()
    
    var data: [String] = []
    var errorMessage: String = ""
    
    private func publishData() {
        data.removeAll()
        
        let items: [Int] = [1, 10, 3, 4, 11, 5]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.subject.send(items[index])
                
                if index == items.indices.last {
                    self.subject.send(completion: .finished)
                }
            }
        }
    }
    
    // MARK: Opeartors
    func startMax() {
        subject
            .max() // max 값을 알기 위해서 그 범위가 명확해야 한다. finish가 되지 않으면 아직 값을 퍼블리쉬 할 수 있다 판단하기 때문에 동작하지 않는다.
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish max")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startMaxBy() {
        subject
            .max(by: { $0 < $1 }) // [1, 2, 3, 4, 11, 5] 일 때 11 publish. enum 타입이나 특정 값을 비교해야 할 때 사용할 수 있음
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish max")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startMin() {
        subject
            .min()
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish min")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startMinBy() {
        subject
            .min(by: { $0 < $1 }) // [1, 10, 3, 4, 11, 5] 일때 1
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish min by")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
}

struct MathmaticOperationTest: View {
    @State private var vm = MathmaticOperationTestViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("max") {
                        vm.startMax()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("max by") {
                        vm.startMaxBy()
                    }
                    .buttonStyle(.bordered)
                } //: HStack
                
                HStack {
                    Button("min") {
                        vm.startMin()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("min by") {
                        vm.startMinBy()
                    }
                    .buttonStyle(.bordered)
                }
            } //: VStack
            
            ScrollView {
                VStack {
                    ForEach(vm.data, id: \.self) {
                        Text($0)
                    }
                } //: VStack
            } //: ScrollView
            Text(vm.errorMessage)
                .foregroundStyle(.red)
        } //: VStack
    }
}

#Preview {
    MathmaticOperationTest()
}
