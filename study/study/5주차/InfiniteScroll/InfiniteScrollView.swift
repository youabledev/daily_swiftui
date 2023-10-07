//
//  InfiniteScrollView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct InfiniteScrollView: View {
    
    @StateObject var viewModel = InfiniteScrollViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.products, id: \.id) { product in
                    RowView(product: product)
                        .onAppear {
                            viewModel.requestProductsWith(id: product.id)
                        }
                }
            }
            .task {
                viewModel.requestProductsWith()
            }
        }
    }
}

#Preview {
    InfiniteScrollView()
}
