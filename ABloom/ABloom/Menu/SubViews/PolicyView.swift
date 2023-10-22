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
      MenuListItem(title: "서비스 이용약관") {
        Text("서비스 이용 약관")
      }
      
      MenuListItem(title: "개인정보 처리방침") {
        Text("feef")
      }
      
      Spacer()
    }
  }
}
