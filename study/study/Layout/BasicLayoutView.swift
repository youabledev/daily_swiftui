//
//  BasicLayoutView.swift
//  study
//
//  Created by zumin you on 2023/11/12.
//

import SwiftUI

struct BasicLayoutView: View {
    @State private var isOn: Bool = false
    
    var body: some View {
        HStack {
            Toggle(isOn: $isOn, label: {
                Text("Label")
                    .background(.green)
            })
            .background(.yellow)
        }
        .border(.black)
        .padding()
        .background(.red)
    }
}

#Preview {
    BasicLayoutView()
}
