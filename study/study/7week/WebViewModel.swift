//
//  WebViewModel.swift
//  study
//
//  Created by zumin you on 2023/10/16.
//

import Foundation
import Combine

typealias WEB_NAVIGATION = WebViewModel.NAVIGATION

class WebViewModel: ObservableObject {
    enum NAVIGATION {
        case BACK, FORWARD, REFRESH
    }
    
    enum UrlType {
        case naver
        case google
        case custom
        
        var url: URL? {
            switch self {
            case .naver: return URL(string: "https://www.naver.com")
            case .google: return URL(string: "https://www.google.com")
            case .custom: return URL(string: "https://youabledev.github.io/daily_swiftui/files/index.html")
            }
        }
    }
    
    /// 웹뷰의 url이 변경되면 이벤트를 전달
    var changedUrlSubject = PassthroughSubject<WebViewModel.UrlType, Never>()
    
    /// 웹뷰 네비게이션 액션에 대한 이벤트
    var webNavigationSubject = PassthroughSubject<WEB_NAVIGATION, Never>()
    
    /// 웹사이트 타이틀 이벤트
    var webTitleSubject = PassthroughSubject<String, Never>()
    
    /// iOS -> JS 함수 호출
    var nativeToJSEvent = PassthroughSubject<String, Never>()
    
    /// JS Alert 들어오면 이벤트
    var jsAlertEvent = PassthroughSubject<JSAlert, Never>()
}
