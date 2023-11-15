//
//  ObservedObjectCarFactoryTestView.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import SwiftUI

struct ObservedObjectCarFactoryTestView: View {
    @ObservedObject var model =  ObservedCarFactory()
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            DebuggingTextView(text: model.address)
            Text(model.car.name)
            Toggle("is open?", isOn: $model.isOpen)
            TextField("car name", text: $model.car.name)
            Button("car name change") {
                model.car.name = "tester" // 인스턴스 내부의 변화를 Published로 감지할 수 없음
//                model.isOpen = true // 값 타입이기 때문에 변경 가능
            }
        }
        
    }
}

#Preview {
    ObservedObjectCarFactoryTestView()
}
