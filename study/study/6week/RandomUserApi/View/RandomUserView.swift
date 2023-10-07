//
//  RandomUserView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI

struct RandomUserView: View {
    @ObservedObject var viewModel = RandomUserViewModel()
    
    var body: some View {
        List(viewModel.randomUsers, id: \.id) { randomUser in
            RandomUserRowView(randomUser: randomUser)
        }
    }
}

#Preview {
    RandomUserView()
}
