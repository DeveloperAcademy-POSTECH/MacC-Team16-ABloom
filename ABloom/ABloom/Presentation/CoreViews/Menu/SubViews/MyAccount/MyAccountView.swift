//
//  MyAccountView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MyAccountView: View {
  let avatarSize: CGFloat = 70
  
  @StateObject var myAccountVM = MyAccountViewModel()
  
  var body: some View {
    VStack(alignment: .leading) {
      userInfo
        .padding(.bottom, 50)
        .padding(.top, 40)
      
      accountMenuList
      
      Spacer()
    }
    .task {
      try? await myAccountVM.getMyInfo()
    }
    .navigationTitle("내 계정")
    .navigationBarTitleDisplayMode(.inline)
    .padding(.horizontal, 25)
    .background(backgroundDefault())
  }
}

#Preview {
  NavigationView {
    MyAccountView()
  }
}

extension MyAccountView {
  private var userInfo: some View {
    HStack(spacing: 15) {
      Image("avatar_Female circle GradientBG")
        .resizable()
        .scaledToFit()
        .frame(width: avatarSize)
      
      VStack(alignment: .leading) {
        Text(myAccountVM.userName ?? "정보 없음")
          .fontWithTracking(fontStyle: .title3Bold)
          .foregroundStyle(.stone800)
        HStack {
          Text("결혼까지 D-\(myAccountVM.dDay ?? 0)")
            .fontWithTracking(fontStyle: .footnoteR)
          
          Spacer()
          
          Text("정보 수정하기 >")
            .fontWithTracking(fontStyle: .footnoteR)
        }
        .foregroundStyle(.stone500)
      }
    }
  }
  
  private var accountMenuList: some View {
    VStack(alignment: .leading, spacing: 30) {
      Text("내 계정 관리")
        .fontWithTracking(fontStyle: .headlineBold)
      
      MenuListItem(title: "로그아웃") {
        Text("로그아웃")
      }
      
      MenuListItem(title: "회원탈퇴") {
        Text("회원탈퇴")
      }
    }
  }
}
