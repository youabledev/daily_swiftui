//
//  ObservableTestView.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import SwiftUI

struct ObservableTestView: View {
    @State var model = CarFactory(address: "Seoul", isOpen: true)
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            DebuggingTextView(text: model.address)
            Text(model.car.name)
            Toggle("is open?", isOn: $model.isOpen)
            TextField("car name", text: $model.car.name)
            Button("car name change") {
                // Car에 Observable 프로토콜을 붙여야 변경됨
                model.car.name = "tester"
            }
        }
        
    }
}

#Preview {
    ObservableTestView()
}
