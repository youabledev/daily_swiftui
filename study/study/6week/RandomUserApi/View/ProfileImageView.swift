//
//  ProfileImageView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI
import URLImage

struct ProfileImageView: View {
    let urlImage: URL
    
    var body: some View {
        URLImage(urlImage) { image in
            image
                .resizable()
                .scaledToFit()
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.yellow, lineWidth: 2)
        )
    }
}

#Preview {
    ProfileImageView(urlImage: URL(string: "https://randomuser.me/api/portraits/men/75.jpg")!)
}
