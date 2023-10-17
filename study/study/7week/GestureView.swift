//
//  GestureView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct GestureView: View {
    @State private var singleTapped: Bool = false
    @State private var doubleTapped: Bool = false
    @State private var tripleTapped: Bool = false
    
    var singleTap: some Gesture {
        TapGesture()
            .onEnded { _ in
                print("single tap ended")
                singleTapped.toggle()
            }
    }
    
    var doubleTap: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                print("double tap ended")
                doubleTapped.toggle()
            }
    }
    
    var tripleTap: some Gesture {
        TapGesture(count: 3)
            .onEnded { _ in
                print("triple tap ended")
                tripleTapped.toggle()
            }
    }
    
    var body: some View {
        VStack {
            Group {
                Circle()
                    .fill(singleTapped ? .black : .blue)
                    .overlay(Text("싱글탭"))
                    .gesture(singleTap)
        
                Circle()
                    .fill(doubleTapped ? .black : .gray)
                    .overlay(Text("더블탭"))
                    .gesture(doubleTap)
                
                Circle()
                    .fill(tripleTapped ? .black : .green)
                    .overlay(Text("트리플탭"))
                    .gesture(tripleTap)
            }
            .frame(width: 100)
        }
    }
}

#Preview {
    GestureView()
}
