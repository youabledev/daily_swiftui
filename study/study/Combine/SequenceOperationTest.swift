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
    
    var data: [String] = []
    var errorMessage: String = ""
    
    init() {
        
    }
    
    func startFirstOperation() {
        subject
            .map { String($0) }
            .first() // 가장 첫번째 요소만
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startFirstWithWhereOperation() {
        subject
            .first { $0 > 4 } // 해당 조건에 맞는 값 중 첫번째만
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startTryFirstOperation() {
        subject
            .tryFirst {
                if $0 == 1 {
                    throw URLError(.badServerResponse) // 에러 던질 수 있음
                }
                return $0 > 4 // 조건에 맞는 첫번째 요소만 반환
                // return $0 > 1 // show 2
            }
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished tryFirst")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription // error handling
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startLast() {
        subject
            .last()
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    // MARK: - publishing
    private func publishData() {
        data.removeAll()
        
        let items: [Int] = Array(0..<10)
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.subject.send(index)
                
                if index == items.count {
                    self.subject.send(completion: .finished) // finished를 보내면 게시 가능한 상태에서 completion 상태가 된다. (last는 마지막 값을 호출하므로 completion을 보내야 한다)
                }
            }
        }
    }
}

struct SequenceOperationTest: View {
    @State private var vm = SequenceOperationTestViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("first") {
                        vm.startFirstOperation()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("first with where") {
                        vm.startFirstWithWhereOperation()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("try first") {
                        vm.startTryFirstOperation()
                    }
                    .buttonStyle(.borderedProminent)
                } //: HStack
                
                HStack {
                    Button("last") {
                        vm.startLast()
                    }
                    .buttonStyle(.borderedProminent)
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
    SequenceOperationTest()
}
