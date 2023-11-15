//
//  ObservationContentView.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import SwiftUI

struct ObservationContentView: View {
    var body: some View {
        List {
            NavigationLink("Observable Macro") {
                ObservableMacroContentView()
            }
        }
    }
}

#Preview {
    ObservationContentView()
}
