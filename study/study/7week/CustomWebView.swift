//
//  CustomWebView.swift
//  study
//
//  Created by zumin you on 2023/10/16.
//

import SwiftUI
import Combine
import WebKit

struct CustomWebView: UIViewRepresentable {
    @EnvironmentObject var webViewModel: WebViewModel
   
    var urlToLoad: String
    var refreshHelper = WebViewRefreshController()
    
    // ui view 만들기
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let webview = WKWebView(frame: .zero, configuration: createWKWebConfig())
        webview.uiDelegate = context.coordinator as? WKUIDelegate
        webview.navigationDelegate = context.coordinator as? WKNavigationDelegate
        webview.allowsBackForwardNavigationGestures = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshHelper.viewModel = webViewModel
        refreshHelper.refreshController = refreshControl
        refreshControl.addTarget(refreshHelper, action: #selector(WebViewRefreshController.didRefresh), for: .valueChanged)
        webview.scrollView.refreshControl = refreshControl
        webview.scrollView.bounces = true
        
        webview.load(URLRequest(url: url))
        
        return webview
        
    }
    
    // 업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<CustomWebView>) {
           
       }
    
    func createWKWebConfig() -> WKWebViewConfiguration {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
//        preferences.javaScriptEnabled = true // default value is true
        
        let wkWebConfiguration = WKWebViewConfiguration()
        
        let userContentController = WKUserContentController()
        userContentController.add(self.makeCoordinator(), name: "callbackHandler")
        wkWebConfiguration.userContentController = userContentController
        wkWebConfiguration.preferences = preferences
        return wkWebConfiguration
    }
    
    func makeCoordinator() -> CustomWebView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var customWebView: CustomWebView
        var subscription = Set<AnyCancellable>()
        
        init(_ customWebView: CustomWebView) {
            self.customWebView = customWebView
        }
    }
}

extension CustomWebView.Coordinator: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        self.customWebView.webViewModel.jsAlertEvent.send(JSAlert(message, type: .JS_ALERT))
        completionHandler()
    }
}

extension CustomWebView.Coordinator: WKNavigationDelegate {
    /// navigation action이 들어왔을 때
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        
        switch url.scheme {
        case "tel", "mailto":
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        default:
            switch url.host() {
            case "www.youtube.com":
                customWebView.webViewModel.jsAlertEvent.send(JSAlert(url.host(), type: .BLOCKED_SITE))
                decisionHandler(.cancel)
            default:
                decisionHandler(.allow)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        customWebView
            .webViewModel
            .webNavigationSubject
            .sink { action in
                switch action {
                case .BACK:
                    if webView.canGoBack {
                        webView.goBack()
                    }
                case .FORWARD:
                    if webView.canGoBack {
                        webView.goForward()
                    }
                case .REFRESH:
                    webView.reload()
                }
            }
            .store(in: &subscription)
    }
    
    // navigation 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (response, error) in
            if error != nil {
                print("error!!")
            }
            
            if let title = response as? String {
                self.customWebView.webViewModel.webTitleSubject.send(title)
            }
        }
        
        customWebView
            .webViewModel
            .changedUrlSubject
            .compactMap { $0.url }
            .sink { changedUrl in
                webView.load(URLRequest(url: changedUrl))
            }
            .store(in: &subscription)
        
        customWebView
            .webViewModel
            .nativeToJSEvent
            .sink { message in
                webView.evaluateJavaScript("nativeToJsEventCall('\(message)')") { (result, error) in
                    if let result = result {
                        
                    }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            .store(in: &subscription)
    }
}

extension CustomWebView.Coordinator: WKScriptMessageHandler {
    // webView JS
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callbackHandler" {
            print(message.body)
            if let receivedData: [String: String] = message.body as? Dictionary {
                print("\(receivedData)")
                customWebView.webViewModel.jsAlertEvent.send(JSAlert(receivedData["message"], type: .JS_BRIDGE))
            }
        }
    }
    
    
}

#Preview {
    CustomWebView(urlToLoad: "https://www.naver.com")
        .environmentObject(WebViewModel())
}
