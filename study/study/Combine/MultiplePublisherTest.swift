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
    
    @Published var address: String = ""
    @Published var detailAddress: String = ""
    @Published var fullAddress: String = ""
    
    init() {
        // combineLatest test
        Publishers.CombineLatest($address, $detailAddress)
            .map {
                "\($0) \($1)"
            }
            .assign(to: \.fullAddress, on: self)
            .store(in: &cancellable)
    }
    
    func testCombineLatest() {
        stringPublisher
            .combineLatest(boolPublisher) // 두 개 이상의 publisher들이 발행하는 최신 값을 결합하여 새로운 값을 생성함
            .map { string, bool in
                // 어느 한 publisher에서 새로운 값이 방출될 때마다 다른 publisher의 가장 최근 값과 결합하여 새로운 결과를 방출함
                return "\(string)  \(bool)" // 각 publisher가 최소 한 번씩의 값을 방출한 후에 결합된 값을 방출하게 됨
            }
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
    
    func testMerge() {
        // 여러 publisher로 부터 발행된 값들을 단일 publisher로 병합하는데 사용함
        // 발행된 값들을 순서 관계 없이 그대로 방출
        let firstSubject = PassthroughSubject<String, Never>()
        let secondSubject = PassthroughSubject<String, Never>()
        
        firstSubject
            .merge(with: secondSubject)
            .sink { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancellable)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            firstSubject.send("가")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            firstSubject.send("나")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            secondSubject.send("다")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            firstSubject.send("라")
        }
    }
    
    func testZip() {
        // 여러 publisher를 결합하여 각 publisher로부터 방출되는 값들을 순서대로 쌍으로 묶음
        // 각 publisher의 타입은 달라도 되고, 동일한 순서로 값을 방출할 때 유용함
        let firstSubject = PassthroughSubject<String, Never>()
        let secondSubject = PassthroughSubject<Int, Never>()
        let thirdSubject = PassthroughSubject<Bool, Never>()
        
        firstSubject
            .zip(secondSubject, thirdSubject)
            .map {
                String($0.0 + "\($0.1)" + "\($0.2)")
            }
            .sink { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancellable)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            firstSubject.send("가")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            firstSubject.send("나")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            secondSubject.send(1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            firstSubject.send("라")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            secondSubject.send(2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            thirdSubject.send(true)
        }
    }
}

struct MultiplePublisherTest: View {
    @StateObject private var vm = MultiplePublisherTestViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                Button("combine latest") {
                    vm.testCombineLatest()
                }
                .buttonStyle(.borderedProminent)
                
                Button("merge") {
                    vm.testMerge()
                }
                .buttonStyle(.borderedProminent)
                
                Button("zip") {
                    vm.testZip()
                }
                .buttonStyle(.borderedProminent)
            }
            
            
            VStack {
                ForEach(vm.data, id: \.self) {
                    Text($0)
                }
            } //: VStack
            
            TextField("주소 입력", text: $vm.address)
            TextField("상세 주소 입력", text: $vm.detailAddress)
            Text("주소 : \(vm.fullAddress)")
        }
    }
}

#Preview {
    MultiplePublisherTest()
}
