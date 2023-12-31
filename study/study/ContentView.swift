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
                        .environmentObject(WebViewModel())
                }
                
                NavigationLink("Environment & EnvironmentObject") {
                    ThemeView()
                        .environment(\.layoutDirection, .rightToLeft)
                }
                
                NavigationLink("Injecting Observable with environment") {
                    UserInfoView()
                }
                
                NavigationLink("Observation") {
                    ObservationContentView()
                }
                
                NavigationLink("Combine") {
                    CombineTestContentView()
                }
                
            } //: List
        } //: NavigationStack
    }
}

#Preview {
    ContentView()
}
