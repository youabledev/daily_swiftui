//
//  MenuView.swift
//  study
//
//  Created by zumin you on 2023/10/03.
//

import SwiftUI

/// # Menu를 만드는 방법
/// - View에 ContextMenu 붙이기
/// - ToolbarItem 사용하기

struct MenuView: View {
    let myMenu = ["메뉴리스트1", "메뉴리스트2", "메뉴리스트3"]
    @State private var selected: Int = 0
    
    var body: some View {
        NavigationStack {
            Text("Hello, World!")
                .navigationTitle("Menu 연습하기")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        // ToolbarItem을 누르면 해당 클로저에 있는 Content가 나타남
                        Menu {
                            // ViewBuilder로 되어 있기 때문에 VStack 처럼 여러개의 뷰를 작성해 줄 수 있음
                            // 메뉴 목록
                            Section {
                                Button {
                                    print("action0")
                                    // button이 눌리면 Menu는 자동으로 닫힘
                                } label: {
                                    Label("메뉴0", systemImage: "square.and.arrow.up")
                                }
                            }
                            
                            Section {
                                Text("menu 1")
                                Text("menu 2")
                            }
                            
                            // picker 넣으면 선택 표시 나타남 
                            Picker(selection: $selected) {
                                ForEach(myMenu.indices, id: \.self) { index in
                                    Text(myMenu[index])
                                }
                            } label: {
                                Text("메뉴 선택!")
                            }

                        } label: {
                            // 메뉴 버튼 UI 지정
//                            Circle()
//                                .foregroundStyle(.yellow)
//                                .frame(width: 80, height: 80)
//                                .overlay {
//                                    Label(
//                                        title: { Text("Label") },
//                                        icon: { Image(systemName: "ellipsis") }
//                                    )
//                                }
//                            Label(
//                                title: { Text("Label") },
//                                icon: { Image(systemName: "ellipsis").font(.system(.headline)).frame(width: 100, height: 100) }
                            Image(systemName: "ellipsis")
                                .font(.headline)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.black)
                                .background(.yellow)
                                .clipShape(Circle())
                        } //: Menu
                    } //: ToolbarItem
                } //: .toolbar
        } //: NavigationStack
    }
}

#Preview {
    MenuView()
}
