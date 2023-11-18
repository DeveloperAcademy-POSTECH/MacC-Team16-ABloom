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
  
  @Binding var showSheet: Bool
  @Binding var checkContract: Bool
  
  var body: some View {
    VStack {
      WebView(urlString: urlString)
        .padding(.top, 20)
        .ignoresSafeArea(.all, edges: .bottom)
    }
    .customNavigationBar {
      Text("\(viewTitle)")
        .customFont(.bodyB)
    } leftView: {
      EmptyView()
    } rightView: {
      Button("확인") {
        showSheet = false
        checkContract = true
      }
      .customFont(.calloutB)
      .foregroundStyle(Color.purple700)
    }
  }
}

#Preview {
  NavigationStack {
    EmbedWebView(viewTitle: "문의하기", urlString: "https://www.google.com", showSheet: .constant(false), checkContract: .constant(false))
  }
}
