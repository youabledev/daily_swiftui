//
//  TestVStackView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct TestVStackView: View {
    
    @StateObject var viewModel = InfiniteScrollViewModel()
    
    var body: some View {
        let _ = print("TestVStackView body property draw")
        ScrollView {
            VStack {
                ForEach(viewModel.products, id: \.id) { product in
                    RowView(product: product)
                        .onAppear {
                            print("onAppear::: ", product.name)
                        }
                }
            }
            .task {
                print("데이터 호출")
                viewModel.requestProducts()
            }
            .onAppear {
                print("VStack 나타남")
            }
        }
    }
}

#Preview {
    TestVStackView()
}
