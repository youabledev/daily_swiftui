//
//  ContentView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationStack {
            List {
                NavigationLink("7 주차 강의") {
                    Week7ContentView()
                }
            } //: List
        } //: NavigationStack
    }
}

#Preview {
    ContentView()
}
