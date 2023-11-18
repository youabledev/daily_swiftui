//
//  FilterReducingOperationTest.swift
//  study
//
//  Created by zumin you on 2023/11/18.
//

import SwiftUI
import Combine

@Observable
class FilterReducingOperationTestViewModel {
    @ObservationIgnored var subject = PassthroughSubject<Int, Error>()
    @ObservationIgnored var nilSubject = PassthroughSubject<Int?, Error>()
    
    @ObservationIgnored var cancelable = Set<AnyCancellable>()
    
    var data: [String] = []
    var errorMessage: String = ""
    
    private func publishData() {
        data.removeAll()
        
        let items: [Int] = [1, 10, 3, 4, 11, 11, 5, 11]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.subject.send(items[index])
                
                if index == items.indices.last {
                    self.subject.send(completion: .finished)
                }
            }
        }
    }
    
    private func publishDataWithNil() {
        data.removeAll()
        
        let items: [Int?] = [1, 10, nil, 4, nil, nil, 5, nil]
        for index in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)) {
                self.nilSubject.send(items[index])
                
                if index == items.indices.last {
                    self.nilSubject.send(completion: .finished)
                }
            }
        }
    }
    
    // MARK: - Opreation
    func startMap() {
        subject
            .map { String($0) }
            .map { $0 + "mapped!!"}
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startTryMap() {
        subject
            .tryMap({ value in
                if value == 10 {
                    throw URLError(.badServerResponse)
                }
                
                return String(value)
            })
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startCompactMap() {
        subject
            .compactMap({ value in
                if value == 10 {
                    return nil
                }
                return String(value)
            })
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startFilter() {
        subject
            .filter { $0 > 5 }
//            .tryFilter(T##isIncluded: (Int) throws -> Bool##(Int) throws -> Bool)
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startRemoveDuplicates() {
        subject
            .removeDuplicates() // 연속해서 동일한 경우 제거
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startRemoveDuplicatesBy() {
        self.data.removeAll()
        struct Point {
            let x: Int
            let y: Int
        }
        
        let points = [Point(x: 0, y: 0), Point(x: 0, y: 1),
                      Point(x: 1, y: 1), Point(x: 0, y: 1), Point(x: 2, y: 1)]
        
        points.publisher
            .removeDuplicates { prev, current in
                prev.x == current.x // x 값이 같은 연속되는 요소는 건너뜀
            }
            .sink { completion in
            } receiveValue: { [weak self] value in
                self?.data.append("\(value)")
            }
            .store(in: &cancelable)
    }
    
    func startTryRemoveDuplicates() {
        self.data.removeAll()
        struct Point {
            let x: Int
            let y: Int
        }
        
        let points = [Point(x: 0, y: 0), Point(x: 0, y: 1),
                      Point(x: 1, y: 1), Point(x: 0, y: 1), Point(x: 2, y: 1)]
        
        points.publisher
            .tryRemoveDuplicates(by: { prev, current in
                if prev.x == 1 {
                    throw URLError(.badURL)
                }
                return prev.x == current.x
            })
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append("\(value)")
            }
            .store(in: &cancelable)
        
        publishData()
    }
    
    func startReplaceNil() {
        nilSubject
            .replaceNil(with: 1000)
            .map { String($0) }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] value in
                self?.data.append(value)
            }
            .store(in: &cancelable)
        
        publishDataWithNil()
    }
    
    func startReplaceError() {
        subject
            .tryMap { value in
                if value == 3 {
                    throw URLError(.badServerResponse) // value == 3 이 되면 에러를 던지므로 이후 값은 publish 되지 않음
                }
                return String(value)
            }
            .replaceError(with: "5000") // error가 발생했을 경우 대치할 값을 지정할 수 있음 and Stopped publish
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish map")
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

struct FilterReducingOperationTest: View {
    @State private var vm = FilterReducingOperationTestViewModel()
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button("map") {
                        vm.startMap()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("try map") {
                        vm.startTryMap()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("compact map") {
                        vm.startCompactMap()
                    }
                    .buttonStyle(.borderedProminent)
                } //: HStack
                
                HStack {
                    Button("Filter") {
                        vm.startFilter()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("remove duplication") {
                        vm.startRemoveDuplicates()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("remove duplication by") {
                        vm.startRemoveDuplicatesBy()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("try remove duplication") {
                        vm.startTryRemoveDuplicates()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                HStack {
                    Button("Replace nil") {
                        vm.startReplaceNil()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Replace Error") {
                        vm.startReplaceError()
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
    FilterReducingOperationTest()
}
