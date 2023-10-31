//
//  PolicyView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct PolicyView: View {
  let listItemPadding: CGFloat = 32
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    menuList
      .padding(.horizontal, 20)
      .padding(.top, 24)
      .customNavigationBar {
        Text("약관과 정책")
      } leftView: {
        Button {
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
    PolicyView()
  }
}

extension PolicyView {
  private var menuList: some View {
    VStack(spacing: listItemPadding) {
      MenuListNavigationItem(title: "서비스 이용약관") {
        EmbedWebView(viewTitle: "서비스 이용약관", urlString: ServiceWebURL.termsOfuse.rawValue)
      }
      
      MenuListNavigationItem(title: "개인정보 처리방침") {
        EmbedWebView(viewTitle: "개인정보 처리방침", urlString: ServiceWebURL.privacyPolicy.rawValue)
      }
      
      Spacer()
    }
  }
}
