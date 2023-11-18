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
        
        publishData()
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
