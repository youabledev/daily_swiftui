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
        }
    }
}

#Preview {
    CombineTestContentView()
}
