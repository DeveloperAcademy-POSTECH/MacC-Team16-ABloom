//
//  WebView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let urlString: String?
  
  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    return webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    if let urlString = urlString, let url = URL(string: urlString) {
      let request = URLRequest(url: url)
      uiView.load(request)
    }
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  class Coordinator: NSObject, WKNavigationDelegate {
    var parent: WebView
    
    init(_ parent: WebView) {
      self.parent = parent
    }
  }
}
