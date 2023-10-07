//
//  DiceView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

struct DiceView: View {
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        VStack {
            Text(self.store.state.currentEmoji)
                .font(.system(size: 300, weight: .bold, design: .monospaced))
            
            Button {
                self.changeEmoji()
            } label: {
                Text("랜덤 이모지")
            } //: Button
            .buttonStyle(.borderedProminent)
        } //: VStack
    }
    
    // MARK: - Fuction
    func changeEmoji() {
        self.store.dispatch(action: .changeTheEmoji)
    }
}

#Preview {
    DiceView()
}
