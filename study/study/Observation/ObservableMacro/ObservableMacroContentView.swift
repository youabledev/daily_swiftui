//
//  ObservableMacroContentView.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import SwiftUI

struct ObservableMacroContentView: View {
    var body: some View {
        List {
            NavigationLink("ObservableObject View update test") {
                ObservedObjectCarFactoryTestView()
            }
            
            NavigationLink("Observation View update test") {
                ObservableTestView()
            }
        }
    }
}

#Preview {
    ObservableMacroContentView()
}
