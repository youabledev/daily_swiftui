//
//  SegmentLayoutView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

enum LayoutType: CaseIterable {
    case table, grid, triple
    
    var image: Image {
        switch self {
        case .table:
            return Image(systemName: "list.dash")
        case .grid:
            return Image(systemName: "square.grid.2x2.fill")
        case .triple:
            return Image(systemName: "square.grid.3x3.fill")
        }
    }
    
    var gridItems: [GridItem] {
        switch self {
        case .table:
            return [GridItem(.flexible())]
        case .grid:
            return [GridItem(.flexible()), GridItem(.flexible())]
        case .triple:
            return [GridItem(.adaptive(minimum: 100))]
        }
    }
}

struct SegmentLayoutView: View {
    @State private var selectedLayoutType: LayoutType = .table
    @ObservedObject private var viewModel = LazyVGridViewModel()
    
    var body: some View {
        VStack {
            Picker(selection: $selectedLayoutType) {
                ForEach(LayoutType.allCases, id: \.self) {
                    type in
                    type.image
                }
            } label: {
                Text("이것이 제목")
            } //: Picker
            .pickerStyle(.segmented)
            ScrollView {
                LazyVGrid(columns: selectedLayoutType.gridItems, content: {
                    switch selectedLayoutType {
                    case .table:
                        ForEach(viewModel.tableDatas, id: \.id) { data in
                            Text(data.number)
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(.green)
                        } //: ForEach
                    case .grid:
                        ForEach(viewModel.gridDatas, id: \.number) { data in
                            Text(data.number)
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(.green)
                        } //: ForEach
                    case .triple:
                        ForEach(viewModel.tripleDatas, id: \.id) { data in
                            Text(data.number)
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(.green)
                        } //: ForEach
                    }
//                    ForEach(viewModel.dummyDatas, id: \.id) { data in
//                        Text(data.number)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 100)
//                            .background(.green)
//                    } //: ForEach
                })
                .animation(.easeInOut, value: selectedLayoutType)
            } //: ScrollView
        } //: VStack
    }
}

#Preview {
    SegmentLayoutView()
}
