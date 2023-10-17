//
//  RToLView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct RToLView: View {
    
    var body: some View {
        HStack {
                Text("오늘 날씨")
                Image(systemName: "sun.min.fill")
                Text("맑음")
                    .foregroundStyle(.red)
        } //: HStack
    }
}

#Preview {
    RToLView()
}
