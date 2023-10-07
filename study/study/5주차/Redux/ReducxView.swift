//
//  ReducxView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

/// # Reducx
/// - store: 앱 전체의 상태를 가지고 있음. view에 바인딩이 되어 있어, 스토어가 변경되면 View의 UI가 업데이트 됨
/// - action: 리듀서에게 상태 변경을 알림
/// - reducer: 현재 앱 상태를 받거나 앱 상태를 변경하기 위해 액션을 보냄

struct ReducxView: View {
    // reducer로 전달되는 함수는 클로저처럼 실행하게 됨
    @StateObject var store = AppStore(state: AppState(currentEmoji: "😌"), reducer: appReducer(_:_:))
    var body: some View {
        DiceView()
            .environmentObject(store)
    }
}

#Preview {
    ReducxView()
}
