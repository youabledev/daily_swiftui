//
//  LazyVGridView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct MyModel: Identifiable {
    var id = UUID()
    var number: String
}

extension MyModel {
    static var dummyDatas: [MyModel] {
        (1...200).map { number in
            return MyModel(number: "\(number)번")
        }
    }
}

class LazyVGridViewModel: ObservableObject {
    @Published var dummyDatas: [MyModel]
    @Published var tableDatas: [MyModel]
    @Published var gridDatas: [MyModel]
    @Published var tripleDatas: [MyModel]
    
    init() {
        dummyDatas = (1...200).map { MyModel(number: "\($0)번")}
        tableDatas = (1...200).map { MyModel(number: "\($0)번")}
        gridDatas = (1...200).map { MyModel(number: "\($0)번")}
        tripleDatas = (1...200).map { MyModel(number: "\($0)번")}
    }
}
/// 화면에 보여지는 부분만 렌더링

struct LazyVGridView: View {
    
    @ObservedObject private var viewModel = LazyVGridViewModel()
    
    var body: some View {
        ScrollView {
            /// columns == 하나의 행에 몇개가 들어갈 것인지 정할 수 있음.
            /// .fixed : 고정 크기
            /// .adaptive 최소 크기로 행에 여러개를 채움
            /// .flexible : 최소 크기로 하나를 채우고 남는 여백이 있는 경우 여백 크기 만큼 늘어남
            LazyVGrid(columns: [GridItem(.fixed(120)), GridItem(.fixed(200))], content: {
                ForEach(viewModel.dummyDatas, id: \.id) { data in
                    Text(data.number)
                        .frame(width: 100, height: 100)
                        .background(.green)
                } //: ForEach
            })
        } //: ScrollView
    }
}

#Preview {
    LazyVGridView()
}

// TODO: more reload 만들기
