//
//  EmbedWebView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct EmbedWebView: View {
  @Environment(\.dismiss) private var dismiss

  let viewTitle: String
  let urlString: String
  
  var body: some View {
    VStack {
      WebView(urlString: urlString)
        .padding(.top, 20)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    .customNavigationBar {
      Text("\(viewTitle)")
    } leftView: {
      Button {
        print("tapped")
        dismiss()
      } label: {
        NavigationArrowLeft()
      }
    } rightView: {
      EmptyView()
    }
    .background(backgroundDefault())
  }
}

#Preview {
  NavigationStack {
    EmbedWebView(viewTitle: "문의하기", urlString: "https://www.google.com")
  }
}
