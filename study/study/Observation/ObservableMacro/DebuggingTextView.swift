//
//  DebuggingTextView.swift
//  study
//
//  Created by zumin you on 2023/11/15.
//

import SwiftUI

struct DebuggingTextView: View {
    var text: String
    
    var body: some View {
        let _ = print("Text View 다시 그려짐")
        Text(text)
    }
}

#Preview {
    DebuggingTextView(text: "")
}
