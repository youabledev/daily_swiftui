//
//  IntrospectInUseView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI
import SwiftUIIntrospect

struct IntrospectInUseView: View {
    var body: some View {
        ScrollView {
          Text("GREEN")
          Text("RED")
          Text("BLUE")
          Text("YELLOW")
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17)) { scrollView in
            scrollView.backgroundColor = .yellow
            scrollView.refreshControl = UIRefreshControl()
        }
    }
}

#Preview {
    IntrospectInUseView()
}
