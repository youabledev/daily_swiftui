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
    
    func startLastWithWhere() {
        subject
//            .last { $0 > 2 } // 0 1 2 ... 7 8 9 finish 라면 가장 마지막인 9가 반환된다
            .last { $0 < 3 } // 0 1 2 ... 7 8 9 finish 라면, finish 방출 되고 난 후 2가 반환된다
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startTryLast() {
        subject
            .tryLast {
                if $0 == 1 {
                    throw URLError(.badServerResponse) // 에러 던질 수 있음
                }
                return $0 > 4 // last는 finish 시에 4보다 큰 3을 last로 반환하겠지만 1일 때 에러를 반환하게 되므로 3은 방출되지 않는다.
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
    
    func startDropFirst() {
        subject
            .dropFirst() // 첫번째 게시를 제외시킴. currentValuePublisher의 초기값을 제외시키는데 사용할 수 있음
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startDropFirstWithCount() {
        subject
            .dropFirst(2) // 앞에 두 개 항목을 제외 시킴
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startDropWhile() {
        subject
            .drop(while: { $0 < 5 }) // false를 반환할 때 까지 게시하지 않음. false일 때 게시되는 것이 아닌 false를 반환한 시점부터
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startTryDrop() {
        subject
            .tryDrop {
                if $0 > 15 {
                    throw URLError(.badServerResponse)
                }
                return $0 < 6
            }
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished tryDrop")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription // error handling
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startPrefix() {
        subject
            .prefix(3) // 앞 3개의 요소 반환
            .map { String($0) }
            .sink { _ in
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startPrefixWhile() {
        subject
            .prefix(while: { $0 < 5 }) // false를 반환하면 publish finish. true 까지 publish 하고 조건이 false가 되면 publish가 끝남
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish prefix while") // prefix while이 false를 반환하면 finish 됨
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startOutputAt() {
        subject
            .output(at: 0) // 인덱스이기 때문에 첫번째 요소의 인덱스는 0
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish output") // output에 의해 publish가 끝나면 finished
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startOutputIn() {
        subject
            .output(in: 2..<6) // 인덱스 범위를 지정하면 그 인덱스에 해당하는 요소가 published 됨
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish output in") // output에 의해 지정된 범위의 요소가 publish 되고 난 후 finish 
                case .failure(let error):
                    print(error.localizedDescription)
                }
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
                
                if index == items.indices.last {
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
                    
                    Button("last with where") {
                        vm.startLastWithWhere()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("try last") {
                        vm.startTryLast()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack {
                    Button("drop first") {
                        vm.startDropFirst()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("drop first with count") {
                        vm.startDropFirstWithCount()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("drop while") {
                        vm.startDropWhile()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("try drop") {
                        vm.startTryDrop()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack {
                    Button("Prefix") {
                        vm.startPrefix()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Prefix While") {
                        vm.startPrefixWhile()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack {
                    Button("Output at") {
                        vm.startOutputAt()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Output in") {
                        vm.startOutputIn()
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
