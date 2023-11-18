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
