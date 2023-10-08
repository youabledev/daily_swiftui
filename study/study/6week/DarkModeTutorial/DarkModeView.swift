//
//  DarkModeView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI

struct DarkModeView: View {
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack {
            Them
                .myBackgroundColor(forScheme: scheme)
                .ignoresSafeArea()
            Text("Hello, World!")
        }
    }
}

#Preview {
    DarkModeView()
}

struct Them {
    static func myBackgroundColor(forScheme scheme: ColorScheme) -> Color {
        let lightColor = Color.white
        let darkColor = Color.blue
        
        switch scheme {
        case .light: return lightColor
        case .dark: return darkColor
        @unknown default: return lightColor
        }
    }
}
