//
//  ProposedSizeTest.swift
//  study
//
//  Created by zumin you on 2023/11/10.
//

import SwiftUI

struct ProposedSizeTest: View {
    @State private var isOn: Bool = false
    @State private var text: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Circle() // undefined shape proposed size == required size
                    .frame(width: 50, height: 50) // Explicit Mode 명시된 사이즈 반환
                
                Button { } label: { Circle() }
                .buttonStyle(.borderedProminent)
                
                Button {
                    
                } label: {
                    Text("test")
                }
                .buttonStyle(.borderedProminent)
                
                TextField("test", text: $text)
                    .border(.red)
                
                HStack {
                    Text("testtesttest")
                        .background(.yellow)
                    Text("api")
                    // text have complex size
                } //: HStack
                .border(.green)
                
                HStack {
                    Toggle("test", isOn: $isOn) // reqired size는 proposed size를 반환
                        .background(.yellow)
//                        .frame(width: 100) // 프레임을 명시하면 이 뷰의 사이즈를 반환하고 HStack은 childView의 사이즈를 따를 수 밖에 없다.
                    // Textfield, picker, TextEditor, Toggle
                }
                .border(.black)
                
                VStack {
                    Text("테스트1")
                        .frame(width: 100, height: 100) // Explicit Size Mode
                        .background(.black.opacity(0.2))
                    Text("테스트1")
                        // Unspecified Mode
                        .background(.purple.opacity(0.5))
                    Text("테스트3")
                        .background(
                            Rectangle()
                                .fill(.green.opacity(0.3))
                                .frame(height: 100)
                        )
                        .border(Color.red)
                }
                .border(.blue)
            } //: VStack
            .border(.red, width: 7)
        } //: ZStack
        .border(.gray, width: 5)
//        .padding(.vertical, 100)
    }
}

#Preview {
    ProposedSizeTest()
}
