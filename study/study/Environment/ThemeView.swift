//
//  ThemeView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct ThemeView: View {
//    @State private var layoutDirection: LayoutDirection = .rightToLeft
//    @State private var customCounter: Int = 200
    
    @State private var theme: Theme = ThemeMonoPink()
    
    var body: some View {
//        environmentTestView
        VStack {
            ThemeSubView()
            HStack {
                Circle()
                    .fill(ThemeDarkForest().background)
                    .frame(width: 50)
                    .onTapGesture {
                        theme = ThemeDarkForest()
                    }
                Circle()
                    .fill(ThemeMonoPink().background)
                    .frame(width: 50)
                    .onTapGesture {
                        theme = ThemeMonoPink()
                    }
            }
        }
        .customTheme(theme)
        
    }
    
//    var environmentTestView: some View {
//        VStack {
//            // environment 설정을 안한 뷰
//            RToLView()
//            
//            // environment 설정 한 뷰
//            RToLView()
//                .environment(\.layoutDirection, layoutDirection)
//            
//            Button {
//                layoutDirection = layoutDirection == .rightToLeft ? .leftToRight : .rightToLeft
//            } label: {
//                Text("토글")
//            }
//            .padding(.bottom, 30)
//            
//            Button("+") {
//                customCounter += 1
//            }
//            
//            CustomEnvironmentKeyTestView()
//                .environment(\.customCounter, customCounter)
//            
//            Button("-") {
//                customCounter -= 1
//            }
//        }
//    }
}

struct ThemeSubView: View {
    @Environment(\.customTheme) var themeColor
    var body: some View {
        VStack {
            Text("title")
                .font(.largeTitle)
                .foregroundStyle(themeColor.mainTitle)
            Text("subtitle")
                .font(.title)
                .foregroundStyle(themeColor.subTitle)
        }
        .frame(width: 200, height: 200)
        .background(themeColor.background)
    }
}

#Preview {
    ThemeView()
}
