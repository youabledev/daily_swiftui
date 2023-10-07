//
//  Reducer.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import Foundation

/// State와 Action을 매개변수로 받는 클로저
typealias Reducer<State, Action> = (inout State, Action) -> Void

/// 액션을 필터링해서 AppState에게 전달함
func appReducer(_ state: inout AppState, _ action: AppAction) {
    // 들어오는 액션에 따라 분기 처리 - 즉 필터링
    switch action {
    case .changeTheEmoji:
        // 앱의 상태를 변경
        state.currentEmoji = ["⏰", "⭐️", "👉", "🔗", "🙃"].randomElement() ?? "💳"
    }
}
