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
  let type: WebViewType
  
  @Environment(\.dismiss) var dismiss
  
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
      Button {
        dismiss()
      } label: {
        Image("angle-left")
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 18)
          .foregroundStyle(.purple700)
          .hidden(type == .sheet)
      }

    } rightView: {
      Button("확인") {
        showSheet = false
        checkContract = true
      }
      .customFont(.calloutB)
      .foregroundStyle(Color.purple700)
      .hidden(type == .navigation)
    }
  }
  
  enum WebViewType {
    case navigation
    case sheet
  }
}

#Preview {
  NavigationStack {
    EmbedWebView(viewTitle: "문의하기", urlString: "https://www.google.com", type: .sheet, showSheet: .constant(false), checkContract: .constant(false))
  }
}
