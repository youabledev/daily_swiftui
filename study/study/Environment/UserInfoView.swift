//
//  UserInfoView.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import SwiftUI

struct UserInfoView: View {
    @State private var userInfo = UserInfo(name: "테스트 유저", age: 13, phoneNumber: "010-1234-1234")
    
    var body: some View {
        UserIDCardView()
            .environment(userInfo)
    }
}

struct UserIDCardView: View {
    @Environment(UserInfo.self) private var userInfo
    
    var body: some View {
        VStack {
            HStack {
                Text("이름")
                    .font(.headline)
                Spacer()
                Text(userInfo.name)
            } //: HStack
            
            HStack {
                Text("나이")
                    .font(.headline)
                Spacer()
                Text("\(userInfo.age) 살")
            } //: HStack
            
            HStack {
                Text("전화번호")
                    .font(.headline)
                Spacer()
                Text(userInfo.phoneNumber)
            } //: HStack
            
            TextField("\(userInfo.name)", text: .constant(userInfo.name))
        } //: VStack
        .padding(.horizontal, 20)
    }
}

#Preview {
    UserInfoView()
}
