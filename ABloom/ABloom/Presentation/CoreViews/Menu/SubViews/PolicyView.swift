//
//  PolicyView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct PolicyView: View {
  let listItemPadding: CGFloat = 32
  
  var body: some View {
    menuList
      .navigationTitle("약관과 정책")
      .navigationBarTitleDisplayMode(.inline)
      .padding(.horizontal, 20)
      .padding(.top, 24)
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
        EmbedWebView(viewTitle: "서비스 이용약관", urlString: "https://jaeseoklee.notion.site/9a4458152dd045ca82f8010fb46c5776")
      }
      
      MenuListNavigationItem(title: "개인정보 처리방침") {
        EmbedWebView(viewTitle: "개인정보 처리방침", urlString: "https://jaeseoklee.notion.site/Mery-78953ca6310b40209cb993312bbf9339")
      }
      
      Spacer()
    }
  }
}
