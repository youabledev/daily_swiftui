//
//  RowView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct RowView: View {
    let product: Product
    
    var body: some View {
        let _ = print("body draw:::", product.name)
        HStack {
            Text(product.name)
                .font(.headline)
                .fontWeight(.bold)
            Text("\(product.price) 원")
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(.green.opacity(0.3))
    }
}

#Preview {
    RowView(product: Product(name: "dummy data", price: 3000))
}
