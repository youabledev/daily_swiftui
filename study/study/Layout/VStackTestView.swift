//
//  VStackTestView.swift
//  study
//
//  Created by zumin you on 2023/11/09.
//

import SwiftUI

extension View {
    func printSizeInfo(_ label: String = "") -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
//                        print(label, proxy.frame(in: .global).minX)
                    }
                    
            }
        )
    }
}

struct VStackTestView: View {
    var body: some View {
        ZStack {
            Color.black
            Circle()
                .foregroundStyle(.red)
                .offset(.init(width: 147.83, height: 0))
//            HStack {
//                Text("Hello, World!")
////                    .frame(width:50, height: 50) // ProposedSize를 무시하고 50 * 50을 상위 뷰에게 전달한다.
//            }
//            .background(.orange)
            
            ZStack {
                Text("Hello, World!")
                    .padding(.leading, 45)
                    .printSizeInfo()
                    
            }
            .background(.orange)
            
        }
    }
}

#Preview {
    VStackTestView()
}
