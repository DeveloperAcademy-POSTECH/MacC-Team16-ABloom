//
//  EmbedWebView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct EmbedWebView: View {
  let viewTitle: String
  let urlString: String
  
  var body: some View {
    VStack {
      WebView(urlString: urlString)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    .background(backgroundDefault())
    .navigationTitle(viewTitle)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    EmbedWebView(viewTitle: "문의하기", urlString: "https://www.google.com")
  }
}
