//
//  CombineTestContentView.swift
//  study
//
//  Created by zumin you on 2023/11/17.
//

import SwiftUI

struct CombineTestContentView: View {
    var body: some View {
        List {
            NavigationLink("Swiftful Thinking Advanced Combine") {
                AdvancedCombineView()
            }
            
            NavigationLink("PassthroughSubject") {
                PassThroughPublisherTest()
            }
            
            NavigationLink("Sequence Operation") {
                SequenceOperationTest()
            }
            
            NavigationLink("Mathmatic Operation") {
                MathmaticOperationTest()
            }
            
            NavigationLink("Filter and Reducing Operation") {
                FilterReducingOperationTest()
            }
        } //: List
    }
}

#Preview {
    CombineTestContentView()
}
