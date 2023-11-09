//
//  FrameAndFixedSize.swift
//  study
//
//  Created by zumin you on 2023/11/10.
//

import SwiftUI

struct FrameAndFixedSize: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("Hello, World!")
                .fixedSize() // ideal size의 뷰. 부모뷰의 사이즈를 무시함
                .border(.green)
                .frame(width: 50, height: 50) // 고정된 뷰사이즈. 이 사이즈를 Text에게 제안하지만 fixedSize에 의해 싱글라인 텍스트 크기가 고정됨
//                .clipped()
                .border(.red)
            
            Text("Hello, World!")
                .frame(width: 50, height: 50)
                .border(.red)
            
            Text("Hello, World!")
                .fixedSize()
                .border(.green)
                
        }
        .background(.yellow)
    }
}

#Preview {
    FrameAndFixedSize()
}
