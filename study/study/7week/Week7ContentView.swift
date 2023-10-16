//
//  Week7ContentView.swift
//  study
//
//  Created by zumin you on 2023/10/15.
//

import SwiftUI

// https://youabledev.github.io/daily_swiftui/files/index.html

struct Week7ContentView: View {
    @EnvironmentObject var webViewModel: WebViewModel
    
    @State var textString = ""
    @State var shouldShowAlert = false
    @State var webTitle: String = ""
    @State var isAlertShow: Bool = false
    @State var jsAlert: JSAlert?
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    CustomWebView(urlToLoad: "https://youabledev.github.io/daily_swiftui/files/index.html")
                    webViewBottomTabbar
                } //: HStack
                .navigationTitle(Text(webTitle))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        siteMenu // 꾹 눌러야 호출됨
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("오른쪽 버튼") { self.shouldShowAlert.toggle() }
                    }
                }
                .alert(item: $jsAlert) { alert in
                    createAlert(alert)
                } // will deprecate
                
                if self.shouldShowAlert {
                    createTextAlert()
                }
            } //: ZStack
            .onReceive(webViewModel.webTitleSubject, perform: { webTitle in
                self.webTitle = webTitle
            })
            .onReceive(webViewModel.jsAlertEvent, perform: { jsAlert in
                self.jsAlert = jsAlert
                self.isAlertShow.toggle()
            })
        } //: NavigationView
    }
    
    // MARK: - Bottom TabBar
    var webViewBottomTabbar: some View {
        VStack {
            Divider()
            HStack {
                Spacer()
                Button {
                    webViewModel.webNavigationSubject.send(.BACK)
                } label: {
                    Image(systemName: "arrow.backward")
                } //: Button
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button {
                    webViewModel.webNavigationSubject.send(.FORWARD)
                } label: {
                    Image(systemName: "arrow.forward")
                } //: Button
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Button {
                    webViewModel.webNavigationSubject.send(.REFRESH)
                } label: {
                    Image(systemName: "goforward")
                }
                Spacer()
            }
            .frame(height: 45)
            Divider()
        }
    }
    
    // MARK: - Site Menu
    var siteMenu: some View {
        Text("사이트 이동")
            .foregroundStyle(.blue)
            .contextMenu(ContextMenu(menuItems: {
                Button("커스텀 웹뷰 이동") {
                    webViewModel.changedUrlSubject.send(.custom)
                }
                Button("네이버 이동") {
                    webViewModel.changedUrlSubject.send(.naver)
                }
                Button("구글 이동") {
                    webViewModel.changedUrlSubject.send(.google)
                }
            }))
    }
}

extension Week7ContentView {
    func createAlert(_ alert: JSAlert) -> Alert {
        Alert(title: Text(alert.type.description), message: Text(alert.message), dismissButton: .default(Text("확인"), action: {
            print("확인 클릭")
        }))
    }
    
    func createTextAlert() -> TextFieldAlertView {
        TextFieldAlertView(title: "전달할 값을 입력", message: "보내기", textString: $textString, showAlert: $shouldShowAlert)
    }
}

#Preview {
    Week7ContentView()
        .environmentObject(WebViewModel())
}
