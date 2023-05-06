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
    
    func initViewModel() {
        self.navigationDelegate = self
        self.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
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
        publishedProgress = self.estimatedProgress
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    let webView: WKWebViewModel

    init(url: URL, webView: WKWebViewModel) {
        self.url = url
        self.webView = webView
    }

    func makeUIView(context: Context) -> WKWebView {
        webView.load(URLRequest(url: url))
        return webView as WKWebView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct WebBrowserView: View {
    @ObservedObject private var wKWebViewModel: WKWebViewModel = WKWebViewModel()
    
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
                Spacer()
                
                backButton()
                
                Spacer()
                
                forwardButton()
                
                Spacer()
                
                reloadButton()
                
                Spacer()
                
                shareButton()
                
                Spacer()
            }
            .padding()
        }
        .tint(Color("SejongColor"))
        .background(Color("BackgroundColor"))
        .onAppear() {
            wKWebViewModel.initViewModel()
        }
    }
    
    @ViewBuilder
    func backButton() -> some View {
        Button{
            if wKWebViewModel.publishedCanGoBack {
                self.wKWebViewModel.goBack()
            }
        } label: {
            Image(systemName: "chevron.backward")
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
        }
        .disabled(!wKWebViewModel.publishedCanForward)
    }
    
    @ViewBuilder
    func reloadButton() -> some View {
        Button {
            self.wKWebViewModel.reload()
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }
    
    @ViewBuilder
    func shareButton() -> some View {
        Button{
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

struct WebBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        WebBrowserView(url: "https://www.apple.com")
    }
}
