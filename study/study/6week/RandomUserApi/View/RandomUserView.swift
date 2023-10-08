//
//  RandomUserView.swift
//  study
//
//  Created by zumin you on 2023/10/08.
//

import SwiftUI
import SwiftUIIntrospect

class RefreshControlHelper {
    var parentContentView: RandomUserView?
    var refreshControl: UIRefreshControl?
    
    @objc func didRefresh() {
        guard let parentContentView = parentContentView,
              let refreshControl = refreshControl else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//            parentContentView.viewModel.fetchRandomUsers()
            parentContentView.viewModel.refreshActionSubject.send( )
            print("refresh 끝남")
            refreshControl.endRefreshing()
        }
    }
}

struct RandomUserView: View {
    private let refreshControlHelper = RefreshControlHelper()
    
    @ObservedObject var viewModel = RandomUserViewModel()
    
    var body: some View {
        List(viewModel.randomUsers) { randomUser in
            RandomUserRowView(randomUser: randomUser)
        }
        .introspect(.list, on: .iOS(.v17), customize: configureRefreshControl(_:))
    }
}

extension RandomUserView {
    fileprivate func configureRefreshControl(_ tableView: UICollectionView) {
        let refreshControl = UIRefreshControl()
        refreshControlHelper.refreshControl = refreshControl
        refreshControlHelper.parentContentView = self
        refreshControl.addTarget(refreshControlHelper, action: #selector(refreshControlHelper.didRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

#Preview {
    RandomUserView()
}
