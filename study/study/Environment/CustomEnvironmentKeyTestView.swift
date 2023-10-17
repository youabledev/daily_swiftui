//
//  CustomEnvironmentKeyTestView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct CountKey: EnvironmentKey {
    static var defaultValue: Int = 100
}

extension EnvironmentValues {
    var customCounter: Int {
        get { self[CountKey.self] }
        set { self[CountKey.self] = newValue }
    }
}

struct CustomEnvironmentKeyTestView: View {
    @Environment(\.customCounter) var customCounter
    
    var body: some View {
        HStack {
//            Button {
                // get only property
//                customCounter = customCounter + 1
//            } label: {
//                Text("+")
//            }
            Text("\(customCounter)")
            CustomEnvironmentKeyTestSubView()
        }
        
    }
}

struct CustomEnvironmentKeyTestSubView: View {
    @Environment(\.customCounter) var customCounter
    
    var body: some View {
            Text(" + 또 다른 하위 뷰 : \(customCounter)")
    }
}

#Preview {
    CustomEnvironmentKeyTestView()
}
