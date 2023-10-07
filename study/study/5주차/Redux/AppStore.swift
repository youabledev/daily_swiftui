//
//  AppStore.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import Foundation

// 모든 상태를 가지고 있음
typealias AppStore = Store<AppState, AppAction>

final class Store<State, Action>: ObservableObject {
    // 내부에서만 값을 변경할 수 있고, 외부에서는 읽을 수만 있음
    @Published private(set) var state: State // AppState를 observing 하게 됨
    
    // reducer 클로져
    private let reducer: Reducer<State, Action>
    
    init(state: State, reducer: @escaping Reducer<State, Action>) {
        self.state = state
        self.reducer = reducer
    }
    
    /// 액션을 실행하기 위한 함수
    func dispatch(action: Action) {
        // inout 매개변수를 넣을 때에는 &를 표시해 줘야 함
        // reducer 클로저를 사용해서 액션을 필터링 함
        reducer(&self.state, action)
    }
}
