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

struct CustomLoadingIndicatorView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(1.7, anchor: .center)
            .progressViewStyle(.circular)
            .scaleEffect(1.7, anchor: .center)
    }
}

struct RandomUserView: View {
    private let refreshControlHelper = RefreshControlHelper()
    
    @ObservedObject var viewModel = RandomUserViewModel()
    
    var body: some View {
        List(viewModel.randomUsers) { randomUser in
            RandomUserRowView(randomUser: randomUser)
                .onAppear { fetchMore(randomUser) }
        }
        .introspect(.list, on: .iOS(.v17), customize: configureRefreshControl(_:))
        
        if viewModel.isLoading {
            CustomLoadingIndicatorView()
        }
    }
}

extension RandomUserView {
    fileprivate func fetchMore(_ randomUser: RandomUser) {
        if self.viewModel.randomUsers.last == randomUser {
            viewModel.fetchMoreSubject.send()
        }
    }
    
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
