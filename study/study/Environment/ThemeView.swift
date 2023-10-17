//
//  ThemeView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct ThemeView: View {
    @State private var layoutDirection: LayoutDirection = .rightToLeft
    var body: some View {
        // environment 설정을 안한 뷰
        RToLView()
        
        // environment 설정 한 뷰
        RToLView()
            .environment(\.layoutDirection, layoutDirection)
        
        Button {
            layoutDirection = layoutDirection == .rightToLeft ? .leftToRight : .rightToLeft
        } label: {
            Text("토글")
        }
        
        CustomEnvironmentKeyTestView()
            .environment(\.customCounter, 200)
    }
}

#Preview {
    ThemeView()
}
