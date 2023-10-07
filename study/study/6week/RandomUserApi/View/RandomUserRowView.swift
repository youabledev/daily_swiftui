//
//  RandomUserRowView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI

struct RandomUserRowView: View {
    let randomUser: RandomUser
    
    var body: some View {
        HStack {
            ProfileImageView(urlImage: URL(string: randomUser.picture.thumbnail)!)
                .fontWeight(.heavy)
                .font(.system(size: 25))
                .lineLimit(2)
                .minimumScaleFactor(0.5) // shrink font size: 50% 까지 프레임에 맞추어 줄어 들 수 있음
            Text(randomUser.name.title)
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
        .padding()
        .background(.green.opacity(0.5))
    }
}

#Preview {
    RandomUserRowView(randomUser: RandomUser(userID: RandomUserID(name: "", value: ""), name: RandomUserName(title: "", first: "", last: ""), picture: RandomUserPicture(large: "", medium: "", thumbnail: "")))
}
