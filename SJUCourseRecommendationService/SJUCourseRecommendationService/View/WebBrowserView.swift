//
//  WebBrowserView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/08.
//

import SwiftUI
import WebKit

class WKWebViewModel: WKWebView, WKNavigationDelegate, ObservableObject {
    @Published var publishedCanGoBack = false
    @Published var publishedCanForward = false
    @Published var publishedIsLoading = false
    @Published var publishedProgress = 0.0
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        initViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initViewModel()
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    private func initViewModel() {
        self.navigationDelegate = self
        self.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    private func removeObservers() {
        removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        publishedCanGoBack = webView.canGoBack
        publishedCanForward = webView.canGoForward
        publishedIsLoading = webView.isLoading
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        publishedIsLoading = webView.isLoading
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        DispatchQueue.main.async {
            self.publishedProgress = self.estimatedProgress

        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    weak var webView: WKWebViewModel?

    init(url: URL, webView: WKWebViewModel) {
        self.url = url
        self.webView = webView
    }

    func makeUIView(context: Context) -> WKWebView {
        guard let web = webView else {
            return WKWebView()
        }
        web.configuration.userContentController.removeScriptMessageHandler(forName: "message")
        
        web.load(URLRequest(url: url))
        
        return web as WKWebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct WebBrowserView: View {
    @StateObject private var wKWebViewModel: WKWebViewModel = WKWebViewModel()
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        VStack {
            if wKWebViewModel.publishedIsLoading {
                ProgressView(value: wKWebViewModel.publishedProgress)
            }
            
            if let url = URL(string: url) {
                WebView(url: url, webView: wKWebViewModel)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
            }
            
            HStack {
                backButton()
                
                Spacer()
                
                forwardButton()
                
                Spacer()
                
                reloadButton()
                
                Spacer()
                
                shareButton()
                
                Spacer()
                
                safariButton()
            }
            .padding()
        }
        .tint(Color("SejongColor"))
        .background(Color("BackgroundColor"))
    }
    
    @ViewBuilder
    func backButton() -> some View {
        Button{
            if wKWebViewModel.publishedCanGoBack {
                self.wKWebViewModel.goBack()
            }
        } label: {
            Image(systemName: "chevron.backward")
                .font(.title3)
        }
        .disabled(!wKWebViewModel.publishedCanGoBack)
    }
    
    @ViewBuilder
    func forwardButton() -> some View {
        Button {
            if wKWebViewModel.publishedCanForward {
                self.wKWebViewModel.goForward()
            }
        } label: {
            Image(systemName: "chevron.forward")
                .font(.title3)
        }
        .disabled(!wKWebViewModel.publishedCanForward)
    }
    
    @ViewBuilder
    func reloadButton() -> some View {
        Button {
            self.wKWebViewModel.reload()
        } label: {
            Image(systemName: "arrow.clockwise")
                .font(.title3)
        }
    }
    
    @ViewBuilder
    func shareButton() -> some View {
        Button{
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.title3)
        }
    }
    
    @ViewBuilder
    func safariButton() -> some View {
        Button {
            guard let websiteURL = URL(string: url) else {
                return
            }

            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
        } label: {
            Image(systemName: "safari")
                .font(.title3)
        }
    }
}

struct WebBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        WebBrowserView(url: "https://www.apple.com")
    }
}
