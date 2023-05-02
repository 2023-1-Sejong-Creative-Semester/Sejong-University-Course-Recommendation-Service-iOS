//
//  WebBrowserView.swift
//  SJUCourseRecommendationService
//
//  Created by 김도형 on 2023/04/08.
//

import SwiftUI
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let webView: WKWebView
    
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        let progressView = UIProgressView(progressViewStyle: .default)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(webView)
        containerView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: containerView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: containerView.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
        ])
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let webView = uiView.subviews.first(where: { $0 is WKWebView }) as? WKWebView else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject {
        let progressView = UIProgressView(progressViewStyle: .default)
        
        override init() {
            super.init()
            
            progressView.progressTintColor = UIColor(Color("SejongColor"))
            progressView.trackTintColor = .clear
        }
        
        deinit {
            progressView.removeFromSuperview()
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress), let progress = change?[.newKey] as? Double {
                didUpdateProgress(progress)
            }
        }
        
        func didUpdateProgress(_ progress: Double) {
            progressView.setProgress(Float(progress), animated: true)
        }
    }
}

struct WebBrowserView: View {
    let url: String
    
    @State private var canGoBackSubscriptions = PassthroughSubject<Bool, Never>()
    @State private var canGoForwardSubscriptions = PassthroughSubject<Bool, Never>()
    @State private var webView: WKWebView = WKWebView()
    @State private var canGoBack = false
    @State private var canGoForward = false
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        VStack {
            if let url = URL(string: url) {
                WebView(url: url, webView: webView)
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
            }
            .padding()
            .onAppear() {
                let _ = canGoBackSubscriptions.sink(receiveValue: { newValue in
                    DispatchQueue.main.async {
                        canGoBack = newValue
                    }
                })
                
                let _ = canGoForwardSubscriptions.sink(receiveValue: { newValue in
                    canGoForward = newValue
                })
            }
        }
        .onTapGesture {
            canGoBackSubscriptions.send(self.webView.canGoBack)
            print(#function)
        }
    }
    
    @ViewBuilder
    func backButton() -> some View {
        Button{
            if canGoBack {
                self.webView.goBack()
            }
        } label: {
            Image(systemName: "chevron.backward")
        }
        .disabled(!canGoBack)
    }
    
    @ViewBuilder
    func forwardButton() -> some View {
        Button {
            if canGoForward {
                self.webView.goForward()
            }
        } label: {
            Image(systemName: "chevron.forward")
        }
        .disabled(!self.webView.canGoForward)
    }
    
    @ViewBuilder
    func reloadButton() -> some View {
        Button {
            self.webView.reload()
        } label: {
            Image(systemName: "arrow.clockwise")
        }
    }
}

struct WebBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        WebBrowserView(url: "https://www.apple.com")
    }
}
