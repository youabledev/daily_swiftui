//
//  WebViewRefreshController.swift
//  study
//
//  Created by zumin you on 2023/10/17.
//

import UIKit

class WebViewRefreshController {
    var refreshController: UIRefreshControl?
    var viewModel: WebViewModel?
    
    @objc func didRefresh() {
        guard let refreshController = refreshController,
              let viewModel = viewModel else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.webNavigationSubject.send(.REFRESH)
            refreshController.endRefreshing()
        }
    }
}
