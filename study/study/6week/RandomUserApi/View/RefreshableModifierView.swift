//
//  RefreshableModifierView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI

struct RefreshableModifierView: View {
    @ObservedObject var viewModel = RandomUserViewModel()
    
    var body: some View {
        List(viewModel.randomUsers) { randomUser in
            RandomUserRowView(randomUser: randomUser)
        }
        .refreshable {
            viewModel.refreshActionSubject.send()
        }
    }
}

#Preview {
    RefreshableModifierView()
}
