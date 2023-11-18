//
//  TimingOperationTest.swift
//  study
//
//  Created by zumin you on 2023/11/18.
//

import SwiftUI
import Combine


class TimingOperationTestViewModel: ObservableObject {
    var subject = PassthroughSubject<Int, Error>()
    var nilSubject = PassthroughSubject<Int?, Error>()
    
    var cancelable = Set<AnyCancellable>()
    
    @Published var data: [String] = []
    @Published var errorMessage: String = ""
    @Published var searchText = ""
    
    init() {
        $searchText
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .drop { $0.isEmpty } // drop first가 안되서 drop으로 isEmpty 아닐 때 publish하도록
            .sink { text in
                print("-\(text)\n")
            }
            .store(in: &cancelable)
    }
    
    private func publishData() {

    }
    
    // MARK: - Operation
    func startDebounce() {
        subject
        // 특정 시간 동안 대기. 특정 시간 동안 추가 입력이 없을 경우 가장 최근의 입력을 출력
        // 0.75초 동안 값을 입력 받다가 0.75초가 지난 시점 부터 입력이 없으면 그 동안 입력된 텍스트를 출력
        // 입력을 받고 지정된 시간 대기 -> 지정된 시간이 안에 새로운 입력이 들어오지 않음 -> 최신 입력된 내용 출력
        // 처음 값이 찍히지 않은 이유는 0이 입력되고 나서 0.75초 대기, 0.5초에 새로운 값이 입력됨. 지정된 시간 이내에 새로운 값이 입력되었으므로 이전의 값을 버림. 이후 0.75초 대기 후 1.25초 동안 새로운 입력값이 없으므로 가장 최신 값인 2를 화면에 보여줌
        // 이후 1.5초가 되어 3이 입력되고 0.75초 대기. 새로운 값이 입력되지 않아 3이 화면에 출력됨
            .debounce(for: 0.75, scheduler: DispatchQueue.main)
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        data.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.subject.send(1)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subject.send(2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.subject.send(3)
        }
    }
    
    func testDelay() {
        subject
            .delay(for: 3, scheduler: RunLoop.main)
            .map { String($0) }
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
            .store(in: &cancelable)
        
        data.removeAll()
        let items = [1, 2, 3]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.subject.send(items[index])
            }
        }
    }
    
    func testMeasureInterval() {
        // upstream publisher가 emit하는 이벤트 간의 시간 간격을 측정함
        // 이벤트가 얼마나 자주 발생하는지 알수 있음
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .measureInterval(using: RunLoop.main)
            .sink { [weak self] value in
                self?.data.append("\(value)")
            }
            .store(in: &cancelable)
    }
    
    func test2MeasureInerval() {
        let publisher = PassthroughSubject<String, Never>()
        let intervalPublisher = publisher.measureInterval(using: RunLoop.main)
        
        let combinedPublisher = Publishers.Zip(publisher, intervalPublisher)
        
        combinedPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] event, interval in
                self?.data.append("\(event) :: \(interval)")
            }
            .store(in: &cancelable)

        publisher.send("test1") // print 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            publisher.send("test2") // print 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            publisher.send("test3") // print 4
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            publisher.send(completion: .finished)
        }
    }
}

struct TimingOperationTest: View {
    @StateObject private var vm = TimingOperationTestViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("debounce") {
                        vm.startDebounce()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("delay") {
                        vm.testDelay()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("measure interval1") {
                        vm.testMeasureInterval()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("measure interval2") {
                        vm.test2MeasureInerval()
                    }
                    .buttonStyle(.borderedProminent)
                } //: HStack
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
            TextField("search", text: $vm.searchText)
        } //: VStack
    }
}

#Preview {
    TimingOperationTest()
}
