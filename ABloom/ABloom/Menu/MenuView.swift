//
//  MenuView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MenuView: View {
  let listItemPadding: CGFloat = 32
  let versionInfoText: String = "v1.0.0"
  
  var body: some View {
    
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

#Preview {
  NavigationStack {
    MenuView()
  }
}


extension MenuView {
  private var topTitle: some View {
    HStack {
      Text("메뉴")
        .font(.title2Bold)
        .foregroundStyle(.stone700)
      
      Spacer()
    }
  }
  
  private var menuList: some View {
    VStack(spacing: listItemPadding) {
      MenuListItem(title: "내 계정") {
        MyAccountView()
      }
      
      MenuListItem(title: "연결 설정") {
        Text("feef")
      }
      
      MenuListItem(title: "문답 연구소") {
        Text("feef")
      }
      
      MenuListItem(title: "문의하기") {
        Text("feef")
      }
      
      MenuListItem(title: "약관과 정책") {
        Text("feef")
      }
      
      versionInfo
      
      Spacer()
    }
  }
  
  private var versionInfo: some View {
    HStack {
      Text("버전 정보")
        .font(.subHeadlineBold)
        .foregroundStyle(.stone800)
      
      Spacer()
      
      Text(versionInfoText)
        .foregroundStyle(.stone400)
        .bold()
    }
  }
}
