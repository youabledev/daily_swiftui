//
//  IdealSize.swift
//  study
//
//  Created by zumin you on 2023/11/09.
//

import SwiftUI

struct IdealSize: View {
    var body: some View {

        VStack {
            Text("Hello worldHello worldHello worldHello worldHello world")
                .lineLimit(2)
                .border(.red, width: 4)
                .fixedSize()
                .frame(idealWidth: 100, idealHeight: 100) // undifined 모드에서 proposed size를 전달받으면 ideal width , height를 전달
                .border(.green, width: 2)
            Text("A single line of text, too long to fit in a box.")
                .border(Color.red)
                .fixedSize() // view로 동작하며 ParentView의 Proposed size가 아닌 자신의 크기를 반환
                .frame(width: 200, height: 200)
                .border(Color.gray)
            
            Text("A single line of text, too long to fit in a box.")
                .frame(width: 200, height: 200)
                .border(Color.gray)
        }
        
    }
}

#Preview {
    IdealSize()
}
