//
//  MyAccountView.swift
//  ABloom
//
//  Created by 정승균 on 10/22/23.
//

import SwiftUI

struct MyAccountView: View {
  let avatarSize: CGFloat = 70
  
  // ViewModel 생성 필요
  let userName: String = "최지은"
  let dDay: Int = 96
  
  var body: some View {
    VStack(alignment: .leading) {
      userInfo
        .padding(.bottom, 50)
        .padding(.top, 40)
      
      accountMenuList
      
      Spacer()
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
        Text(userName)
          .font(.title3Bold)
          .foregroundStyle(.stone800)
        HStack {
          Text("결혼까지 D-\(dDay)")
          Spacer()
          Text("정보 수정하기 >")
        }
        .font(.footnoteR)
        .foregroundStyle(.stone500)
      }
    }
  }
  
  private var accountMenuList: some View {
    VStack(alignment: .leading, spacing: 30) {
      Text("내 계정 관리")
        .font(.headlineBold)
      
      MenuListItem(title: "로그아웃") {
        Text("로그아웃")
      }
      
      MenuListItem(title: "회원탈퇴") {
        Text("회원탈퇴")
      }
    }
  }
}
