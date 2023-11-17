//
//  MenuView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MenuView: View {
  @Binding var selectedTab: Tab
  
  let listItemPadding: CGFloat = 32
  let versionInfoText: String = "v1.1.0"
  
  var body: some View {
    NavigationStack {
      VStack {
        topTitle
          .padding(.bottom, 40)
          .padding(.top, 19)
        
        menuList
      }
      .padding(.horizontal, 20)
      .background(backgroundDefault())
    }
  }
}

#Preview {
  NavigationStack {
    MenuView(selectedTab: .constant(.info))
  }
}


extension MenuView {
  private var topTitle: some View {
    HStack {
      Text("메뉴")
        .fontWithTracking(.title2B)
        .foregroundStyle(.stone700)
      
      Spacer()
    }
  }
  
  private var menuList: some View {
    VStack(spacing: listItemPadding) {
      MenuListNavigationItem(title: "내 계정") {
        MyAccountView(selectedTab: $selectedTab)
      }
      
      MenuListNavigationItem(title: "연결 설정") {
//        MyAccountConnectingView()
        ConnectionWaypointView()
      }
      
      MenuListNavigationItem(title: "질문 제작소") {
        EmbedWebView(viewTitle: "질문 제작소", urlString: ServiceWebURL.questionLab.rawValue)
      }
      
      MenuListNavigationItem(title: "고객센터") {
        EmbedWebView(viewTitle: "고객센터", urlString: ServiceWebURL.qna.rawValue)
      }
      
      MenuListNavigationItem(title: "약관과 정책") {
        PolicyView()
      }
      
      versionInfo
      
      Spacer()
    }
  }
  
  private var versionInfo: some View {
    HStack {
      Text("버전 정보")
        .fontWithTracking(.subHeadlineB)
        .foregroundStyle(.stone800)
      
      Spacer()
      
      Text(versionInfoText)
        .foregroundStyle(.stone400)
        .bold()
    }
  }
}
