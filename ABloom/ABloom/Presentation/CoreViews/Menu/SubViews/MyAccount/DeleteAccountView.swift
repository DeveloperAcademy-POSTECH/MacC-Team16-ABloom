//
//  DeleteAccountView.swift
//  ABloom
//
//  Created by Lee Jinhee on 10/30/23.
//

import SwiftUI

struct DeleteAccountView: View {
  @Environment(\.dismiss) private var dismiss

  private let title = "메리를 탈퇴하시나요?"
  private let content1 = "지금까지 메리를 이용해주셔서 감사합니다.\n회원님께 더 나은 서비스를 제공해드리지 못한 것 같아 무거운 마음이 큽니다.\n\n"
  private let content2 = "이제 탈퇴하기를 누르시면 회원탈퇴가 진행되며, 저장된 개인정보가 안전하게 삭제되고 연결되어있던 상대방과의 연결이 자동으로 해제됩니다.\n\n"
  private let content3 = "앞으로 계속 노력하고 발전하는 메리가 되어 회원님을 다시 만날 수 있기를 바라며, 회원님의 앞날을 항상 응원하겠습니다."
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(title)
        .foregroundStyle(.stone900)
        .fontWithTracking(.title3Bold)
        .padding(.bottom, 18)
      Text(content1 + content2 + content3)
        .foregroundStyle(.stone700)
        .fontWithTracking(.subHeadlineR, tracking: -0.4)
      
      Spacer()
      
      Button {
      // TODO: 회원탈퇴 & 로그인뷰 이동
      } label: {
        StoneSingleBtn(text: "탈퇴하기")
      }
      .padding(.bottom, 20)
      
      // TODO: NavigationStack 초기화로 리팩토링
      NavigationLink(destination: HomeView()) {
        PurpleSingleBtn(text: "다시 사용하기")
      }
    }
    .padding(.top, 54)
    .padding(.horizontal, 20)
    .customNavigationBar(centerView: {
      Text("회원 탈퇴")
    }, leftView: {
      Button {
        dismiss()
      } label: {
        NavigationArrowLeft()
      }
    }, rightView: {
      EmptyView()
    })
    .background(backgroundDefault())
    .padding(.bottom, 40)
  }
}

#Preview {
  DeleteAccountView()
}